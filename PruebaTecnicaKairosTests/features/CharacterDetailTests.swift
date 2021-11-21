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
        let expectation = expectation(description: "Load character detail")
        let characterId = 1011334
        
        viewModel.getDetail(id: characterId) { maybeError in
            if let error = maybeError {
                XCTFail(error)
            }
            
            XCTAssertEqual(viewModel.characterDetail?.id, characterId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
}
