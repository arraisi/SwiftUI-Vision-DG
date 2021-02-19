//
//  HistoryTabs.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 18/02/21.
//

import SwiftUI

struct HistoryTabs: View {
    
    /*
     DUMMY
     */
    var data: HistoryTransactionModel = HistoryTransactionModel.init(creditDebit: "C", balanceSaldo: "", dateTo: "20201231", balance: "999980628587", lastRecordPostingDate: "", ref: "15197", balanceSaldoSign: "", totalSendData: "", customerName: "000", cardNo: "5058200000000758", transactionDate: "19/02/2021 05:52:05", sourceNumber: "87000000126", dateFrom: "20201201", totalDebitTransaction: "", lastRecordDate: "", historyList: [
        HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D"),
        
        HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D")
    ], lastRecordTraceNo: "")
    /*
     DUMMY
     */
    
    @State private var filterShowed: Bool = false
    private var filterBtnDisabled: Bool {
        startDate.count == 0 || endDate.count == 0
    }
    
    @State private var startDate = ""
    @State private var endDate = ""
    
    var body: some View {
        ZStack {
            if filterShowed {
                
                FilterView
                
            } else {
                
                VStack {
                    
                    Button(action: {
                        self.filterShowed = true
                    }, label: {
                        Text("Filter Transaksi")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5)
                    })
                    .padding()
                    
                    HistoryTransactionList(data: data)
                    
                }
            }
            
        }
        
    }
    
    var FilterView: some View {
        VStack {
            VStack(alignment: .center, spacing: 20){
                HStack {
                    Text("Period of time")
                        .font(.custom("Montserrat-Regular", size: 14))
                    Spacer()
                }
                
                HStack {
                    TextField("From", text: $startDate)
                        .font(.custom("Montserrat-Regular", size: 12))
                        .padding(15)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5)
                    
                    Text("-")
                    
                    TextField("To", text: $endDate)
                        .font(.custom("Montserrat-Regular", size: 12))
                        .padding(15)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5)
                }
                
                Button(action: {
                    self.filterShowed = false
                }, label: {
                    Text("View Search Results")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(filterBtnDisabled ? .gray : .white)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .background(filterBtnDisabled ? Color(.lightGray).opacity(0.3) : Color(hex: "#2334D0"))
                        .cornerRadius(15)
                })
                .disabled(filterBtnDisabled)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 5)
            .padding()
            
            Spacer()
        }
    }
}

struct HistoryTabs_Previews: PreviewProvider {
    static var previews: some View {
        let histories: [HistoryLists] = [
            HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D"),
            
            HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D")
        ]
        
        HistoryTabs(data: HistoryTransactionModel.init(creditDebit: "C", balanceSaldo: "", dateTo: "20201231", balance: "999980628587", lastRecordPostingDate: "", ref: "15197", balanceSaldoSign: "", totalSendData: "", customerName: "000", cardNo: "5058200000000758", transactionDate: "19/02/2021 05:52:05", sourceNumber: "87000000126", dateFrom: "20201201", totalDebitTransaction: "", lastRecordDate: "", historyList: histories, lastRecordTraceNo: ""))
        
    }
}
