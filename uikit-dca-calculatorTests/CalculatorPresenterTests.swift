//
//  CalculatorPresenterTests.swift
//  uikit-dca-calculatorTests
//
//  Created by joe on 1/12/24.
//

import XCTest
@testable import uikit_dca_calculator

final class CalculatorPresenterTests: XCTestCase {
    var sut: CalculatorPresenter!

    override func setUpWithError() throws {
        sut = CalculatorPresenter()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // test: 'What is tested on?'
    // given: 'What is the situation?'
    // expect: 'What is your expectation?'

    func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen() {
        // given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: true)
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, UIColor.systemGreen)
    }

    func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen() {
        // given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: true)
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.yieldLabelTextColor, UIColor.systemGreen)
    }
    
    func testAnnualReturnLabelTextColor_givenResultIsNotProfitable_expectSystemRed() {
        // given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: false)
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, UIColor.systemRed)
    }

    func testYieldLabelTextColor_givenResultIsNotProfitable_expectSystemRed() {
        // given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: false)
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.yieldLabelTextColor, UIColor.systemRed)
    }
    
    func testYieldLabel_expectBrackets() {
        // given
        let openingBracket: Character = "("
        let closingBracket: Character = ")"
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0.25,
                               annualReturn: 0,
                               isProfitable: false)
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.yield.first, openingBracket)
        XCTAssertEqual(presentation.yield.last, closingBracket)
    }
}
