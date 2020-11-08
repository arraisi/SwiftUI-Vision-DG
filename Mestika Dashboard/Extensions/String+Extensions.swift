//
//  String+Extensions.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import Foundation

extension String {
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        return result
    }
    
    func replace(myString: String, _ index: [Int], _ newChar: Character) -> String {
        var chars = Array(myString)
        if chars.count > 5 {
            for data in index {
                chars[data] = newChar
            }
        }

        let modifiedString = String(chars)
        return modifiedString
    }
}
