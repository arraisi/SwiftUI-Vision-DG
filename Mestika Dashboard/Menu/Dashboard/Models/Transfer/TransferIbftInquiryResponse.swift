// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transferIbftInquiryResponse = try? newJSONDecoder().decode(TransferIbftInquiryResponse.self, from: jsonData)

import Foundation

// MARK: - TransferIbftInquiryResponse
struct TransferIbftInquiryResponse: Codable {
    let currency, destinationAccountNumber, destinationBank, sourceAccountNumber: String
    let reffNumber, transactionDate, sourceAccountName, destinationAccountName: String
    let status: StatusInquiry
}

// MARK: - Status
struct StatusInquiry: Codable {
    let code, message, status: String
}
