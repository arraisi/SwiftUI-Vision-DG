//
//  RegisterProvisionView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI
import Introspect

struct KetentuanRegisterNasabahView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Data Model */
    @StateObject var ketentuanViewModel = KetentuanViewModel()
    
    // MARK: -MAIN CONTENT
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                
                cardForm
                    .padding(.top, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarItems(trailing: EmptyView())
        .introspectNavigationController { nc in
            nc.navigationBar.isHidden = false
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 90, height: 90)
                .padding(.top, 30)
            
            Text("Sebelum Memulai..!!")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.top, 10)
            
            VStack(spacing: 20) {
                ForEach(ketentuanViewModel.data) { data in
                    HStack(alignment: .top) {
                        Text(data.number)
                            .font(.custom("Montserrat-Bold", size: 12))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        Text(data.caption)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            NavigationLink(destination: FormPhoneVerificationRegisterNasabahView().environmentObject(registerData)){
                Text("Lanjut Membuat Rekening")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 5)
            .padding(.top, 10)
            
            Button(action : {
                self.appState.moveToWelcomeView = true
            }) {
                Text("Batal Mendaftar")
                    .foregroundColor(.gray)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            }
            .cornerRadius(12)
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 30)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
    }
}

struct RegisterProvisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KetentuanRegisterNasabahView().environmentObject(RegistrasiModel())
        }
    }
}
