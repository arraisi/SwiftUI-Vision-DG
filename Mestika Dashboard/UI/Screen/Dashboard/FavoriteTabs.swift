//
//  FavoriteScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct FavoriteTabs: View {
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
                VStack {
                    titleInfo
                    
                    ListFavoritePurchasePaymentView()
                        .padding(.bottom)
                    
                    ListFavoriteTransactionView()
                        .padding(.bottom)
                }
            })
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // MARK: -USERNAME INFO VIEW
    var titleInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Favorit")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Berikut merupakan daftar-daftar transaksi yang telah anda simpan ke dalam menu favorit")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("ic_search")
            })
        }
        .padding()
    }
}

struct FavoriteTabs_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTabs()
    }
}
