//
//  ConfirmationPinOfSavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/03/21.
//

import SwiftUI

struct ConfirmationPinOfSavingAccountView: View {
    
    @AppStorage("lock_Password") var key = "123456"
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var pin = ""
    @State var wrongPin = false
    @State var unlocked = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 0)
                
                Text(NSLocalizedString("Enter your Transaction PIN".localized(language), comment: ""))
                    .font(.custom("Montserrat-SemiBold", size: 18))
                    .foregroundColor(Color.white)
                
                HStack(spacing: 10){
                    ForEach(0..<6, id: \.self){index in
                        PinView(index: index, password: $pin, emptyColor: .constant(Color(hex: "#2334D0")), fillColor: .constant(Color.white))
                    }
                }
                .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                
                
                Text(wrongPin ? NSLocalizedString("Incorrect Pin".localized(language), comment: "") : "")
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
                    .padding()
                
                Spacer(minLength: 0)
                
                NavigationLink(
                    destination: SuccessOpenNewSavingAccountView(),
                    isActive: $unlocked,
                    label: {
                        Text("")
                    })
                
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
        .navigationBarTitle(NSLocalizedString("Saving Account".localized(language), comment: ""), displayMode: .inline)
    }
}

struct ConfirmationPinOfSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPinOfSavingAccountView()
    }
}
