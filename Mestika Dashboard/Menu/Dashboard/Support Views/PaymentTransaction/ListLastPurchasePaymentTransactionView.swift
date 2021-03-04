//
//  ListLastPurchasePaymentTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/11/20.
//

import SwiftUI

struct ListLastPurchasePaymentTransactionView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @State var _listLast = [
        LastPurchasePayment(id: 1, tanggalTransaksi: "27 September 2020", username: "Prima Jatnika", nominalPembayaran: "121.000", nominal: "120.000"),
        LastPurchasePayment(id: 2, tanggalTransaksi: "15 Oktober 2020", username: "Prima Jatnika", nominalPembayaran: "52.500", nominal: "50.000"),
        LastPurchasePayment(id: 3, tanggalTransaksi: "20 Oktober 2020", username: "Prima Jatnika", nominalPembayaran: "11.500", nominal: "10.000"),
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text("Last transaction".localized(language))
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                
                List(0..._listLast.count - 1, id: \.self) { index in
                    HStack {
                        ZStack {
                            Image("ic_rectangel")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(_listLast[index].tanggalTransaksi)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.caption)
                                .fontWeight(.ultraLight)
                            
                            Text("\(_listLast[index].username)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                Text("- Rp.")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                
                                Text("\(_listLast[index].nominalPembayaran)")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                .colorMultiply(Color(hex: "#F6F8FB"))
                .frame(height: 500)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
    }
}

struct ListLastPurchasePaymentTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListLastPurchasePaymentTransactionView()
    }
}
