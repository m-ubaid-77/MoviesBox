//
//  ImageUtilityTests.swift
//  MoviesBoxTests
//
//  Created by Muhammad Ubaid on 08/08/2021.
//

import XCTest
@testable import MoviesBox

class ImageUtilityTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testDownloadPosterImageSuccessfully() {
        
        let promise = expectation(description: "Completion handler completed")
        var downloadImage : UIImage?
        
        ImageUtility.getMoviePosterImage(from: APIManager.moviesPosterBasePath, with: "/2DtPSyODKWXluIRV7PVru0SSzja.jpg") { (image) in
            downloadImage = image
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 15)
        
        XCTAssertNotNil(downloadImage, "Image downloaded")
    }
    
    func testDownloadPosterImageFailed() {
        
        let promise = expectation(description: "Completion handler completed")
        var downloadImage : UIImage?
        
        ImageUtility.getMoviePosterImage(from: APIManager.moviesPosterBasePath, with: "") { (image) in
            downloadImage = image
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 15)
        
        XCTAssertNil(downloadImage, "Image not found")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
