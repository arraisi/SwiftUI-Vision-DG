//
//  TransferOnUsPinConfirmationScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct TransferOnUsPinConfirmationScreen: View {
    
    @State var password = ""
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool
    @State var wrongPassword = false
    
    var body: some View {
        if unLocked {
            TransferOnUsSuccessInformationScreen()
        } else {
            ZStack {
                Image("bg_blue")
                    .resizable()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Spacer(minLength: 0)
                    
                    Text("Masukan PIN Transaksi anda")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10){
                        ForEach(0..<6, id: \.self){index in
                            PinView(index: index, password: $password, emptyColor: .constant(Color(hex: "#ADAEB0")), fillColor: .constant(Color.white))
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                    
                    
                    Text(wrongPassword ? "Incorrect Pin" : "")
                        .foregroundColor(.red)
                        .fontWeight(.heavy)
                        .padding()
                    
                    Spacer(minLength: 0)
                    
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                        
                        ForEach(1...9,id: \.self) { value in
                            NumPadView(value: "\(value)",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white))
                        }
                        
                        NumPadView(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white))
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .hidden()
                        
                        NumPadView(value: "0", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white))
                        
                        NumPadView(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white))
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 30)
                }
            }
            .navigationBarItems(trailing: Button(action: {}, label: {
                Text("Cancel")
            }))
        }
    }
}

#if DEBUG
struct TransferOnUsPinConfirmationScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferOnUsPinConfirmationScreen(password: "", key: "", unLocked: false, wrongPassword: false)
    }
}
#endif
