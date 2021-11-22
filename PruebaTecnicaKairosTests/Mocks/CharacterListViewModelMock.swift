//
//  CharacterListViewModelMock.swift
//  PruebaTecnicaKairosTests
//
//  Created by Daniel Personal on 22/11/21.
//

import Foundation
@testable import PruebaTecnicaKairos

class CharacterListViewModelMock: CharacterViewModelProtocol {
    var characters: [CharacterMarvel] = []
    
    func getCharacters(with sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void) {
        let data = LoadJsonHelper.loadJson(name: "CharactersMock")
        guard let charactersModel = try? JSONDecoder().decode(CharactersModel.self, from: data) else {
            completion("Decode Error")
            return
        }
        
        self.characters = converCharacters(charactersModel.data.results)
    }
    
}
