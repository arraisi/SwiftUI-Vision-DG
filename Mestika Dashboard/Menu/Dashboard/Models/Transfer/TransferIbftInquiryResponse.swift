// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transferIbftInquiryResponse = try? newJSONDecoder().decode(TransferIbftInquiryResponse.self, from: jsonData)

import Foundation

// MARK: - TransferIbftInquiryResponse
struct TransferIbftInquiryResponse: Codable {
    let destinationAccountNumber, destinationBank, sourceAccountNumber, transactionAmount: String?
    let transactionDetails, currency, sourceBank, pan: String?
    let phoneNumber, featureCode, transactionDate, destinationAccountName: String?
    let transactionFee, transferIndicator, reffNumber: String?
    let trace, ref: String?
    let status: StatusInquiry
}

// MARK: - Status
struct StatusInquiry: Codable {
    let code, message, status: String
}
