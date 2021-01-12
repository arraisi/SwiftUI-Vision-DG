//
//  SuccessCancelView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 11/01/21.
//

import SwiftUI

struct SuccessCancelView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#232175")
            
            VStack(spacing: 10) {
                Spacer()
                
                ZStack() {
                    VStack(spacing: 5) {
                        Image("ic_success")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(.bottom, 20)
                        
                        Text(NSLocalizedString("Berhasil", comment: ""))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 16))
                        
                        Text(NSLocalizedString("Permohonan Pembukaan Rekening Telah Dibatalkan", comment: ""))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Normal", size: 12))
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(spacing: 5) {
                    
                    Button(action: {
                        self.appState.moveToWelcomeView = true
                    }, label: {
                        Text(NSLocalizedString("Kembali ke Halaman Utama", comment: ""))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Bold", size: 16))
                    })
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .cornerRadius(15)
                }
                .padding(20)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct SuccessCancelView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessCancelView()
    }
}
