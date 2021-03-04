//
//  ListAllFavoritePurchasePaymentView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListAllFavoritePurchasePaymentView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    var action: ((PurchasePaymentFavorite) -> Void)?
    @State private var activeDetails: Bool = false
    
    @State var _listFavorite = [
        PurchasePaymentFavorite(id: 1, username: "Prima Jatnika", namaPembayaran: "PLN Pra-Bayar", tujuan: "No. ID PLN", jenisPembayaran: "PLN", nomorTransaksi: "991203909090123"),
        PurchasePaymentFavorite(id: 2, username: "Prima Jatnika", namaPembayaran: "Top Up e-Wallet", tujuan: "OVO Prima", jenisPembayaran: "OVO", nomorTransaksi: "001209309123"),
        PurchasePaymentFavorite(id: 3, username: "Prima Jatnika", namaPembayaran: "Mobile & Data", tujuan: "085875074351", jenisPembayaran: "Indosat", nomorTransaksi: "085875074351"),
        PurchasePaymentFavorite(id: 4, username: "Prima Jatnika",namaPembayaran: "TV & Internet Cable", tujuan: "Megavisionari", jenisPembayaran: "Internet", nomorTransaksi: "09712378788731"),
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text("Favorite Purchase & Payment".localized(language))
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                
                List(0..._listFavorite.count - 1, id: \.self) { index in
                    NavigationLink(
                        destination: LastFavoritePurchasePaymentScreen(dataFavorit: self.$_listFavorite[index]),
                        label: {
                            Button(action: {
                                self.action!(_listFavorite[index])
                            }, label: {
                                HStack {
                                    ZStack {
                                        Image("ic_topup_ewallet")
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(_listFavorite[index].namaPembayaran)")
                                            .foregroundColor(Color(hex: "#1D2238"))
                                            .font(.caption)
                                            .fontWeight(.light)
                                        
                                        Text("\(_listFavorite[index].jenisPembayaran)")
                                            .foregroundColor(Color(hex: "#1D2238"))
                                            .font(.subheadline)
                                        
                                        HStack {
                                            Text("\(_listFavorite[index].namaPembayaran) :")
                                                .foregroundColor(Color(hex: "#1D2238"))
                                                .font(.caption)
                                                .fontWeight(.ultraLight)
                                            Text("\(_listFavorite[index].nomorTransaksi)")
                                                .foregroundColor(Color(hex: "#1D2238"))
                                                .font(.caption)
                                                .fontWeight(.ultraLight)
                                        }
                                    }
                                }
                            })
                        })
                    .padding(.vertical, 5)
                }
                .colorMultiply(Color(hex: "#F6F8FB"))
                .frame(height: 500)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
    }
}

struct ListAllFavoritePurchasePaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ListAllFavoritePurchasePaymentView()
    }
}
