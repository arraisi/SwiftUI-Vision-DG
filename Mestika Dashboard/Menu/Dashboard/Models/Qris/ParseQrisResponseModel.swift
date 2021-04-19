// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let parseQrisResponseModel = try? newJSONDecoder().decode(ParseQrisResponseModel.self, from: jsonData)

import Foundation

// MARK: - ParseQrisResponseModel
struct ParseQrisResponseModel: Codable {
    let transactionCurrency, transactionFee, merchantCity, transactionAmount: String
    let merchantName: String
}
