//
//  MarvelConstants.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 21/11/21.
//

import Foundation

struct MarvelConstants {
    
    // swiftlint:disable variable_name
    
    private static let host = "https://gateway.marvel.com"
    private static let apiVersion = "v1"
    private static let characterEndPoint = "/public/characters"
    private static let apiKey = "cc681352ccababe03733a18696aafe66"
    private static let ts = 1
    private static let hash = "b2b9ac5a976fb366de4d5efb90fc74ef"
    
    static let offsetParam = "offset"
    static let limitParam = "limit"
    static let limit = 20

    static var charactersUrl: String {
        createCharacterUrl()
    }
    
    static func characterDetailUrl(id: Int) -> String {
        createCharacterUrl(id: String(id))
    }
    
    private static func createCharacterUrl(id: String? = nil) -> String {
        var characterId = ""
        if let id = id {
            characterId = "/\(id)"
        }
        
        return "\(host)/\(apiVersion)\(characterEndPoint)\(characterId)?apikey=\(apiKey)&ts=\(ts)&hash=\(hash)"
    }
    
}
