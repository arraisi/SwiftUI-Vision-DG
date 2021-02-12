//
//  ListTransactionFavoriteView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/10/20.
//

import SwiftUI

struct ListTransactionFavoriteView: View {
    
    @StateObject private var favoritVM = FavoritViewModel()
    var cardNo = ""
    var sourceNumber = ""
    
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
            
            ForEach(self.favoritVM.favorites, id: \.id) { data in
                
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
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .onAppear(perform: getList)
    }
    
    func getList() {
        self.favoritVM.getList(cardNo: self.cardNo, sourceNumber: self.sourceNumber, completion: { result in
            print(result)
        })
    }
}

struct ListTransactionFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        ListTransactionFavoriteView(cardNo: "", sourceNumber: "")
    }
}
