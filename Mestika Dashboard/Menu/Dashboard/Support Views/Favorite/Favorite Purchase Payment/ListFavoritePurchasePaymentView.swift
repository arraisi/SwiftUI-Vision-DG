//
//  ListFavoritePurchasePaymentView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListFavoritePurchasePaymentView: View {
    
    var _listFavorite = [
        PurchasePaymentFavorite(id: 1, username: "Prima Jatnika", namaPembayaran: "PLN Pra-Bayar", tujuan: "No. ID PLN", jenisPembayaran: "PLN", nomorTransaksi: "991203909090123"),
        PurchasePaymentFavorite(id: 2, username: "Prima Jatnika", namaPembayaran: "Top Up e-Wallet", tujuan: "OVO Prima", jenisPembayaran: "OVO", nomorTransaksi: "001209309123"),
        PurchasePaymentFavorite(id: 3, username: "Prima Jatnika", namaPembayaran: "Mobile & Data", tujuan: "085875074351", jenisPembayaran: "Indosat", nomorTransaksi: "085875074351"),
        PurchasePaymentFavorite(id: 4, username: "Prima Jatnika", namaPembayaran: "TV & Internet Cable", tujuan: "Megavisionari", jenisPembayaran: "Internet", nomorTransaksi: "09712378788731"),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Favorit Purchase & Payment")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            ScrollView(showsIndicators: false) {
                ForEach(_listFavorite) { data in
                    HStack {
                        ZStack {
                            Image("ic_topup_ewallet")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(data.namaPembayaran)")
                                .font(.caption2)
                                .fontWeight(.ultraLight)
                            
                            Text("\(data.tujuan)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Spacer()
                
                NavigationLink(destination: FavoritePurchasePaymentScreen(), label: {
                    Text("Lihat Daftar Selengkapnya")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding()
                })
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
}

struct ListFavoritePurchasePaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ListFavoritePurchasePaymentView()
    }
}
