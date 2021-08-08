//
//  DateUtilityTest.swift
//  MoviesBoxTests
//
//  Created by Muhammad Ubaid on 08/08/2021.
//

import XCTest
@testable import MoviesBox

class DateUtilityTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testSuccessChangeDateFormat() {
        
        let formattedDate = DateUtility.formatedDate(date: "2020-12-20", From: "yyyy-MM-dd", To: "dd MMM, yyyy")
        let formattedDateNil = DateUtility.formatedDate(date: "2020-13-20", From: "yyyy-MM-dd", To: "dd MMM, yyyy")
        let formattedDateEmpty = DateUtility.formatedDate(date: "", From: "yyyy-MM-dd", To: "dd MMM, yyyy")
        
        XCTAssertEqual(formattedDate, "20 Dec, 2020", "Date format changed successfully")
        XCTAssertNil(formattedDateNil, "Date should be nil")
        XCTAssertNil(formattedDateEmpty, "Date should be nil")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
