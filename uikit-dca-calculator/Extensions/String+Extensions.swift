//
//  String+Extensions.swift
//  uikit-dca-calculator
//
//  Created by joe on 2023/12/07.
//

import Foundation

extension String {
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
}
