//
//  ClientTests.swift
//  PruebaTecnicaKairosTests
//
//  Created by Daniel Personal on 21/11/21.
//

import XCTest
@testable import PruebaTecnicaKairos

class ClientTests: XCTestCase {
    
    struct TestModel: Decodable {
        let test: String
        
        static func createData(string: String) -> Data {
            let json = """
            {"test":"\(string)"}
            """
            return Data(json.utf8)
        }
        
        static func createDataKO() -> Data {
            Data("-".utf8)
        }
    }
        
    var client: Client!

    override func setUpWithError() throws {
        client = Client()
    }

    override func tearDownWithError() throws {
        client = nil
    }

    func testClientOK() {
        let testStringUrl = "https://mockurl.com"
        let expectedValue = "Ok"
        let data = TestModel.createData(string: expectedValue)
        let statusCode = 200
        
        URLSessionMock.testsURLs = [testStringUrl: (data, statusCode)]
                
        let expectation = expectation(description: "Test client Expectation")
        
        client.getData(testStringUrl, model: TestModel.self, sessionConfiguration: URLSessionMock.createConfiguration()) { maybeTestModel, maybeError in
            if let error = maybeError {
                XCTFail(error.localizedDescription)
            }
            
            if let testModel = maybeTestModel {
                XCTAssertEqual(testModel.test, expectedValue)
            } else {
                XCTFail("Could not unwrap TestModel")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testClientKO() {
        let testStringUrl = "https://mockurl.com"
        let data = TestModel.createDataKO()
        let statusCode = 200

        URLSessionMock.testsURLs = [testStringUrl: (data, statusCode)]
        
        let expectation = expectation(description: "Test client Exptectation")
        
        client.getData(testStringUrl, model: TestModel.self, sessionConfiguration: URLSessionMock.createConfiguration()) { maybeTestModel, maybeError in
            
            XCTAssert(maybeError != nil)
            XCTAssert(maybeTestModel == nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testClientStatusCode() {
        let testStringUrl = "https://mockurl.com"
        let data = TestModel.createData(string: "ok")
        let statusCode = 409
        
        URLSessionMock.testsURLs = [testStringUrl: (data, statusCode)]
        
        let expectation = expectation(description: "Test client Expectation")
        
        client.getData(testStringUrl, model: TestModel.self, sessionConfiguration: URLSessionMock.createConfiguration()) { _, maybeError in
            
            XCTAssert(maybeError != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

}
