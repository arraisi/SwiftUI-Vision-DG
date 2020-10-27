//
//  FavoriteTransferScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct FavoriteTransferScreen: View {
    
    @State private var searchCtrl = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        searchCard
                        
                        ListAllFavoriteTransactionView() { data in
                            print(data.username)
                        }
                        .padding(.bottom)
                    }
                    .padding(.bottom, 25)
                })
            }
            .navigationBarTitle("Favorit Transfer", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {}, label: {
                Text("Cancel")
            }))
        }
    }
    
    var searchCard: some View {
        HStack {
            HStack {
                TextField("Cari kontak Transfer", text: $searchCtrl, onEditingChanged: { changed in
                    print("\($searchCtrl)")
                })
                
                Image("ic_search")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
            }
            .keyboardType(.numberPad)
            .frame(height: 10)
            .font(.subheadline)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding(.leading, 20)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("ic_fillter")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
            })
            .frame(height: 10)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding(.trailing, 20)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .padding(.top)
        .padding([.bottom, .top], 20)
    }
}

struct FavoriteTransferScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTransferScreen()
    }
}
