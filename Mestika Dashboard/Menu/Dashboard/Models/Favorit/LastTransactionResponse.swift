//
//  LastTransactionResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/02/21.
//

import Foundation

// MARK: - LastTransactionResponse
struct LastTransactionResponse: Codable {
    let status: Status
    let ref, customerName, sourceNumber: String
    let historyList: [HistoryList]
}

// MARK: - HistoryList
struct HistoryList: Codable {
    let date, trace, amount, historyListDescription: String
    let sign: String

    enum CodingKeys: String, CodingKey {
        case date, trace, amount
        case historyListDescription = "description"
        case sign
    }
}
