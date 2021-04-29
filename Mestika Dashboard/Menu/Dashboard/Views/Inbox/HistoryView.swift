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
            historVM.findAll { r in
                
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
                
                Text("\(data.data.destinationAccountName.subStringRange(from: 0, to: 1))")
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
            }
            
            VStack(alignment: .leading) {
                Text(data.data.destinationAccountName)
                    .font(.custom("Montserrat-Bold", size: 14))
                
                Text("\(data.data.message)")
                    .font(.custom("Montserrat-Medium", size: 12))
            }
            
            Spacer()
            
            HStack {
                Text("Rp.")
                
                Text("\(data.data.transactionAmount.thousandSeparator())")
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
        HistoryRow(data: HistoryModelElement(nik: "00000", deviceID: "123", trxDate: "123", status: 1, message: "123", rc: "123", trxType: "123", traceNumber: "123", reffNumber: "123", data: DataClass(transactionFee: "123", destinationBank: "123", transactionAmount: "10000000000", destinationAccountNumber: "123", message: "Description", sourceAccountNumber: "123", destinationAccountName: "Abdul R Arraisi", sourceAccountName: "123")))
    }
}
