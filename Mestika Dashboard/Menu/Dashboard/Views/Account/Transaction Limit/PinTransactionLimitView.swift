//
//  PinTransactionLimitView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/05/21.
//

import SwiftUI
import Indicators

struct PinTransactionLimitView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("lock_Password") var key = "123456"
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var pin = ""
    @Binding var wrongPin: Bool
    @State var unlocked = false
    @State var success = false
    
    @State var errorMessage: String = ""
    @State var statusError: String = ""
    
    @State var isShowAlert: Bool = false
    
    @State var pendingRoute: Bool = false
    
    let callback: (String)->()
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
//                if (self.qrisVM.isLoading) {
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
                
                PinVerification(pin: $pin, onChange: {
                    self.wrongPin = false
                }, onCommit: {
                    self.callback(self.pin)
                    
//                    if self.pin == self.key {
//                        print("UNLOCKED")
//                        self.unlocked = true
//                        self.appState.moveToAccountTab = true
//                    } else {
//                        print("INCORRECT")
//                        self.wrongPin = true
//                    }
                })
                .onChange(of: wrongPin) { wrong in
                    if wrong {
                        self.pin = ""
                    }
                }
            }
        }
        .navigationBarTitle("Transaction Limit", displayMode: .inline)
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("\(self.statusError)"),
                message: Text("\(self.errorMessage)"),
                dismissButton: .default(Text("OK".localized(language))))
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
}

struct PinTransactionLimitView_Previews: PreviewProvider {
    static var previews: some View {
        PinTransactionLimitView(wrongPin: .constant(false)) { pin in
            
        }
    }
}
