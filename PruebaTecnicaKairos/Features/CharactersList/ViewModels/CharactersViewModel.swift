//
//  CharactersViewModel.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 10/11/21.
//

import Foundation

final class CharacterViewModel {
    private let endPoint = "https://gateway.marvel.com/v1/public/characters"
    private let client = Client()
    var characters: [CharacterModel] = []
    
    func getCharacters(completion: @escaping (String?) -> ()) {
        client.getData(endPoint, model: CharactersModel.self, params: nil) { [weak self]  maybeCharacters, maybeError in
            guard let characters = maybeCharacters?.data.results else {
                completion(maybeError?.localizedDescription ?? "Error loading characters")
                return
            }
            self?.characters = characters
            completion(nil)
        }
    }
    
    func cancel() {
        client.cancel()
    }
}
