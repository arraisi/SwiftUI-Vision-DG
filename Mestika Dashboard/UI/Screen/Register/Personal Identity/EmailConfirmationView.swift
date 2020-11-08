//
//  EmailConfirmationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct EmailConfirmationView: View {
    
    @State var email: String = "admin@mestika.com"
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                appbar
                    .padding(.top, 45)
                    .padding(.horizontal, 30)
                
                VStack {
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 35)
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }

    }
    
    var appbar: some View {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }
                Spacer()
                logo
                Spacer()
            }
        }
        
        var logo: some View {
            HStack(alignment: .center, spacing: .none) {
                Image("Logo M")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("BANK MESTIKA")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .bold()
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
            
            TextField("Masukan alamat email anda", text: $email)
                .frame(height: 30)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            
            Text("Tidak menerima email?.")
                .font(.caption)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
                .padding(.horizontal, 20)
            
            HStack {
                Text("Kirim Kembali Email Verifikasi.")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(hex: "#232175"))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
            }
            
            Text("Alamat email salah?.")
                .font(.caption)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
                .padding(.horizontal, 20)
            
            HStack {
                Text("Rubah Alamat Email")
                    .font(.subheadline)
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

struct EmailConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailConfirmationView()
    }
}
