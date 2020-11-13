//
//  ChangePasswordOrPinSettingScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct ChangePasswordOrPinSettingScreen: View {
    var body: some View {
        VStack {
            VStack {
                List {
                    NavigationLink(destination: FormInputOldPasswordScreen(), label: {
                        Text("Ubah PIN Transaksi")
                    })
                    
                    NavigationLink(destination: FormInputOldPasswordScreen(), label: {
                        Text("Ubah Password")
                    })
                    
                    NavigationLink(destination: FormInputResetPinScreen(unLocked: false), label: {
                        Text("Reset PIN Transaksi")
                    })
                }
                .padding([.top, .bottom], 20)
                .frame(height: 200)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 20)
            
            Spacer()
        }
        .navigationBarTitle("Ubah Password / PIN", displayMode: .inline)
    }
}

struct ChangePasswordOrPinSettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordOrPinSettingScreen()
    }
}
