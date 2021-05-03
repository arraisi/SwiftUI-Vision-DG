//
//  HistoryDetailView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/05/21.
//

import SwiftUI

struct HistoryDetailView: View {
    
    var data: HistoryModelElement
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(spacing: 5) {
                Image("logo_m_mestika")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("DarkStaleBlue"))
                    .frame(width: 80, height: 80)
                    .padding(5)
                    .padding(.top, 20)
                
                Text(data.status == 0 ? "Berhasil" : "Gagal")
                    .font(.custom("Montserrat-Bold", size: 16))
                
                Text("Waktu : \(data.trxDate ?? "")")
                
                Text("Reff : \(data.reffNumber)")
            }
            
            VStack {
                HStack {
                    Text("Sumber rekening")
                    Spacer()
                    Text(data.data.sourceAccount ?? "")
                }
                
                HStack {
                    Text("Rekening tujuan")
                    Spacer()
                    Text(data.data.destinationAccount ?? "")
                }
            }
            
            VStack {
                HStack {
                    HStack {
                        Text("Bank tujuan")
                        Spacer()
                    }
                    .frame(width: 120)
                    
                    Text(data.data.destinationBank ?? "")
                    Spacer()
                }
                HStack {
                    HStack {
                        Text("Deskripsi")
                        Spacer()
                    }
                    .frame(width: 120)
                    Text(data.data.trxMessage ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
            
            VStack {
                
                Divider()
                
                HStack {
                    Text("Nominal transaksi :")
                    Spacer()
                    Text("")
                }
                
                HStack {
                    Text("Fee transaksi :")
                    Spacer()
                    Text("")
                }
                
                HStack {
                    Text("Voucher :")
                    Spacer()
                    Text("")
                }
                
                HStack {
                    Text("Total transaksi :")
                    Spacer()
                    Text(data.data.amount?.thousandSeparator() ?? "")
                }
                
                Divider()
            }
            Spacer()
        }
        .font(.custom("Montserrat-Medium", size: 14))
        .padding(.horizontal, 30)
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetailView(data: HistoryModelElement(nik: "00000", deviceID: "123", trxDate: "123", status: 0, message: "123", rc: "123", trxType: "123", traceNumber: "123", reffNumber: "123", data: DataClass(transactionFee: "1000000", destinationBank: "123456", transactionAmount: "2000000", destinationAccountNumber: "123456", message: "Lorem ipsum lask ekahs lahsk alsdh kas. Lorem ipsum lask ekahs lahsk alsdh kas", sourceAccountNumber: "100", destinationAccountName: "AA", sourceAccountName: "BB", amount: "4000000", destinationAccount: "123", referenceNumber: "x123", sourceAccount: "b123", trxMessage: "Message")))
    }
}
