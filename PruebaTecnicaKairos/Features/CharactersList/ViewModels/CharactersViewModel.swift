//
//  CharactersViewModel.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 10/11/21.
//

import UIKit

protocol CharacterViewModelProtocol {
    var characters: [CharacterMarvel] { get set }
    var hasMoreData: Bool { get set }
    var isLoadingData: Bool { get set }
    
    func getCharacters(with sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void)
    func converCharacters(_ characters: [CharacterModel]) -> [CharacterMarvel]
}
extension CharacterViewModelProtocol {
    func converCharacters(_ characters: [CharacterModel]) -> [CharacterMarvel] {
        var result: [CharacterMarvel] = []
        characters.forEach { character in
            let imageUrl = "\(character.thumbnail.path).\(character.thumbnail.extension)"
            let characterMarvel = CharacterMarvel(
                id: character.characterId,
                name: character.name,
                description: character.description,
                imageUrl: imageUrl)
            result.append(characterMarvel)
        }
        
        return result
    }
}

final class CharacterViewModel: CharacterViewModelProtocol {
    private let client = Client()
    
    var characters: [CharacterMarvel] = []
    var offset = 0
    var hasMoreData = true
    var isLoadingData = false
        
    func getCharacters(with sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void) {
        guard hasMoreData, !isLoadingData else {
            completion(nil)
            return
        }
        
        isLoadingData = true
        
        let params: [String: Any] = [
            MarvelConstants.limitParam: MarvelConstants.limit,
            MarvelConstants.offsetParam: offset
        ]
        client.getData(
            MarvelConstants.charactersUrl,
            model: CharactersModel.self,
            params: params,
            sessionConfiguration: nil) { [weak self] maybeCharacters, maybeError in
                self?.isLoadingData = false
                
                guard let self = self,
                      let charactersData = maybeCharacters?.data else {
                    completion(maybeError?.localizedDescription ?? "Error loading characters")
                    return
                }
                
                self.characters += self.converCharacters(charactersData.results)
                self.offset += charactersData.count + 1
                // swiftlint:disable empty_count
                self.hasMoreData = charactersData.count != 0
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
