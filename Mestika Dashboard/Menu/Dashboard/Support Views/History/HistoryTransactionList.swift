//
//  HistoryTransactionList.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/02/21.
//

import SwiftUI

struct HistoryTransactionList: View {
    var histories: [HistoryLists]
    
    var body: some View {
        List(histories, id: \.traceNo) { item in
            HistoryTransactionRow(data: item)
        }
        .listStyle(PlainListStyle())
    }
}

struct HistoryTransactionList_Previews: PreviewProvider {
    static var previews: some View {
        
        let histories: [HistoryLists] = [
            HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D"),
            
            HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D")
        ]
        NavigationView {
            HistoryTransactionList(histories: histories)
        }
    }
}
