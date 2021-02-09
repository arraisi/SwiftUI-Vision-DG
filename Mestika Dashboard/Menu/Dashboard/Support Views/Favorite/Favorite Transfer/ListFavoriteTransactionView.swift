//
//  ListFavoriteTransaction.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListFavoriteTransactionView: View {
    
    @StateObject private var favoriteVM = FavoritesViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Favorit Transfer")
                    .font(.custom("Montserrat-SemiBold", size: 14))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom)
            
            ForEach(self.favoriteVM.favorites, id: \.id) { data in
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 30, height: 30)
                        
                        Text(data.name.prefix(1))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(data.name)")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                        
                        HStack {
                            Text("\(data.bankName) :")
                                .font(.custom("Montserrat-Light", size: 14))
                            Text("\(data.cardNo)")
                                .font(.custom("Montserrat-Light", size: 14))
                        }
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            
            HStack {
                Spacer()
                
                NavigationLink(destination: FavoriteTransferScreen(), label: {
                    Text("Cari kontak lain")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding()
                })
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .onAppear(perform: getList)
    }
    
    func getList() {
        self.favoriteVM.getList(cardNo: "", sourceNumber: "", completion: { result in
            print(result)
        })
    }
}

struct ListFavoriteTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListFavoriteTransactionView()
    }
}
