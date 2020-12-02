//
//  Formatter.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 02/12/20.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
}
