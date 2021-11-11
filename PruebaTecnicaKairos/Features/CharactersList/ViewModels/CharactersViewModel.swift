//
//  CharactersViewModel.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 10/11/21.
//

import UIKit


final class CharacterViewModel {
    private let endPoint = "https://gateway.marvel.com/v1/public/characters"
    private let client = Client()
    
    var characters: [CharacterMarvel] = []
            
    func getCharacters(completion: @escaping (String?) -> ()) {
        client.getData(endPoint, model: CharactersModel.self, params: nil) { [weak self]  maybeCharacters, maybeError in
            guard let self = self, let characters = maybeCharacters?.data.results else {
                completion(maybeError?.localizedDescription ?? "Error loading characters")
                return
            }
            self.characters = self.converCharacters(characters)
            completion(nil)
        }
    }
    
    func cancel() {
        client.cancel()
    }
    
    private func converCharacters(_ characters: [CharacterModel]) -> [CharacterMarvel] {
        var result: [CharacterMarvel] = []
        characters.forEach { character in
            var imageUrl = "\(character.thumbnail.path).\(character.thumbnail.extension)"
            // Workaround path is http we need https (http url not secure)
            imageUrl = imageUrl.replacingOccurrences(of: "http://", with: "https://")
            result.append(CharacterMarvel(name: character.name, description: character.description, imageUrl: imageUrl))
        }
        
        return result
    }
}

struct CharacterMarvel {
    let name: String
    let description: String
    let imageUrl: String
}

