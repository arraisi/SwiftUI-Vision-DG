// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let accountBalanceListResponse = try? newJSONDecoder().decode(AccountBalanceListResponse.self, from: jsonData)

import Foundation

// MARK: - AccountBalanceListResponseElement
struct AccountBalanceListResponseElement: Codable, Hashable {
    let ref, balance, currency, creditDebit: String
        let sourceName: String?
        let accountLegderBalance, sourceNumber, cardNo: String
        let status: StatusBalance
        let currencyCode: String
    }

    // MARK: - Status
    struct StatusBalance: Codable, Hashable {
        let status, message, code: String
    }

typealias AccountBalanceListResponse = [AccountBalanceListResponseElement]
