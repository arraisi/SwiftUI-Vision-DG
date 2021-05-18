// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transferIbftExecResponse = try? newJSONDecoder().decode(TransferIbftExecResponse.self, from: jsonData)

import Foundation

// MARK: - TransferIbftExecResponse
struct TransferIbftExecResponse: Codable {
    let pan, sourceBank, phoneNumber, currency: String
    let sourceAccountNumber, sourceAccountName, destinationAccountNumber, destinationAccountName: String
    let destinationBank, transactionAmount, transactionFee, transactionDetails: String
    let reffNumber, nik, traceNumber, transactionDate: String
    let status: StatusInquiry
}
