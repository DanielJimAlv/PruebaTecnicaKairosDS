//
//  URLSessionMock.swift
//  PruebaTecnicaKairosTests
//
//  Created by Daniel Personal on 21/11/21.
//

import Foundation

class URLSessionMock: URLProtocol {
    
    static var testsURLs: [String: (data: Data, statusCode: Int)] = [:]
    
    static func createConfiguration() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLSessionMock.self]
        return config
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let url = request.url,
           let testURL = URLSessionMock.testsURLs[url.absoluteString],
           let respose = HTTPURLResponse(url: url, statusCode: testURL.statusCode, httpVersion: nil, headerFields: nil) {
            client?.urlProtocol(self, didReceive: respose, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: testURL.data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
}
