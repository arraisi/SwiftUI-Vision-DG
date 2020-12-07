//
//  String+Extensions.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import Foundation
import UIKit

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
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func base64ToImage() -> UIImage? {
        let cleanBase64 = self.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
            .replacingOccurrences(of: "data:image/png;base64,", with: "")
        if let dataDecoded = Data(base64Encoded: cleanBase64, options: []), let img = UIImage(data: dataDecoded) {
            return img
        } else {
            return nil
        }
    }
    
    func thousandSeparator() -> String {
        if let num = Int64(self) {
            return num.formattedWithSeparator
        } else {
            return self
        }
    }
    
    func isNotEmpty() -> Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
