//
//  LoadJsonHelper.swift
//  PruebaTecnicaKairosTests
//
//  Created by Daniel Personal on 21/11/21.
//

import Foundation

class LoadJsonHelper {
    static func loadJson(name: String) -> Data {
        guard let url = Bundle(for: LoadJsonHelper.self).url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Data()
        }

        return data
    }
}
