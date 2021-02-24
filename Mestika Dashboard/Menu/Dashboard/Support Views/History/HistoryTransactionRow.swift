//
//  HistoryRow.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/02/21.
//

import SwiftUI

struct HistoryTransactionRow: View {
    
    var data: HistoryLists
    
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading, spacing: 3) {
                Text(stringToDateFormat(data.postingDate))
                    .font(.custom("Montserrat-Regular", size: 10))
                
                Text(data.transactionInfo)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .autocapitalization(.allCharacters)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(data.digitSign == "D" ? "Debit" : "Kredit")
                    .font(.custom("Montserrat-Regular", size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(data.digitSign == "D" ? Color.red : Color.green)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    
                    if (data.digitSign == "D") {
                        Text("- Rp ")
                            .foregroundColor(data.digitSign == "D" ? Color.red : Color.green)
                    } else {
                        Text("+ Rp ")
                            .foregroundColor(data.digitSign == "D" ? Color.red : Color.green)
                    }
                    
                    
                    
                    Text("\(data.transactionAmount.subStringRange(from: 0, to: data.transactionAmount.count-2).thousandSeparator()),00")
                        .autocapitalization(.allCharacters)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(data.digitSign == "D" ? Color.red : Color.green)
                }
                .font(.custom("Montserrat-SemiBold", size: 12))
                
                HStack {
                    Text("Rp ")
                    
                    Text("\(data.availableBalance.subStringRange(from: 0, to: data.availableBalance.count-2).thousandSeparator()),00")
                        .autocapitalization(.allCharacters)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .font(.custom("Montserrat-SemiBold", size: 12))
        }
        .foregroundColor(Color(hex: "#232175"))
    }
    
    func stringToDateFormat(_ value: String) -> String {
        return value.count < 8 ? "-" : "\(value.suffix(2))-\(value.substring(with: 5..<7))-\(value.prefix(4))"
    }
}

struct HistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTransactionRow(data: HistoryLists.init(availableBalance: "99998062858799", transactionInfo: "TAGIHAN TAF ATM 08111111111111111 0811111111111111113", effectiveDate: "20201207", branch: "114", postingDate: "20201207", cheque: "         ", sign: "+", transactionAmount: "484285300", traceNo: "148602610", digitSign: "D"))
    }
}
