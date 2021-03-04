//
//  ListLastPaymentPlnView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI

struct ListLastPaymentPlnView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @State var _listHistory = [
        HistoryTransaction(id: 1, jenisTransaksi: "PLN Pra Bayar", username: "BAMBANG", namaPembayaran: "ID Pembayaran", nomorPembayaran: "8091203901239"),
        HistoryTransaction(id: 2, jenisTransaksi: "e-Wallet", username: "ASEP", namaPembayaran: "OVO", nomorPembayaran: "085875074351"),
        HistoryTransaction(id: 3, jenisTransaksi: "Mobile Data", username: "ANITA", namaPembayaran: "Indosat", nomorPembayaran: "085875074351"),
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text("Last Payment / Purchase".localized(language))
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                
                List(0..._listHistory.count - 1, id: \.self) { index in
                    HStack {
                        ZStack {
                            Image("ic_rectangel")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(_listHistory[index].jenisTransaksi)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.caption)
                                .fontWeight(.ultraLight)
                            
                            Text("\(_listHistory[index].username)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                            
                            HStack {
                                Text("\(_listHistory[index].namaPembayaran) :")
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                                
                                Text("\(_listHistory[index].nomorPembayaran)")
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                .frame(height: 300)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
    }
}

struct ListLastPaymentPlnView_Previews: PreviewProvider {
    static var previews: some View {
        ListLastPaymentPlnView()
    }
}
