//
//  APIClientTests.swift
//  MoviesBoxTests
//
//  Created by Muhammad Ubaid on 08/08/2021.
//

import XCTest
@testable import MoviesBox

class APIClientTests: XCTestCase {

    let apiClient  = APIClient.shared
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testSuccessMoviesListAPI() {
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: String?
        
        apiClient.get(urlString: APIManager.baseURL+APIManager.moviesEndPoint, parameters: ["api_key":APIManager.APIKey,"query":"fffffffff","page":1]) { (code:Int, moviesResponse:MoviesResponse) in
            statusCode = code
            promise.fulfill()
            
        } failure: { (error) in
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200, "Successfully loaded movies")
    }
    
    func testSuccessMoviesFoundListAPI() {
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: String?
        var moviesCount: Int = 0
        
        apiClient.get(urlString: APIManager.baseURL+APIManager.moviesEndPoint, parameters: ["api_key":APIManager.APIKey,"query":"batman","page":1]) { (code:Int, moviesResponse:MoviesResponse) in
            statusCode = code
            moviesCount = moviesResponse.movies?.count ?? 0
            promise.fulfill()
            
        } failure: { (error) in
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200, "Successfully loaded movies")
        XCTAssertGreaterThan(moviesCount, 0, "Movies found")
    }
    
    func testNoMoviesFoundListAPI() {
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: String?
        var moviesCount: Int = 0
        
        apiClient.get(urlString: APIManager.baseURL+APIManager.moviesEndPoint, parameters: ["api_key":APIManager.APIKey,"query":"ffffffff","page":1]) { (code:Int, moviesResponse:MoviesResponse) in
            statusCode = code
            moviesCount = moviesResponse.movies?.count ?? 0
            promise.fulfill()
            
        } failure: { (error) in
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200, "Successfully loaded movies")
        XCTAssertEqual(moviesCount, 0, "No Movie found")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
