//
//  Client.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import Foundation

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
    
    func getData<Model: Decodable>(_ stringUrl: String, model: Model.Type, params: [String: Any]? = nil, sessionConfiguration: URLSessionConfiguration?, completion: @escaping (Model?, Error?) -> Void) {
        let url = createUrl(with: params, stringUrl: stringUrl)
        
        var session = URLSession.shared
        if let sessionConfiguration = sessionConfiguration {
            session = URLSession(configuration: sessionConfiguration)
        }
        
        task = session.dataTask(with: url) { [weak self] maybeData, maybeResponse, maybeError in
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
        
    private func createUrl(with params: [String: Any]?, stringUrl: String) -> URL {
        guard let url = URL(string: stringUrl) else {
            fatalError("url must be a valid url")
        }
        
        if var params = params {
            var components = URLComponents(string: stringUrl)
            components?.queryItems?.forEach { item in
                params[item.name] = item.value
            }
            components?.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            return components?.url ?? url
        }
        
        return url
    }
    
    private func handleCompletion<Model: Decodable>(model: Model?, error: Error?, completion: @escaping (Model?, Error?) -> Void) {
        DispatchQueue.main.async {
            completion(model, error)
        }
    }
    
    private func handleError<Model: Decodable>(response: HTTPURLResponse, data: Data?, completion: @escaping (Model?, Error?) -> Void) {
        guard let data = data, let errorModel = try? JSONDecoder().decode(ResponseErrorModel.self, from: data) else {
            handleCompletion(model: nil, error: ResposeError.unknowError, completion: completion)
            return
        }
        
        handleCompletion(model: nil, error: ResposeError.responseError(errorModel.status), completion: completion)
    }
}
