//
//  PaymentTransactionTabs.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct PaymentTransactionTabs: View {
    
    var body: some View {
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
            
            GeometryReader { geometry in
                Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                    .frame(height: 0)
            }
            
            VStack {
                titleInfo
                
                GridMenuManyUsedView()
                    .padding(.top)
                
                GridMenuAllPaymentPurchaseView()
                    .padding(.top, 30)
                
                ListLastPurchasePaymentTransactionView()
                    .padding(.top, 30)
            }
        })
        .navigationBarHidden(true)
    }
    
    // MARK: -USERNAME INFO VIEW
    var titleInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Pembayaran  &  Pembelian")
                    .font(.title)
                    .fontWeight(.heavy)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Text("Lakukan segala bentuk pembayaran dan transaksi dengan cepat, mudah dan aman")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("ic_search")
            })
        }
        .padding()
    }
}

struct PaymentTransactionTabs_Previews: PreviewProvider {
    static var previews: some View {
        PaymentTransactionTabs()
    }
}
