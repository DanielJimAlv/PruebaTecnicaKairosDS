//
//  CharacterListTests.swift
//  CharacterListTests
//
//  Created by Daniel Personal on 10/11/21.
//

import XCTest
@testable import PruebaTecnicaKairos

class CharacterListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClient() {
        let client = Client()
        let testUrl = "https://gateway.marvel.com/v1/public/characters"
        let expectedCount = 10
        
        let expectation = expectation(description: "Load characters data")
        
        client.getData(testUrl, model: CharactersModel.self, params: ["limit": expectedCount]) { maybeCharacters, maybeError in
            if let error = maybeError {
                XCTFail(error.localizedDescription)
            }
            
            if let caracters = maybeCharacters {
                XCTAssertEqual(caracters.data.results.count, expectedCount)
            } else {
                XCTFail("Could not unwrap characters")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testCharacterViewModel() {
        let viewModel = CharacterViewModel()
        let expectation = expectation(description: "Load characters")
        
        viewModel.getCharacters { maybeError in
            if let error = maybeError {
                XCTFail(error)
            }
            
            XCTAssertEqual(viewModel.characters.count, 20)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
