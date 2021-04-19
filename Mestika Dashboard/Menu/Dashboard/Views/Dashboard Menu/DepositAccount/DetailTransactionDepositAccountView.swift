//
//  DetailTransactionDepositAccountView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/04/21.
//

import SwiftUI

struct DetailTransactionDepositAccountView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    var transferData: TransferOnUsModel
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Image("logo_m_mestika")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.top, 30)
                    .padding()
                
                VStack(spacing: 5) {
                    Text("\(self.transferData.trxDateResp)")
                        .font(.custom("Montserrat-Bold", size: 12))
                    
                    Text("Deposit Account \n Successful".localized(language))
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 18))
                        .padding(.bottom, 30)
                    
                    Text("Deposit Amount".localized(language))
                        .font(.custom("Montserrat-Bold", size: 10))
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("Rp.")
                            .font(.custom("Montserrat-Bold", size: 22))
                        Text("\(self.transferData.amount.thousandSeparator())")
                            .font(.custom("Montserrat-Bold", size: 36))
                    }
                }
                .foregroundColor(.white)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Deposit Account".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text("\(self.transferData.destinationNumber)")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(25)
                
                Spacer()
                
                Button(
                    action: {
                        self.appState.moveToDashboard = true
                    },
                    label: {
                        Text("Back to Main Page".localized(language))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                

                Spacer()
                
                
            }
            
            
        }
        .navigationBarTitle("Deposit Account".localized(language), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct DetailTransactionDepositAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTransactionDepositAccountView(transferData: TransferOnUsModel())
    }
}
