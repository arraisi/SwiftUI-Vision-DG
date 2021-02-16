//
//  FormInputResetPinScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputResetPinScreen: View {
    
    @StateObject private var authVM = AuthViewModel()
    
    @EnvironmentObject var appState: AppState
    
    var cardNo = ""
    var newPin = ""
    
    @State var pin = ""
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool = false
    @State var wrongPin = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                AppBarLogo(light: true) {}
                
                VStack {
                    
                    Spacer(minLength: 0)
                    
                    Text("MASUKKAN PIN ATM")
                        .font(.custom("Montserrat-SemiBold", size: 24))
                        .foregroundColor(Color(hex: "#2334D0"))
                    
                    Text("Silahkan masukkan PIN ATM Anda")
                        .font(.custom("Montserrat-Regular", size: 12))
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
                    
                    //                NavigationLink(
                    //                    destination: OtpResetPinScreen(),
                    //                    isActive: $unLocked,
                    //                    label: {
                    //                        Text("")
                    //                    })
                    
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
                    
                    //                    NavigationLink(destination: BottomNavigationView(), isActive: $shouldPopToRootView) {EmptyView()}
                }
                .padding(.vertical)
                
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PinForgotPinTrx"))) { obj in
            print("SUCCESS PIN")
            self.authVM.forgotPinTransaksi(cardNo: cardNo, pin: pin, newPinTrx: newPin) { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.appState.moveToAccountTab = true
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        //        .navigationBarTitle("Reset PIN Transaksi", displayMode: .inline)
        //        .navigationBarItems(trailing: Button(action: {}, label: {
        //            Text("Cancel")
        //        }))
    }
}

struct FormInputResetPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputResetPinScreen(pin: "", key: "", unLocked: false, wrongPin: false)
    }
}
