//
//  File.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import Foundation

struct CharacterDetailModel: Decodable {
    let code: Int
    let status: String
    let data: CharacterDetailDataModel
}

struct CharacterDetailDataModel: Decodable {
    let results: [CharacterDetailResultsModel]
}

struct CharacterDetailResultsModel: Decodable {
    let characterId: Int
    let name: String
    let description: String
    let thumbnail: CharacterThumbnail
    let comics: CharacterDetailComics
    let series: CharacterDetailSeries
    let stories: CharacterDetailStories
    let events: CharacterDetailEvents
    
    enum CodingKeys: String, CodingKey {
        case characterId = "id"
        case name, description, thumbnail, comics, series, stories, events
    }
}

struct CharacterDetailComics: Decodable {
    let available: Int
}

struct CharacterDetailSeries: Decodable {
    let available: Int
}

struct CharacterDetailStories: Decodable {
    let available: Int
}

struct CharacterDetailEvents: Decodable {
    let available: Int
}
