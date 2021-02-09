//
//  ListAllFavoriteTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListAllFavoriteTransactionView: View {
    
    //    var action: ((FavoriteModelElement) -> Void)?
    @State private var activeDetails: Bool = false
    
    @StateObject private var favoriteVM = FavoritesViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text("Favorit Transfer")
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
                
                List(self.favoriteVM.favorites, id: \.id) { data in
                    NavigationLink(
                        destination: LastFavoriteTransferScreen(data: data),
                        label: {
                            Button(action: {
                                // self.action!(data)
                            }, label: {
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
                            })
                        })
                        .padding(.vertical, 5)
                }
                .colorMultiply(Color(hex: "#F6F8FB"))
                .frame(height: 500)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
        .onAppear(perform: getList)
    }
    
    func getList() {
        self.favoriteVM.getList(cardNo: "", sourceNumber: "", completion: { result in
            print(result)
        })
    }
}

struct ListAllFavoriteTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListAllFavoriteTransactionView()
    }
}
