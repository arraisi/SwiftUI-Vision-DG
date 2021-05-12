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
    let nik, deviceID, transactionDate: String
    let status: Int
    let message: Message
    let code: String
    let trxType: String
    let traceNumber: String?
    let reffNumber: String
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case nik
        case deviceID = "deviceId"
        case transactionDate, status, message, code, trxType, traceNumber, reffNumber, data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let amount: String
    let destinationBank: String
    let referenceNumber, fee, trxMessage, sumTotal: String
    let destinationAccountName: String
    let sourceAccount, destinationAccount: String?
}

enum Message: String, Codable {
    case requestSuccess = "Request Success"
    case unmappingErrorNumber05ErrorKeyUsedPerformOverbooking = "Unmapping Error Number [05], errorKey used [performOverbooking]"
}

typealias HistoryModel = [HistoryModelElement]

