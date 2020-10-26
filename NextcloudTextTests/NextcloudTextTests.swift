//
//  NextcloudTextTests.swift
//  NextcloudTextTests
//
//  Created by Collin James on 10/13/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import XCTest
@testable import NextcloudText

class NextcloudTextTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPollLogin() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let token = "qfPDZGA80KoEJj15SLbzgIYZSbN2rhw3WcTMmiWP9w1QwXx1eDANq4zClSchclbE6v0W46Cu0qFLtlnRbxYFC9NDPXXnwmQ9CKEQnjmFXt325iX3WkIfkojr8f4BqPZx"
        var finalData = Data()
        let data: Data? = "{\"poll\":{\"token\":\"qfPDZGA80KoEJj15SLbzgIYZSbN2rhw3WcTMmiWP9w1QwXx1eDANq4zClSchclbE6v0W46Cu0qFLtlnRbxYFC9NDPXXnwmQ9CKEQnjmFXt325iX3WkIfkojr8f4BqPZx\",\"endpoint\":\"https://collinjam.es/nc/index.php/login/v2/poll\"},\"login\":\"https://collinjam.es/nc/index.php/login/v2/flow/38IYlF5mKZgNUG9u5ePpCGAJtpmMBXpYp4Km76jHg7RYEEKQRS12cj99Krf68oDY0emcBIBxrJIJhXXTNKqYCleUzJR3ir1YifQn1EZoqyomf1iaH5VN0ljO3XlyHth9\"}".data(using: .utf8, allowLossyConversion: false)!
        finalData.append(data!)
        let testvar = PollLogin(from: finalData)
        XCTAssertNotNil(testvar)
        XCTAssertTrue(testvar?.poll!.token == token)
    }
    
    func testAppLoginCreds() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let loginName = "abc"
        var finalData = Data()
        let data: Data? = "{\"server\":\"https://abc.com\", \"loginName\":\"abc\", \"appPassword\":\"abc\"}".data(using: .utf8, allowLossyConversion: false)!
        finalData.append(data!)
        let testvar = AppLoginCreds(from: finalData)
        XCTAssertNotNil(testvar)
        XCTAssertTrue(testvar?.loginName == loginName)
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
