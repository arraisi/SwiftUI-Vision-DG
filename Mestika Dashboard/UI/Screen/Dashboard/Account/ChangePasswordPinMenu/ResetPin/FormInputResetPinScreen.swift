//
//  FormInputResetPinScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputResetPinScreen: View {
    
    @State var pin = ""
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool
    @State var wrongPin = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Spacer(minLength: 0)
                
                Text("MASUKKAN PIN ATM")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(hex: "#2334D0"))
                
                Text("Silahkan masukkan PIN transaksi lama Anda")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(Color(hex: "#002251"))
                    .padding(.top, 5)
                
                HStack(spacing: 10){
                    ForEach(0..<6, id: \.self){index in
                        PinView(index: index, password: $pin, emptyColor: .constant(Color(hex: "#ADAEB0")), fillColor: .constant(Color(hex: "#2334D0")))
                    }
                }
                .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                
                
                Text(wrongPin ? "Incorrect Pin" : "")
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
                    .padding()
                
                Spacer(minLength: 0)
                
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                    
                    ForEach(1...9,id: \.self) { value in
                        NumPadView(value: "\(value)", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                    }
                    
                    NumPadView(value: "delete.fill", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .hidden()
                    
                    NumPadView(value: "0", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                    
                    NumPadView(value: "delete.fill", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                }
                .padding(.bottom)
                .padding(.horizontal, 30)
            }
        }
        .navigationBarTitle("Reset PIN Transaksi", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text("Cancel")
        }))
    }
}

struct FormInputResetPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputResetPinScreen(pin: "", key: "", unLocked: false, wrongPin: false)
    }
}
