//
//  HistoryTransactionList.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/02/21.
//

import SwiftUI

struct HistoryTransactionList: View {
    var data: HistoryTransactionModel
    
    var body: some View {
        List(data.historyList, id: \.traceNo) { item in
            HistoryTransactionRow(data: item)
        }
        .listStyle(InsetListStyle())
    }
}

struct HistoryTransactionList_Previews: PreviewProvider {
    static var previews: some View {
        
        let histories: [HistoryLists] = [
            HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D"),
            
            HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D")
        ]
        
        HistoryTransactionList(data: HistoryTransactionModel.init(creditDebit: "C", balanceSaldo: "", dateTo: "20201231", balance: "999980628587", lastRecordPostingDate: "", ref: "15197", balanceSaldoSign: "", totalSendData: "", customerName: "000", cardNo: "5058200000000758", transactionDate: "19/02/2021 05:52:05", sourceNumber: "87000000126", dateFrom: "20201201", totalDebitTransaction: "", lastRecordDate: "", historyList: histories, lastRecordTraceNo: ""))
    }
}
