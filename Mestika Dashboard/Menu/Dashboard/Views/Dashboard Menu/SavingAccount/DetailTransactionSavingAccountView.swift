//
//  DetailTransactionSavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 16/03/21.
//

import SwiftUI

struct DetailTransactionSavingAccountView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    var product: String
    var deposit: String
    
    var body: some View {
        VStack {
            
            VStack(spacing: 15) {
                HStack {
                    Text("Successful Opening of New Savings".localized(language))
                    Spacer()
                }
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color("DarkStaleBlue"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Type of Transaction".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            Text("Savings".localized(language))
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.07))
                        .cornerRadius(10)
                    }
                    
                    HStack {
                        Text("Savings product".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            Text(product)
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    HStack {
                        Text("Deposit Amount".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            Text("Rp.\(deposit.thousandSeparator()),00")
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                }
                
                Button(action: {
                    
                }, label: {
                    Text("DOWNLOAD E-RECEIPT".localized(language))
                        .padding()
                        .font(.custom("Montserrat-Bold", size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color("StaleBlue"))
                        .cornerRadius(15)
                })
            }
            .padding(25) // padding content
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color("DarkStaleBlue").opacity(0.2), radius: 10)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            
            Spacer()
        }
        .padding(.vertical, 30)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.appState.moveToDashboard = true
            }, label: {
                Text("Cancel".localized(language))
                    .foregroundColor(.white)
            })
        })

    }
}

struct DetailTransactionSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTransactionSavingAccountView(product: "Tabungan Mestika", deposit: "100000")
    }
}
