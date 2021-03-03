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
                        Text("13 Januari 2021")
                            .font(.custom("Montserrat-Bold", size: 12))
                        
                        Text("Pembukaan Tabungan \nBaru Berhasil")
                            .multilineTextAlignment(.center)
                            .font(.custom("Montserrat-Bold", size: 18))
                            .padding(.bottom, 30)
                        
                        Text("Jumlah Setoran")
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("Rp.")
                                .font(.custom("Montserrat-Bold", size: 22))
                            Text("500.000")
                                .font(.custom("Montserrat-Bold", size: 36))
                        }
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Rekening Tabungan")
                                .font(.custom("Montserrat-Bold", size: 10))
                            
                            Text("123456789")
                                .font(.custom("Montserrat-Bold", size: 20))
                                .padding(.bottom, 15)
                            
                            Text("Produk Tabungan")
                                .font(.custom("Montserrat-Bold", size: 10))
                            
                            Text("Tabungan SimPel")
                                .font(.custom("Montserrat-Bold", size: 20))
                            
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
                            Text(NSLocalizedString("Back to Main Page".localized(language), comment: ""))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(25)
                    
                }
            
        
        }
        .navigationTitle("")

    }
}

struct SuccessOpenNewSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessOpenNewSavingAccountView()
    }
}
