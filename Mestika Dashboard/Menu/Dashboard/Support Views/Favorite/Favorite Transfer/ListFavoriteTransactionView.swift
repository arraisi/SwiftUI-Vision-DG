//
//  ListFavoriteTransaction.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListFavoriteTransactionView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @StateObject private var favoritVM = FavoritViewModel()
    
    var cardNo = ""
    var sourceNumber = ""
    
    @State private var selectedCardNo: String = ""
    @State private var selectedSourceNo: String = ""
    
    @State var isNextRoute: Bool = false
    
    @State var isLoading: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Transfer Favorites".localized(language))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            
            ScrollView(showsIndicators: false) {
                
                if (self.isLoading) {
                    
                    ProgressView()
                    
                } else if (!self.isLoading && self.favoritVM.favorites.count < 1) {
                    
                    Text("No Favorites".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .padding(.top, 25)
                    
                } else {
                    ForEach(self.favoritVM.favorites.reversed(), id: \.id) { data in
                        
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
                                    if (data.type == "TRANSFER_SESAMA") {
                                        Text("\(data.transferOnUs!.destinationNumber)")
                                            .font(.custom("Montserrat-Light", size: 14))
                                    } else {
                                        if (data.transferOffUsRtgs == nil) {
                                            Text("\(data.transferOffUsSkn!.accountTo)")
                                                .font(.custom("Montserrat-Light", size: 14))
                                        } else {
//                                            Text("\(data.bankName) : \(data.transferOffUsRtgs!.accountTo)")
//                                                .font(.custom("Montserrat-Light", size: 14))
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                }
                
            }
            
            HStack {
                Spacer()
                
                NavigationLink(
                    destination: FavoriteTransferScreen(cardNo: self.selectedCardNo, sourceNumber: self.selectedSourceNo),
                    isActive: self.$isNextRoute,
                    label: {
                        EmptyView()
                    })
                    .isDetailLink(false)
                
                Button(action: {
                    print("See All")
                    self.isNextRoute = true
                }, label: {
                    Text("See Full List".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding()
                })
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .onAppear {
            print("ON APPEAR")
            self.isNextRoute = false
            getMainAccount()
        }
    }
    
    @StateObject var savingAccountVM = SavingAccountViewModel()
    func getMainAccount() {
        self.savingAccountVM.getAccounts { (success) in
            self.savingAccountVM.accounts.forEach { e in
                
                if (e.categoryProduct == "M") {
                    self.selectedCardNo = e.cardNumber
                    self.selectedSourceNo = e.accountNumber
                }
            }
            
            getList()
        }
    }
    
    func getList() {
        self.isLoading = true
        self.favoritVM.getList(cardNo: self.selectedCardNo, sourceNumber: self.selectedSourceNo, completion: { success in
            
            if success {
                self.isLoading = false
            }

            if !success {
                self.isLoading = false
            }
        })
    }
}

struct ListFavoriteTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListFavoriteTransactionView(cardNo: "", sourceNumber: "")
    }
}
