//
//  FormInputOldPinScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputOldPinScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var pin = ""
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool
    @State var wrongPin = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 0)
                
                Text(NSLocalizedString("ENTER OLD PIN".localized(language), comment: ""))
                    .font(.custom("Montserrat-SemiBold", size: 24))
                    .foregroundColor(Color(hex: "#2334D0"))
                
                Text(NSLocalizedString("Please enter your old transaction PIN".localized(language), comment: ""))
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#002251"))
                    .padding(.top, 5)
                
                HStack(spacing: 10){
                    ForEach(0..<6, id: \.self){index in
                        PinView(index: index, password: $pin, emptyColor: .constant(Color(hex: "#ADAEB0")), fillColor: .constant(Color(hex: "#2334D0")))
                    }
                }
                .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                
                
                Text(wrongPin ? NSLocalizedString("Incorrect Pin".localized(language), comment: "") : "")
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
                    .padding()
                
                Spacer(minLength: 0)
                
                NavigationLink(
                    destination: FormInputNewPinScreen(),
                    isActive: $unLocked,
                    label: {
                        Text("")
                    })
                
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
        .navigationBarTitle(NSLocalizedString("Change PIN Transaction".localized(language), comment: ""), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text(NSLocalizedString("Cancel".localized(language), comment: ""))
        }))
    }
}

struct FormInputOldPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputOldPinScreen(pin: "", key: "", unLocked: false, wrongPin: false)
    }
}
