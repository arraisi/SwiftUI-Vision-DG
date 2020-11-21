//
//  RegisterProvisionView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI
import NavigationStack

struct KetentuanRegisterNasabahView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /* Data Binding */
    @Binding var rootIsActive : Bool
    
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
            cardForm
        }
        .introspectNavigationController { navigationController in
            navigationController.hidesBarsOnSwipe = true
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: EmptyView())
    }
    
    var cardForm: some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 90, height: 90)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            
            Text("Sebelum Memulai..!!")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
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
            .padding(20)
            
            PushView(destination: FormPhoneVerificationRegisterNasabahView(rootIsActive: self.$rootIsActive).environmentObject(registerData)) {
                Text("Lanjut Membuat Rekening")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
            .padding(.top, 10)
            
            Button(action : {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Batal Mendaftar")
                    .foregroundColor(.gray)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            }
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 30)
        .padding(.top, 120)
    }
}

struct RegisterProvisionView_Previews: PreviewProvider {
    static var previews: some View {
        KetentuanRegisterNasabahView(rootIsActive: .constant(false)).environmentObject(RegistrasiModel())
    }
}
