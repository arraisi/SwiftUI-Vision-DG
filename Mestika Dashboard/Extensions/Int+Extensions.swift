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
