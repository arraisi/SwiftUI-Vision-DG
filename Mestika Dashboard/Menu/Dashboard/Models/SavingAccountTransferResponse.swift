// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let savingAccountTransferResponse = try? newJSONDecoder().decode(SavingAccountTransferResponse.self, from: jsonData)

import Foundation

// MARK: - SavingAccountTransferResponseElement
struct SavingAccountTransferResponseElement: Codable {
    let accountName, accountNumber, accountType, accountTypeDescription: String
    let accountStatus, accountStatusDescription, planAllowDebitInHouse, planAllowInquiry: String
    let planAllowDebitDomestic, planCode, planName, productName: String
    let productDescription, cardNumber, categoryProduct, balance: String
    let digitSign: String
}

typealias SavingAccountTransferResponse = [SavingAccountTransferResponseElement]
