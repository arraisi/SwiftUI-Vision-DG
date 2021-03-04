//
//  ConfirmationOfTransactionSavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/03/21.
//

import SwiftUI

struct ConfirmationOfTransactionSavingAccountView: View {
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            
            VStack(spacing: 15) {
                
                HStack {
                    Image("ic_saving_account")
                        .resizable()
                        .frame(width: 69, height: 69)
                    Spacer()
                }
                
                HStack {
                    Text(NSLocalizedString("Confirmation of \nOpening Savings".localized(language), comment: ""))
                    Spacer()
                }
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color("DarkStaleBlue"))
                
                HStack {
                    Text(NSLocalizedString("Make sure the data related to Online Deposit transactions are correct".localized(language), comment: ""))
                    Spacer()
                }
                .font(.custom("Montserrat-Bold", size: 12))
                .foregroundColor(Color.gray)
                
                VStack(spacing: 5) {
                    HStack {
                        Text(NSLocalizedString("Type of Transaction".localized(language), comment: ""))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            Text(NSLocalizedString("Savings".localized(language), comment: ""))
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
                        Text(NSLocalizedString("Savings product".localized(language), comment: ""))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            Text("Tabungan SimPel")
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
                        Text(NSLocalizedString("Deposit Amount".localized(language), comment: ""))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            Text("Rp.200.000,00")
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
                
                NavigationLink(destination: ConfirmationPinOfSavingAccountView(), label: {
                    Text(NSLocalizedString("TRANSACTION CONFIRMATION".localized(language), comment: ""))
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
    }
}

struct ConfirmationOfTransactionSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationOfTransactionSavingAccountView()
    }
}
