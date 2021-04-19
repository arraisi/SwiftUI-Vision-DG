// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let payQrisResponseModel = try? newJSONDecoder().decode(PayQrisResponseModel.self, from: jsonData)

import Foundation

// MARK: - PayQrisResponseModel
struct PayQrisResponseModel: Codable {
    let serviceName, pan, fromAccountType, amount: String?
    let gmt, traceNo, localDateTime, settlementDate: String?
    let channelID, acquireID, transactionFee, reffNo: String?
    let terminalID, cardAcceptorID, cardAcceptorNameLocation, additionalData: String?
    let currency: String?
    let issuerID, fromAccount: String?
    let qrisData: [QrisDatum]
    let invoiceNumber, responseCode, transactionDate, transactionAmount: String?

    enum CodingKeys: String, CodingKey {
        case serviceName, pan, fromAccountType, amount, gmt, traceNo, localDateTime, settlementDate
        case channelID = "channelId"
        case acquireID = "acquireId"
        case transactionFee, reffNo
        case terminalID = "terminalId"
        case cardAcceptorID = "cardAcceptorId"
        case cardAcceptorNameLocation, additionalData, currency
        case issuerID = "issuerId"
        case fromAccount, qrisData, invoiceNumber, responseCode, transactionDate, transactionAmount
    }
}

// MARK: - QrisDatum
struct QrisDatum: Codable {
    let pan, channelID, acquireID, terminalID: String?
    let cardAcceptorID, cardAcceptorNameLocation: String?

    enum CodingKeys: String, CodingKey {
        case pan
        case channelID = "channelId"
        case acquireID = "acquireId"
        case terminalID = "terminalId"
        case cardAcceptorID = "cardAcceptorId"
        case cardAcceptorNameLocation
    }
}
