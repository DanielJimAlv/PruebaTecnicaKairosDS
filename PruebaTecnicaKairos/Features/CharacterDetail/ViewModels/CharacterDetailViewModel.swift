//
//  CharacterDetailViewModel.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import Foundation

protocol CharacterDetailViewModelProtocol {
    var characterDetail: CharacterDetail? { get set }
    
    func getDetail(id: Int, sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void)
    func converDetail(_ detail: CharacterDetailModel) -> CharacterDetail
}
extension CharacterDetailViewModelProtocol {
    func converDetail(_ detail: CharacterDetailModel) -> CharacterDetail {
        var imageUrl: String?
        if let path = detail.data.results.first?.thumbnail.path, let ext = detail.data.results.first?.thumbnail.extension {
            imageUrl = "\(path).\(ext)"
        }
        
        let result = CharacterDetail(
            id: detail.data.results.first?.characterId ?? 0,
            name: detail.data.results.first?.name ?? "",
            description: detail.data.results.first?.description ?? "",
            imageUrl: imageUrl,
            comics: "\(detail.data.results.first?.comics.available ?? 0)",
            series: "\(detail.data.results.first?.series.available ?? 0)",
            stories: "\(detail.data.results.first?.stories.available ?? 0)",
            events: "\(detail.data.results.first?.events.available ?? 0)")
        
        return result
    }
}

final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    private let client = Client()

    var characterDetail: CharacterDetail?
    
    func getDetail(id: Int, sessionConfiguration: URLSessionConfiguration?, completion: @escaping (String?) -> Void) {
        let url = MarvelConstants.characterDetailUrl(id: id)
        client.getData(
            url, model: CharacterDetailModel.self,
            params: nil,
            sessionConfiguration: sessionConfiguration) { [weak self]  maybeDetail, maybeError in
            guard let self = self, let detail = maybeDetail else {
                completion(maybeError?.localizedDescription ?? "Error loading character detail")
                return
            }
            self.characterDetail = self.converDetail(detail)
            completion(nil)
        }
    }
    
}

struct CharacterDetail {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String?
    let comics: String
    let series: String
    let stories: String
    let events: String
}
