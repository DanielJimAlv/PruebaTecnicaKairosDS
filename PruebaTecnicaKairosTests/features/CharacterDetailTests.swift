//
//  CharacterDetailTests.swift
//  PruebaTecnicaKairosTests
//
//  Created by Daniel Personal on 11/11/21.
//

import XCTest
@testable import PruebaTecnicaKairos

class CharacterDetailTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCharacterDetail() {
        let viewModel = CharacterDetailViewModel()
        let characterId = 1011334
        let testStringUrl = MarvelConstants.characterDetailUrl(id: characterId)
        let data = LoadJsonHelper.loadJson(name: "CharacterDetail")
        let statusCode = 200
        let expectation = expectation(description: "Load character detail")
        
        URLSessionMock.testsURLs = [testStringUrl: (data, statusCode)]
        
        viewModel.getDetail(id: characterId, sessionConfiguration: URLSessionMock.createConfiguration()) { maybeError in
            if let error = maybeError {
                XCTFail(error)
            }
            
            XCTAssertEqual(viewModel.characterDetail?.id, characterId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
}
