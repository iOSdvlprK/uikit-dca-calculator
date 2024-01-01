//
//  Double+Extensions.swift
//  uikit-dca-calculator
//
//  Created by joe on 12/30/23.
//

import Foundation

extension Double {
    var stringValue: String {
        return String(describing: self)
    }
    
    var twoDecimalPlaceString: String {
        return String(format: "%.2f", self)
    }
}
