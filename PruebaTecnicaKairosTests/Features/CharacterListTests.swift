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
    
    func testCharacterModel() {
        let expectedCode =  200
        let expectedStatus = "Ok"
        let expectedResultsCount = 20
        let expectedResultId = 1011334
        let expectedResultName = "3-D Man"
        let expectedResultDescription = "3-D Description"
        let expectedResultThumbnailPath = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"
        let expectedResultThumbnailExtension = "jpg"
        
        let data = LoadJsonHelper.loadJson(name: "CharactersMock")
        guard let charactersModel = try? JSONDecoder().decode(CharactersModel.self, from: data) else {
            XCTFail("Could not decode CharactersModel")
            return
        }
                
        XCTAssertEqual(charactersModel.code, expectedCode)
        XCTAssertEqual(charactersModel.status, expectedStatus)
        XCTAssertEqual(charactersModel.data.results.count, expectedResultsCount)
        XCTAssertEqual(charactersModel.data.results[0].id, expectedResultId)
        XCTAssertEqual(charactersModel.data.results[0].name, expectedResultName)
        XCTAssertEqual(charactersModel.data.results[0].description, expectedResultDescription)
        XCTAssertEqual(charactersModel.data.results[0].thumbnail.path, expectedResultThumbnailPath)
        XCTAssertEqual(charactersModel.data.results[0].thumbnail.extension, expectedResultThumbnailExtension)
    }

    func testCharacterViewModel() {
        let viewModel = CharacterViewModel()
        let testStringUrl = MarvelConstants.charactersUrl
        let data = LoadJsonHelper.loadJson(name: "CharactersMock")
        let statusCode = 200

        URLSessionMock.testsURLs = [testStringUrl: (data, statusCode)]
        
        let expectation = expectation(description: "Load characters")
        
        viewModel.getCharacters(with: URLSessionMock.createConfiguration()) { maybeError in
            if let error = maybeError {
                XCTFail(error)
            }
            
            XCTAssertEqual(viewModel.characters.count, 20)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testCharacterListViewController() {
        let expectedNumberOfRows = 20
        let identifier = CharactersListViewController.identifier
        let bundle = Bundle(for: CharactersListViewController.self)
        guard let characterVC =
                UIStoryboard(name: "Main", bundle: bundle)
                .instantiateViewController(withIdentifier: identifier) as? CharactersListViewController else {
            XCTFail("Could not instatiate CharacterListViewController")
            return
        }
        
        characterVC.viewModel = CharacterListViewModelMock()
        characterVC.loadViewIfNeeded()
        characterVC.viewDidLoad()
        
        XCTAssertEqual(characterVC.tableView.numberOfRows(inSection: 0), expectedNumberOfRows)
        
        guard let characterTableViewCell =
                characterVC.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CharacterTableViewCell else {
            XCTFail("Could not cast to CharacterTableViewCell")
            return
        }
        
        let expectedName = "Test Name"
        let expectedDescription = "Test Description"
        let imageUrl = "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"
        let characterMarvel = CharacterMarvel(id: 1, name: expectedName, description: expectedDescription, imageUrl: imageUrl)
        characterTableViewCell.prepareForReuse()
        XCTAssertEqual(characterTableViewCell.imageView?.image, nil)
        characterTableViewCell.setup(character: characterMarvel)
        XCTAssertEqual(characterTableViewCell.nameLabel.text, expectedName)
    }
}
