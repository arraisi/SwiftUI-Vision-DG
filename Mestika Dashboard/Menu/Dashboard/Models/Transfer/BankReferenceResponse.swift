//
//  BankReferenceModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/02/21.
//

import Foundation

// MARK: - BankReferenceResponseElement
struct BankReferenceResponseElement: Codable, Hashable {
    let swiftCode: String
    let kliringCode, sknRtgsCode: Int
    let combinationName, bankName: String

    enum CodingKeys: String, CodingKey {
        case swiftCode = "swift_code"
        case kliringCode = "kliring_code"
        case sknRtgsCode = "skn_rtgs_code"
        case combinationName = "combination_name"
        case bankName = "bank_name"
    }
}

typealias BankReferenceResponse = [BankReferenceResponseElement]
