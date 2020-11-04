//
//  ActivationATMView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct ActivationCardView: View {
    
    @State var atmNumber: String = ""
    @State var pin: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                Spacer()
                
                VStack {
                    Text("INPUT DATA ATM")
                        .font(.custom("Montserrat-Bold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Masukkan nomor kartu ATM dan PIN ATM Anda yang sudah terdaftar")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    
                TextField("Masukan nomor ATM Anda", text: $atmNumber, onEditingChanged: { changed in
                    print("\($atmNumber)")
                })
                .frame(height: 30)
                .font(.custom("Montserrat-Regular", size: 14))
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                
                TextField("Masukan PIN ATM Anda", text: $pin, onEditingChanged: { changed in
                    print("\($pin)")
                })
                .frame(height: 30)
                .font(.custom("Montserrat-Regular", size: 14))
                .padding()
                .background(Color.white)
                .cornerRadius(20)
//                    Forms
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 35)
                
                NavigationLink(
                    destination: ForgotPasswordResetPasswordView(),
                    label: {
                        Text("AKTIVASI KARTU ATM BARU")
                            .font(.custom("Montserrat-Bold", size: 14))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    })
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.top, 30)
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Aktivasi Kartu ATM Baru")
    }
}

struct ActivationATMView_Previews: PreviewProvider {
    static var previews: some View {
        ActivationCardView()
    }
}
