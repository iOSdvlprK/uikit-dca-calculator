//
//  Date+Extensions.swift
//  uikit-dca-calculator
//
//  Created by joe on 12/26/23.
//

import Foundation

extension Date {
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
