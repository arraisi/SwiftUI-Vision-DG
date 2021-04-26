// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transferIbftExecResponse = try? newJSONDecoder().decode(TransferIbftExecResponse.self, from: jsonData)

import Foundation

// MARK: - TransferIbftExecResponse
struct TransferIbftExecResponse: Codable {
    let currency, sourceAccountNumber, destinationAccountNumber, destinationBank: String
    let transactionAmount, transactionFee, reffNumber, pinTrx: String
    let nik, deviceID, traceNumber, transactionDate: String
    let destinationAccountName, sourceAccountName: String
    let status: StatusInquiry

    enum CodingKeys: String, CodingKey {
        case currency, sourceAccountNumber, destinationAccountNumber, destinationBank, transactionAmount, transactionFee, reffNumber, pinTrx, nik
        case deviceID = "deviceId"
        case traceNumber, transactionDate, destinationAccountName, sourceAccountName, status
    }
}
