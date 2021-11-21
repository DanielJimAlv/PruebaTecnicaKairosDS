//
//  CharacterDetailViewModel.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import Foundation

final class CharacterDetailViewModel {
    private let endPoint = "https://gateway.marvel.com/v1/public/characters"
    private let client = Client()

    var characterDetail: CharacterDetail?
    
    func getDetail(id: Int, completion: @escaping (String?) -> Void) {
        client.getData("\(endPoint)/\(id)", model: CharacterDetailModel.self, params: nil) { [weak self]  maybeDetail, maybeError in
            guard let self = self, let detail = maybeDetail else {
                completion(maybeError?.localizedDescription ?? "Error loading character detail")
                return
            }
            self.characterDetail = self.converDetail(detail)
            completion(nil)
        }
    }
    
    func cancel() {
        client.cancel()
    }
    
    private func converDetail(_ detail: CharacterDetailModel) -> CharacterDetail {
        var imageUrl: String?
        if let path = detail.data.results.first?.thumbnail.path, let ext = detail.data.results.first?.thumbnail.extension {
            imageUrl = "\(path).\(ext)"
            // Workaround path is http we need https (http url not secure)
            imageUrl = imageUrl?.replacingOccurrences(of: "http://", with: "https://")
        }
        
        let result = CharacterDetail(
            id: detail.data.results.first?.id ?? 0,
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
