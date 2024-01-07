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
    }
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries: [String: OHLC] = [
            "2023-01-25": OHLC(open: "100", close: "0", adjustedClose: "110"),
            "2023-02-25": OHLC(open: "110", close: "0", adjustedClose: "120"),
            "2023-03-25": OHLC(open: "120", close: "0", adjustedClose: "130"),
            "2023-04-25": OHLC(open: "130", close: "0", adjustedClose: "140"),
            "2023-05-25": OHLC(open: "140", close: "0", adjustedClose: "150"),
            "2023-06-25": OHLC(open: "150", close: "0", adjustedClose: "160")
        ]
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
