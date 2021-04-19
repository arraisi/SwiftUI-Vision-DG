//
//  ConfirmationOfDepositAccountView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/04/21.
//

import SwiftUI

struct ConfirmationOfDepositAccountView: View {
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var routeSuccess: Bool = false
    
    @EnvironmentObject var transferData: TransferOnUsModel
    
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
                    Text("Confirmation of \nDeposit Account".localized(language))
                    Spacer()
                }
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color("DarkStaleBlue"))
                
                HStack {
                    Text("Make sure the data related to Online Deposit transactions are correct".localized(language))
                    Spacer()
                }
                .font(.custom("Montserrat-Bold", size: 12))
                .foregroundColor(Color.gray)
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Type of Transaction".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        HStack {
                            Text("Deposit Account".localized(language))
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
                        Text("Account".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            Text("\(self.transferData.destinationNumber)")
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                                .fixedSize(horizontal: false, vertical: true)
                            
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
                            Text("Rp. \(self.transferData.amount.thousandSeparator()),00")
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
                
                NavigationLink(
                    destination: ConfirmationPinOfDepositAccountView().environmentObject(transferData),
                    isActive: self.$routeSuccess,
                    label: {}
                )
                .isDetailLink(false)
                
                Button(
                    action: {
                        self.routeSuccess = true
                    },
                    label: {
                        Text("TRANSACTION CONFIRMATION".localized(language))
                            .padding()
                            .font(.custom("Montserrat-Bold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color("StaleBlue"))
                            .cornerRadius(15)
                    }
                )
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

struct ConfirmationOfDepositAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationOfDepositAccountView()
    }
}
