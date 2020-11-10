//
//  ActivationATMView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct ActivationCardView: View {
    
    @AppStorage("lock_Password") var key = "123456"
    
    @State var atmNumber: String = ""
    @State var pin: String = ""
    
    @State var nextView: Bool = false
    
    var card: MyCard
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("INPUT DATA ATM")
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Masukkan nomor kartu ATM dan PIN ATM Anda yang sudah terdaftar")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 5)
                
                TextField("Masukan nomor ATM Anda", text: $atmNumber, onEditingChanged: { changed in
                    print("\($atmNumber)")
                })
                .keyboardType(.numberPad)
                .frame(height: 50)
                .font(.custom("Montserrat-Regular", size: 14))
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(15)
                
                TextField("Masukan PIN ATM Anda", text: $pin, onEditingChanged: { changed in
                    print("\($pin)")
                })
                .keyboardType(.numberPad)
                .frame(height: 50)
                .font(.custom("Montserrat-Regular", size: 14))
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(15)
                
                NavigationLink(destination: VerificationOTPCardView(card: card), isActive: $nextView) {
                    Text("")
                }
                
                Button(action: {
                    if atmNumber != "" && pin == key {
                        nextView.toggle()
                    } else {
                        pin = ""
                    }
                }, label: {
                    Text("AKTIVASI KARTU ATM BARU")
                        .font(.custom("Montserrat-Bold", size: 14))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                })
                .background(Color.white)
                .cornerRadius(12)
                .padding(.top, 20)
            }
            .padding(.horizontal, 30)
            .padding(.top, 35)
        }
        .navigationBarTitle("Aktivasi Kartu ATM Baru", displayMode: .inline)
    }
}

struct ActivationATMView_Previews: PreviewProvider {
    static var previews: some View {
        ActivationCardView(card: myCardData[0])
    }
}
