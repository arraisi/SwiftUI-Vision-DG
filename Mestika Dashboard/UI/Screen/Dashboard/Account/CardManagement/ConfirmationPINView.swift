//
//  ConfirmationPINView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/11/20.
//

import SwiftUI

struct ConfirmationPINView: View {
    
    @State var pin = ""
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked = false
    @State var wrongPin = false
    var nextView: AnyView
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(.all)
            
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
                
                NavigationLink(
                    destination: AnyView(nextView),
                    isActive: $unLocked,
                    label: {
                        Text("")
                    })
                
                Spacer(minLength: 0)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                    
                    ForEach(1...9,id: \.self) { value in
                        NumPadView(value: "\(value)", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                    }
                    
                    NumPadView(value: "delete.fill", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                        .disabled(true)
                        .hidden()
                    
                    NumPadView(value: "0", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                    
                    NumPadView(value: "delete.fill", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                }
                .padding(.bottom)
                .padding(.horizontal, 30)
            }
        }
        .navigationBarTitle("Reset PIN Transaksi", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: CardManagementScreen(), label: {
            Text("Cancel")
        }))
    }
}

struct ConfirmationPINView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPINView(pin: "", key: "", nextView: AnyView(CardManagementScreen()))
    }
}
