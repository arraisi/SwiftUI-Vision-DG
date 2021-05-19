//
//  HistoryModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/04/21.
//

import Foundation

//
//  HistoryModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/04/21.
//

import Foundation

// MARK: - HistoryModelElement
struct HistoryModelElement: Codable, Identifiable {
    let id = UUID()
    let nik, deviceID, transactionDate: String?
    let status: Int?
    let message: String
    let code: String?
    let trxType: String?
    let traceNumber: String?
    let reffNumber: String?
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case nik
        case deviceID = "deviceId"
        case transactionDate, status, message, code, trxType, traceNumber, reffNumber, data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let amount: String?
    let destinationBank: String?
    let referenceNumber, fee, trxMessage, sumTotal: String?
    let destinationAccountName: String?
    let transactionFee, transactionAmount, destinationAccountNumber: String?
    let message: String?
    let sourceAccount, destinationAccount: String?
}

typealias HistoryModel = [HistoryModelElement]

