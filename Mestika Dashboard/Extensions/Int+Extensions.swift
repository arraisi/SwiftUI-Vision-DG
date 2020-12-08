//
//  Int+Extensions.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import Foundation

extension Int {
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}

extension Int {
    func formatted(allowedUnits: NSCalendar.Unit = [.hour, .minute]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: DateComponents(second: self))
    }
}
