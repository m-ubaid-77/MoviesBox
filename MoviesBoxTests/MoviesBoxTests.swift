//
//  MoviesBoxTests.swift
//  MoviesBoxTests
//
//  Created by Muhammad Ubaid on 08/08/2021.
//

import XCTest
@testable import MoviesBox

class MoviesBoxTests: XCTestCase {

    var moviesService: MoviesService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        moviesService = MoviesService()
    }

    
    func testGetMoviesMethod(){
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: String?
        
        moviesService.getMovies(page: 1, query: "batman") { (status, response) in
            
            statusCode = status
            promise.fulfill()
            
        } failure: { (errorMsg) in
            responseError = errorMsg
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200, "Successfully loaded movies")
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        moviesService = nil
        try super.tearDownWithError()
    }


}
