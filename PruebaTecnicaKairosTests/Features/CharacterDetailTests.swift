//
//  CharacterDetailTests.swift
//  PruebaTecnicaKairosTests
//
//  Created by Daniel Personal on 11/11/21.
//

import XCTest
@testable import PruebaTecnicaKairos

class CharacterDetailTests: XCTestCase {
    let characterId = 1011334
    
    func testCharacterDetailModel() {
        let expectedCode =  200
        let expectedStatus = "Ok"
        let expectedResultsCount = 1
        let expectedResultId = 1011334
        let expectedResultName = "3-D Man"
        let expectedResultDescription = "3-D Description"
        let expectedResultThumbnailPath = "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"
        let expectedResultThumbnailExtension = "jpg"
        
        let data = LoadJsonHelper.loadJson(name: "CharacterDetailMock")
        guard let characterDetailModel = try? JSONDecoder().decode(CharacterDetailModel.self, from: data) else {
            XCTFail("Could not decode CharactersModel")
            return
        }
                
        XCTAssertEqual(characterDetailModel.code, expectedCode)
        XCTAssertEqual(characterDetailModel.status, expectedStatus)
        XCTAssertEqual(characterDetailModel.data.results.count, expectedResultsCount)
        XCTAssertEqual(characterDetailModel.data.results[0].characterId, expectedResultId)
        XCTAssertEqual(characterDetailModel.data.results[0].name, expectedResultName)
        XCTAssertEqual(characterDetailModel.data.results[0].description, expectedResultDescription)
        XCTAssertEqual(characterDetailModel.data.results[0].thumbnail.path, expectedResultThumbnailPath)
        XCTAssertEqual(characterDetailModel.data.results[0].thumbnail.extension, expectedResultThumbnailExtension)
    }

    func testCharacterDetailViewModel() {
        let viewModel = CharacterDetailViewModel()
        let testStringUrl = MarvelConstants.characterDetailUrl(id: characterId)
        let data = LoadJsonHelper.loadJson(name: "CharacterDetailMock")
        let statusCode = 200
        let expectation = expectation(description: "Load character detail")
        
        URLSessionMock.testsURLs = [testStringUrl: (data, statusCode)]
        
        viewModel.getDetail(id: characterId, sessionConfiguration: URLSessionMock.createConfiguration()) { maybeError in
            if let error = maybeError {
                XCTFail(error)
            }
            
            XCTAssertEqual(viewModel.characterDetail?.id, self.characterId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testCharacterDetailViewController() {
        let expectedTitle = "3-D Man"
        let expectedDescription = "3-D Description"
        let expectedComics = "12"
        let expectedSeries = "3"
        let expectedStories = "21"
        let expectedEvents = "1"
        
        let detailVC = CharacterDetailViewController.create(id: characterId, viewModel: CharacterDetailViewModelMock())
        detailVC.loadViewIfNeeded()
        detailVC.viewDidLoad()
        
        XCTAssertEqual(detailVC.title, expectedTitle)
        XCTAssertEqual(detailVC.descriptionLabel.text, expectedDescription)
        XCTAssertEqual(detailVC.comicsLabel.text, expectedComics)
        XCTAssertEqual(detailVC.seriesLabel.text, expectedSeries)
        XCTAssertEqual(detailVC.storiesLabel.text, expectedStories)
        XCTAssertEqual(detailVC.eventsLabel.text, expectedEvents)
    }
}
