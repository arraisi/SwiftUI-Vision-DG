//
//  HistoryModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/02/21.
//

import Foundation

// MARK: - HistoryTransactionModel
struct HistoryTransactionModel: Codable {
    let creditDebit, balanceSaldo, dateTo, balance: String
    let lastRecordPostingDate, ref, balanceSaldoSign, totalSendData: String
    let customerName, cardNo, transactionDate, sourceNumber: String
    let dateFrom, totalDebitTransaction, lastRecordDate: String
    let historyList: [HistoryList]
    let lastRecordTraceNo: String
}

// MARK: - HistoryList
struct HistoryList: Codable {
    let availableBalance, transactionInfo, effectiveDate, branch: String
    let postingDate, cheque, sign, transactionAmount: String
    let traceNo, digitSign: String
}
