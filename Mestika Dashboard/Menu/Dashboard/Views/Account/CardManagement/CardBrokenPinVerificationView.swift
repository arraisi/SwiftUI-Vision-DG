//
//  CardBrokenPinVerificationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/02/21.
//

import SwiftUI

struct CardBrokenPinVerificationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var password = ""
    @State var isLoading = false
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool
    @State var wrongPassword = false
    @State var showingAlert = false
    
    @State var messageError: String = ""
    @State var statusError: String = ""
    
    // Observable Object
    @State var brokenData = BrokenKartuKuModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 0)
                
                Text("MASUKKAN PIN \n TRANSAKSI")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#2334D0"))
                
                Text("Masukkan PIN Transaksi anda")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2334D0"))
                    .padding(.top)
                
                HStack(spacing: 10){
                    ForEach(0..<6, id: \.self){index in
                        PinView(index: index, password: $password, emptyColor: .constant(Color(hex: "#ADAEB0")), fillColor: .constant(Color(hex: "#2334D0")))
                    }
                }
                .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                
                Spacer(minLength: 0)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                    
                    ForEach(1...9,id: \.self) { value in
                        NumPadView(value: "\(value)",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: false)
                    }
                    
                    NumPadView(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: false)
                        .disabled(true)
                        .hidden()
                    
                    NumPadView(value: "0", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: false)
                    
                    NumPadView(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(Color(hex: "#2334D0")), isTransferOnUs: false)
                }
                .padding(.bottom)
                .padding(.horizontal, 30)
            }
        }
        .navigationBarTitle("Laporan Kerusakan", displayMode: .inline)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PinOffUs"))) { obj in
            print("SUCCESS PIN")
            let dataPin: [String: Any] = ["pinTrx": password]
            NotificationCenter.default.post(name: NSNotification.Name("BrokenKartuKu"), object: nil, userInfo: dataPin)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CardBrokenPinVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        CardBrokenPinVerificationView(unLocked: false)
    }
}
