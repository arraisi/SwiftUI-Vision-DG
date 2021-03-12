//
//  CardPinVerificationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/02/21.
//

import SwiftUI

struct CardPinVerificationView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var password = ""
    @State var isLoading = false
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool
    @State var wrongPassword = false
    @State var showingAlert = false
    
    @State var messageError: String = ""
    @State var statusError: String = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var tryCount: Int
    @State var timeRemainingBtn: Int = 0
    @State var isBtnValidationDisabled = true
    
    // Observable Object
    @State var activateData = ActivateKartuKuModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 0)
                
                Text("ENTER PIN \n TRANSACTION".localized(language))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#2334D0"))
                
                Text("Enter your Transaction PIN".localized(language))
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
                
                Text("(\(self.timeRemainingBtn.formatted(allowedUnits: [.minute, .second])!))")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(.red)
                    .padding(.top)
                
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
                .disabled(isBtnValidationDisabled)
                .padding(.bottom)
                .padding(.horizontal, 30)
            }
        }
        .navigationBarTitle("Transaction PIN Verification".localized(language), displayMode: .inline)
        .onAppear {
            print(tryCount)
            if (tryCount == 1) {
                self.timeRemainingBtn = 30
            } else if (tryCount == 2) {
                self.timeRemainingBtn = 60
            } else if (tryCount == 3) {
                self.timeRemainingBtn = 120
            }
        }
        .onReceive(timer) { time in
            if self.timeRemainingBtn > 0 {
                self.timeRemainingBtn -= 1
                print(timeRemainingBtn)
            }
            
            if self.timeRemainingBtn < 1 {
                isBtnValidationDisabled = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PinOffUs"))) { obj in
            print("SUCCESS PIN")
            self.activateData.pinTrx = password
            let dataPin: [String: Any] = ["pinTrx": password]
            NotificationCenter.default.post(name: NSNotification.Name("ActivatedKartuKu"), object: nil, userInfo: dataPin)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CardPinVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        CardPinVerificationView(unLocked: false, tryCount: .constant(0))
    }
}
