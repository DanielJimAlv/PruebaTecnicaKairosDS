//
//  CharacterModel.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 10/11/21.
//

import Foundation

struct CharactersModel: Decodable {
    let code: Int
    let status: String
    let data: CharacterDataModel
}

struct CharacterDataModel: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [CharacterModel]
}

struct CharacterModel: Decodable {
    let characterId: Int
    let name: String
    let description: String
    let thumbnail: CharacterThumbnail
    
    enum CodingKeys: String, CodingKey {
        case characterId = "id"
        case name, description, thumbnail
    }
}

struct CharacterThumbnail: Decodable {
    let path: String
    let `extension`: String
    
    enum CodingKeys: CodingKey {
        case path, `extension`
    }
}

extension CharacterThumbnail {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.extension = try values.decode(String.self, forKey: .extension)
        let path = try values.decode(String.self, forKey: .path)
        self.path = path.replacingOccurrences(of: "http://", with: "https://")
    }
}
