//
//  EmailConfirmationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct FormEmailConfirmationNasabahScreen: View {
    
    @State var email: String = "admin@mestika.com"
    
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                VStack {
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 100)
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }

    }
    
    var cardForm: some View {
        VStack(alignment: .leading) {
            Image("ic_plane")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 40)
                .padding(.horizontal, 20)
            
            Text("Email Verifikasi telah Kami kirim")
                .font(.title3)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .padding([.top, .bottom], 20)
                .padding(.horizontal, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Untuk melanjutkan proses pendaftaran, Silahkan terlebih dahulu meng-klik link verifikasi yang telah kami kirimkan ke email Anda.")
                .font(.subheadline)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
                .padding(.horizontal, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            TextField("Masukan alamat email anda", text: $registerData.email)
                .frame(height: 30)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            Text("Tidak menerima email?.")
                .font(.caption)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
                .padding(.horizontal, 20)
            
            HStack {
                NavigationLink(
                    destination: FormEmailReVerificationNasabahScreen().environmentObject(registerData),
                    label: {
                        Text("Kirim Kembali Email Verifikasi.")
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color(hex: "#232175"))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                    })
            }
            
            Text("Alamat email salah?.")
                .font(.caption)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
                .padding(.horizontal, 20)
            
            HStack {
                Text("Rubah Alamat Email")
                    .font(.caption)
                    .bold()
                    .foregroundColor(Color(hex: "#232175"))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 30)
    }
}

struct FormEmailConfirmationNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormEmailConfirmationNasabahScreen().environmentObject(RegistrasiModel())
    }
}
