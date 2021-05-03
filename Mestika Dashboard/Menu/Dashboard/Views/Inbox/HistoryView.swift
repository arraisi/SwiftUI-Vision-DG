//
//  HistoryView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/04/21.
//

import SwiftUI

struct HistoryView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject var historVM = HistoryTransactionViewModel()
    
    @Binding var isLoading: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(historVM.history, id: \.reffNumber) { data in
                    
                    HistoryRow(data: data)
                    
                }
            }
            .padding(.vertical, 30)
        }
        .onAppear{
            self.isLoading = true
            historVM.findAll { r in
                self.isLoading = false
            }
        }
    }
    
    
}

struct HistoryRow: View {
    
    var data: HistoryModelElement
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                
                Text("\(data.data.destinationAccountName?.subStringRange(from: 0, to: 1) ?? "0")")
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
            }
            
            VStack(alignment: .leading) {
                Text(data.trxType)
                    .font(.custom("Montserrat-Bold", size: 14))
                
                Text("\(data.trxDate ?? "")")
                    .font(.custom("Montserrat-Medium", size: 12))
            }
            
            Spacer()
            
            HStack {
                Text("Rp.")
                
                Text("\(data.data.amount?.thousandSeparator() ?? "0")")
            }
            .font(.custom("Montserrat-Bold", size: 14))
            .foregroundColor(.green)
            
            
        }
        .padding(.vertical, 5)
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 8)
        .padding(.horizontal)
        .padding(.vertical, 5)
        
        .foregroundColor(Color(hex: "#232175"))
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRow(data: HistoryModelElement(nik: "00000", deviceID: "123", trxDate: "123", status: 1, message: "123", rc: "123", trxType: "123", traceNumber: "123", reffNumber: "123", data: DataClass(transactionFee: "1000000", destinationBank: "123456", transactionAmount: "2000000", destinationAccountNumber: "123456", message: "Description", sourceAccountNumber: "100", destinationAccountName: "AA", sourceAccountName: "BB", amount: "4000000", destinationAccount: "123", referenceNumber: "x123", sourceAccount: "b123", trxMessage: "Message")))
    }
}
