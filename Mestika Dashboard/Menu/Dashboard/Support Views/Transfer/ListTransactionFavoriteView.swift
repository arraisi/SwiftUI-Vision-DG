//
//  ListTransactionFavoriteView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/10/20.
//

import SwiftUI

struct ListTransactionFavoriteView: View {
    
    var _listFavorite = [
        TransactionFavorit(id: 1, username: "Prima Jatnika", namaBank: "BNI", norek: "89898912383"),
        TransactionFavorit(id: 2, username: "Ilmal Yakin", namaBank: "BNI", norek: "1212312333"),
        TransactionFavorit(id: 3, username: "M. Yusuf", namaBank: "BCA", norek: "90909021333"),
        TransactionFavorit(id: 4, username: "Abdul Arraisi", namaBank: "BRI", norek: "89899899812")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Favorit Transaksi")
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            
            List {
                ForEach(_listFavorite) { data in
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
                            Text("\(data.username)")
                                .font(.subheadline)
                            
                            HStack {
                                Text("\(data.namaBank) :")
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                                Text("\(data.norek)")
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                            }
                        }
                    }.padding(.vertical, 5)
                }
            }.frame(height: 300)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
}

struct ListTransactionFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        ListTransactionFavoriteView()
    }
}
