//
//  Client.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import Foundation
import UIKit

enum ResposeError: Error {
    case responseError(String)
    case unknowError
}

struct ResponseErrorModel: Decodable {
    let code: Int
    let status: String
}

final class Client {
    private var task: URLSessionDataTask?
    private let defaultParams: [String: Any] = [
        "apikey": "cc681352ccababe03733a18696aafe66",
        "ts": 1,
        "hash": "b2b9ac5a976fb366de4d5efb90fc74ef"
    ]
        
    func getData<Model: Decodable>(_ stringUrl: String, model: Model.Type, params: [String : Any]? = nil, completion: @escaping (Model?, Error?) -> ())  {
        guard let url = URL(string: stringUrl) else {
            fatalError("url must be a valid url")
        }
        
        var usedParams = defaultParams
        if let params = params {
            params.forEach { key, value in
                usedParams[key] = value
            }
        }
        
        var components = URLComponents(string: stringUrl)
        components?.queryItems = usedParams.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
                
        task = URLSession.shared.dataTask(with: components?.url ?? url) { [weak self] maybeData, maybeResponse, maybeError in
            if let error = maybeError {
                self?.handleCompletion(model: nil, error: error, completion: completion)
            }
            
            if let response = maybeResponse as? HTTPURLResponse, response.statusCode != 200 {
                self?.handleError(response: response, data: maybeData, completion: completion)
                return
            }
            
            guard let data = maybeData else {
                self?.handleCompletion(model: nil, error: ResposeError.responseError("No data"), completion: completion)
                return
            }
            
            do {
                let modelResult = try JSONDecoder().decode(model.self, from: data)
                self?.handleCompletion(model: modelResult, error: nil, completion: completion)
            } catch {
                self?.handleCompletion(model: nil, error: error, completion: completion)
            }
            
        }
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func handleCompletion<Model: Decodable>(model: Model?, error: Error?, completion: @escaping (Model?, Error?) -> ()) {
        DispatchQueue.main.async {
            completion(model, error)
        }
    }
    
    private func handleError<Model: Decodable>(response: HTTPURLResponse, data: Data?, completion: @escaping (Model?, Error?) -> ()) {
        guard let data = data, let errorModel = try? JSONDecoder().decode(ResponseErrorModel.self, from: data) else {
            handleCompletion(model: nil, error: ResposeError.unknowError, completion: completion)
            return
        }
        
        handleCompletion(model: nil, error: ResposeError.responseError(errorModel.status), completion: completion)
    }
}


