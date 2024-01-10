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
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // test cases
    // 1. asset = winning | dca = true => positive gains
    // 2. asset = winning | dca = false => positive gains
    // 3. asset = losing | dca = true => negative gains
    // 4. asset = losing | dca = false => negative gains
    
    // Format for test function name
    // what
    // given
    // expectation
    
    func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateOfInvestmentIndex: Int = 5
        let asset = buildWinningAsset()
        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        // then
        // Initial investment: $5000
        // DCA: $1500 x 5 = $7500
        // total: $5000 + $7500 = $12500
        XCTAssertEqual(result.investmentAmount, 12500, "investment amount is incorrect")
        XCTAssertTrue(result.isProfitable)
        
        // Jan: $5000 / 100 = 50 shares
        // Feb: $1500 / 110 = 13.6363 shares
        // Mar: $1500 / 120 = 12.5 shares
        // Apr: $1500 / 130 = 11.5384 shares
        // May: $1500 / 140 = 10.7142 shares
        // Jun: $1500 / 150 = 10 shares
        // Total shares = 108.3889 shares
        // Total current value = 108.3889 x 160 (latest month closing price) = $17,342.224
        XCTAssertEqual(result.currentValue, 17342.224, accuracy: 0.1)
        XCTAssertEqual(result.gain, 4842.224, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3873, accuracy: 0.0001)
    }
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateOfInvestmentIndex: Int = 3
        let asset = buildWinningAsset()
        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        // then
        // Initial investment: $5000
        // DCA: $0 x 5 = $0
        // total: $5000 + $0 = $5000
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertTrue(result.isProfitable)
        
        // Mar: $1500 / 120 = 41.6666 shares
        // Apr: $0 / 130 = 0 shares
        // May: $0 / 140 = 0 shares
        // Jun: $0 / 150 = 0 shares
        // Total shares = 41.6666 shares
        // Total current value = 41.6666 x 160 (latest month closing price) = $6666.666
        // Gain = current value LESS investment amount: 6666.666 - 5000 = 1666.666
        // Yield = gains / investment amount: 1666.666 / 5000 = 0.3333
        XCTAssertEqual(result.currentValue, 6666.666, accuracy: 0.1)
        XCTAssertEqual(result.gain, 1666.666, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3333, accuracy: 0.0001)
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries: [String: OHLC] = [
            "2023-01-25": OHLC(open: "100", close: "110", adjustedClose: "110"),
            "2023-02-25": OHLC(open: "110", close: "120", adjustedClose: "120"),
            "2023-03-25": OHLC(open: "120", close: "130", adjustedClose: "130"),
            "2023-04-25": OHLC(open: "130", close: "140", adjustedClose: "140"),
            "2023-05-25": OHLC(open: "140", close: "150", adjustedClose: "150"),
            "2023-06-25": OHLC(open: "150", close: "160", adjustedClose: "160")
        ]
        // adjusted open = open x (adjusted close / close)
        //               = 100 * 110 / 0 = 0 ⟶ close = 110
        //               = 110 * 120 / 0 = 0 ⟶ close = 120
        //               = 120 * 130 / 0 = 0 ⟶ close = 130
        //               = 130 * 140 / 0 = 0 ⟶ close = 140
        //               = 140 * 150 / 0 = 0 ⟶ close = 150
        //               = 150 * 160 / 0 = 0 ⟶ close = 160
        
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(
            meta: meta,
            timeSeries: timeSeries)
        return Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    private func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "XYZ", name: "XYZ Company", type: "ETF", currency: "USD")
    }
    
    private func buildMeta() -> Meta {
        return Meta(symbol: "XYZ")
    }
    
    func testInvestmentAmount_whenDCAIsUsed_expectResult() {
        // given
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double = 100
        let initialDateOfInvestmentIndex = 4 // (5 months ago)
        // when
        let investmentAmount = sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        // then
        XCTAssertEqual(investmentAmount, 900)
        
        // Initial Amount: $500
        // DCA: 4 x $100 = $400
        // total: $400 + $500 = $900
    }
    
    func testInvestmentAmount_whenDCAIsNotUsed_expectResult() {
        // given
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateOfInvestmentIndex = 4 // (5 months ago)
        // when
        let investmentAmount = sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        // then
        XCTAssertEqual(investmentAmount, 500)
        
        // Initial Amount: $500
        // DCA: 4 x $0 = $0
        // total: $0 + $500 = $500
    }

}
