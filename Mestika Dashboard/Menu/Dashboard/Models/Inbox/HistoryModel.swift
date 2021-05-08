//
//  HistoryModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/04/21.
//

import Foundation

// MARK: - HistoryModelElement
struct HistoryModelElement: Codable {
    let nik, deviceID: String?
    let transactionDate: String?
    let status: Int?
    let message, code: String?
    let trxType, traceNumber, reffNumber: String?
    let data: DataClass
    
    enum CodingKeys: String, CodingKey {
        case nik
        case deviceID = "deviceId"
        case transactionDate, status, message, code, trxType, traceNumber, reffNumber, data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let transactionFee, destinationBank, transactionAmount, destinationAccountNumber: String?
    let message, sourceAccountNumber, destinationAccountName, sourceAccountName: String?
    let amount, destinationAccount: String?
    let referenceNumber, sourceAccount: String?, trxMessage: String?
}

typealias HistoryModel = [HistoryModelElement]
