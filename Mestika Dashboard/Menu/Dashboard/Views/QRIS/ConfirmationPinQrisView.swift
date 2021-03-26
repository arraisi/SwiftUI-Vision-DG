//
//  ConfirmationPinQrisView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/03/21.
//

import SwiftUI
import Indicators

struct ConfirmationPinQrisView: View {
    
    @AppStorage("lock_Password") var key = "123456"
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var pin = ""
    @State var wrongPin = false
    @State var unlocked = false
    @State var success = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                //                if (self.savingAccountVM.isLoading) {
                //                    LinearWaitingIndicator()
                //                        .animated(true)
                //                        .foregroundColor(.green)
                //                        .frame(height: 1)
                //                }
                
                Spacer(minLength: 0)
                
                Text("Enter your Transaction PIN".localized(language))
                    .font(.custom("Montserrat-SemiBold", size: 18))
                    .foregroundColor(Color.white)
                
                HStack(spacing: 10){
                    ForEach(0..<6, id: \.self){index in
                        PinView(index: index, password: $pin, emptyColor: .constant(Color(hex: "#2334D0")), fillColor: .constant(Color.white))
                    }
                }
                .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                
                
                Text(wrongPin ? "Incorrect Pin".localized(language) : "")
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
                    .padding()
                
                Spacer(minLength: 0)
                
                NavigationLink(
                    destination: SuccessPaymentQrisView(),
                    isActive: $unlocked) {EmptyView()}
                
                PinVerification(pin: $pin, onChange: {
                    self.wrongPin = false
                }, onCommit: {
                    if self.pin == self.key {
                        print("UNLOCKED")
                        self.unlocked = true
                    } else {
                        print("INCORRECT")
                        self.wrongPin = true
                    }
                })
            }
        }
        .navigationBarTitle("Pembayaran QRIS", displayMode: .inline)
    }
}

struct ConfirmationPinQrisView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPinQrisView()
    }
}
