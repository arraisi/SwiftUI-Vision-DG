//
//  Date+Extensions.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 15/07/21.
//

import Foundation

extension Date {
    /// Get current seconds Timestamp - 10 digits
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
         /// Get the current millisecond timestamp - 13 bits
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}

