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
    let results: [CharacterModel]
}

struct CharacterModel: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: CharacterThumbnail
}

struct CharacterThumbnail: Decodable {
    let path: String
    let `extension`: String
}

