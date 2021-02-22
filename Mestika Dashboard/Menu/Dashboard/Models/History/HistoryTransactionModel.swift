//
//  HistoryModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/02/21.
//

import Foundation

// MARK: - HistoryTransactionModel
struct HistoryTransactionModel: Codable {
    let status: Status
    let creditDebit, balanceSaldo, dateTo, balance: String
    let lastRecordPostingDate, ref, balanceSaldoSign, totalSendData: String
    let customerName: String
    let cardNo: String?
    let transactionDate, sourceNumber, dateFrom, totalDebitTransaction: String
    let lastRecordDate: String
    let historyList: [HistoryLists]?
    let lastRecordTraceNo: String
}

// MARK: - HistoryList
struct HistoryLists: Codable {
    let availableBalance, transactionInfo, effectiveDate, branch: String
    let postingDate, cheque, sign, transactionAmount: String
    let traceNo, digitSign: String
}
