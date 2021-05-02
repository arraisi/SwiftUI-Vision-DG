//
//  ListLastTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListLastTransactionView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    var sourceNumber = ""
    @State var listSourceNumber: [String] = []
    
    @StateObject private var favoritVM = FavoritViewModel()
    
    @StateObject var savingAccountVM = SavingAccountViewModel()
    
    @State var isLoading: Bool = true
    
    @State var showAlert: Bool = false
    
    var body: some View {
        
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text("Last transaction".localized(language))
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
                if (self.favoritVM.lastTransaction.count < 1) {
                    
                    Text("Tidak ada Transaksi")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .padding(.top, 25)
                    
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(self.favoritVM.lastTransaction, id: \.trace) { data in
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(data.sign == "D" ? Color.red : Color.green)
                                        .frame(width: 25, height: 25)
                                    
                                    Text("\(data.sign)")
                                        .foregroundColor(.white)
                                        .fontWeight(.heavy)
                                        .font(.caption)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(data.date.subStringRange(from: 6, to: 8))-\(data.date.subStringRange(from: 4, to: 6))-\(data.date.subStringRange(from: 0, to: 4))")
                                        .font(.system(size: 12))
                                    
                                    Text("\(data.historyListDescription)")
                                        .font(.system(size: 12))
                                }
                                
                                Spacer()
                                
                                HStack {
                                    
                                    if (data.sign == "D") {
                                        Text("- Rp.")
                                            .font(.system(size: 12))
                                            .foregroundColor(.red)
                                        
                                        Text("\(data.amount.thousandSeparator())")
                                            .font(.system(size: 12))
                                            .foregroundColor(.red)
                                    } else {
                                        Text("+ Rp.")
                                            .font(.system(size: 12))
                                            .foregroundColor(.green)
                                        
                                        Text("\(data.amount.thousandSeparator())")
                                            .font(.system(size: 12))
                                            .foregroundColor(.green)
                                    }
                                    
                                }
                                
                                
                            }
                            .padding(.vertical, 5)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 8)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                    .frame(height: 400)
                }
                
                
            }
            .padding(.bottom)
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .onAppear {
            self.savingAccountVM.getAccounts { success in
                
                if success {
                    self.savingAccountVM.accounts.forEach { e in
                        
                        if (e.accountType == "S") {
                            self.listSourceNumber.append(e.accountNumber)
                        }
                        
                    }
                    
                    if (self.listSourceNumber.count < 1) {
                        
                    } else {
                        getList(source: self.listSourceNumber[0])
                    }
                }
                
                if !success {
                    self.showAlert = true
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text("Session Expired"), message: Text("You have to re-login"), dismissButton: .default(Text("OK".localized(language)), action: {
                self.appState.moveToWelcomeView = true
            }))
        }
    }
    
    func getList(source: String) {
        self.favoritVM.getListLastTransaction(sourceNumber: source, completion: { success in
            if success {
                self.isLoading = false
            }
            
            if !success {
                self.isLoading = false
                self.showAlert = true
            }
        })
    }
}

struct ListLastTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListLastTransactionView()
    }
}
