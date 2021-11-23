//
//  CharactersViewModel.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 10/11/21.
//

import UIKit

protocol CharacterViewModelProtocol {
    var characters: [CharacterMarvel] { get set }
    
    func getCharacters(with sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void)
    func converCharacters(_ characters: [CharacterModel]) -> [CharacterMarvel]
}
extension CharacterViewModelProtocol {
    func converCharacters(_ characters: [CharacterModel]) -> [CharacterMarvel] {
        var result: [CharacterMarvel] = []
        characters.forEach { character in
            var imageUrl = "\(character.thumbnail.path).\(character.thumbnail.extension)"
            // Workaround path is http we need https (http url not secure)
            imageUrl = imageUrl.replacingOccurrences(of: "http://", with: "https://")
            result.append(CharacterMarvel(id: character.id, name: character.name, description: character.description, imageUrl: imageUrl))
        }
        
        return result
    }
}

final class CharacterViewModel: CharacterViewModelProtocol {
    private let client = Client()
    
    var characters: [CharacterMarvel] = []
    
    func getCharacters(with sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void) {
        client.getData(
            MarvelConstants.charactersUrl,
            model: CharactersModel.self,
            params: nil,
            sessionConfiguration: sessionConfiguration) { [weak self]  maybeCharacters, maybeError in
            guard let self = self, let characters = maybeCharacters?.data.results else {
                completion(maybeError?.localizedDescription ?? "Error loading characters")
                return
            }
            self.characters = self.converCharacters(characters)
            completion(nil)
        }
    }
}

struct CharacterMarvel {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String
}
