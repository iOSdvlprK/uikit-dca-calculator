//
//  uikit_dca_calculatorTests.swift
//  uikit-dca-calculatorTests
//
//  Created by joe on 1/5/24.
//

import XCTest
@testable import uikit_dca_calculator

final class uikit_dca_calculatorTests: XCTestCase {
    
    var sut: DCAService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() {
        // given
        let num1 = 5
        let num2 = 10
        // when
        let result = sut.performSubtraction(num1: num1, num2: num2)
        // then
        XCTAssertEqual(result, -5)
//        XCTAssertTrue(result > 0)  // Test Fails
    }
    
    func testExample2() {
        // given
        let num1 = 1
        let num2 = 2
        // when
        let result = performAddition(num1: num1, num2: num2)
        // then
        XCTAssertEqual(result, 3)
    }
    
    func performAddition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
}
