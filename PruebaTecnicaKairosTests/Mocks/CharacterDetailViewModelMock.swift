//
//  CharacterDetailViewModelMock.swift
//  PruebaTecnicaKairosTests
//
//  Created by Daniel Personal on 22/11/21.
//

import Foundation
@testable import PruebaTecnicaKairos

class CharacterDetailViewModelMock: CharacterDetailViewModelProtocol {
    var characterDetail: CharacterDetail?
    
    func getDetail(id: Int, sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void) {
        let data = LoadJsonHelper.loadJson(name: "CharacterDetailMock")
        guard let characterDetailModel = try? JSONDecoder().decode(CharacterDetailModel.self, from: data) else {
            completion("Decode error")
            return
        }
        
        self.characterDetail = converDetail(characterDetailModel)
        completion(nil)
    }
}
