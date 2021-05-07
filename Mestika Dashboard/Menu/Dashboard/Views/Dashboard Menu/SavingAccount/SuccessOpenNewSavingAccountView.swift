//
//  SuccessOpenNewSavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/03/21.
//

import SwiftUI

struct SuccessOpenNewSavingAccountView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    var transactionDate: String
    var deposit: String
    var destinationNumber: String
    var product: String
    
    var isFailedDeposit: Bool
    
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
                    Text(transactionDate)
                        .font(.custom("Montserrat-Bold", size: 12))
                    
                    Text("Savings Opening \nNew Successful".localized(language))
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 18))
                        .padding(.bottom, 30)
                    
                    Text("Deposit Amount".localized(language))
                        .font(.custom("Montserrat-Bold", size: 10))
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("Rp.")
                            .font(.custom("Montserrat-Bold", size: 22))
                        Text(deposit.thousandSeparator())
                            .font(.custom("Montserrat-Bold", size: 36))
                    }
                }
                .foregroundColor(.white)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Saving Account".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text(destinationNumber)
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                        Text("Savings product".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text(product)
                            .font(.custom("Montserrat-Bold", size: 20))
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(25)
                
                if isFailedDeposit {
                    VStack(alignment: .leading) {
                        Text("Setoran Gagal")
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 2)
                        
                        Text("Pembukaan akun berhasil. Namun, setoran gagal. Silahkan melakukan deposit melalui tautan dibawah ini.")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                
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
                    .padding(.horizontal, 20)
                

                Spacer()
                
            }
            
            
        }
        .navigationBarTitle("Saving Account".localized(language), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(name: NSNotification.Name("SavingAccountReturn"), object: nil, userInfo: nil)
        }
    }
}

struct SuccessOpenNewSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessOpenNewSavingAccountView(transactionDate: "", deposit: "", destinationNumber: "", product: "", isFailedDeposit: false)
    }
}
