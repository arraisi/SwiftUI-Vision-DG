//
//  ListAllFavoriteTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListAllFavoriteTransactionView: View {
    
    var action: ((TransactionFavorit) -> Void)?
    @State private var activeDetails: Bool = false
    
    @State var _listFavorite = [
        TransactionFavorit(id: 1, username: "Prima Jatnika", namaBank: "BNI", norek: "89898912383"),
        TransactionFavorit(id: 2, username: "Ilmal Yakin", namaBank: "BNI", norek: "1212312333"),
        TransactionFavorit(id: 3, username: "M. Yusuf", namaBank: "BCA", norek: "90909021333"),
        TransactionFavorit(id: 4, username: "Abdul Arraisi", namaBank: "BRI", norek: "89899899812")
    ]
    
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
                
                List(0..._listFavorite.count - 1, id: \.self) { index in
                    NavigationLink(
                        destination: LastFavoriteTransferScreen(dataFavorit: self.$_listFavorite[index]),
                        label: {
                            Button(action: {
                                self.action!(_listFavorite[index])
                            }, label: {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.secondary)
                                            .frame(width: 30, height: 30)
                                        
                                        Text("A")
                                            .foregroundColor(.white)
                                            .fontWeight(.heavy)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(_listFavorite[index].username)")
                                            .foregroundColor(Color(hex: "#1D2238"))
                                            .font(.subheadline)
                                        
                                        HStack {
                                            Text("\(_listFavorite[index].namaBank) :")
                                                .foregroundColor(Color(hex: "#1D2238"))
                                                .font(.caption)
                                                .fontWeight(.ultraLight)
                                            Text("\(_listFavorite[index].norek)")
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

struct ListAllFavoriteTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListAllFavoriteTransactionView()
    }
}
