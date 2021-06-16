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
    
    @State var routingForgotPassword: Bool = false
    
    let callback: (String)->()
    
    var body: some View {
        
        NavigationLink(
            destination: TransactionForgotPinView(),
            isActive: self.$routingForgotPassword,
            label: {}
        )
        
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
                    self.pin = ""
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
            
            if self.isShowAlert {
                ModalOverlay(tapAction: { withAnimation { self.isShowAlert = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("Transaction Limit", displayMode: .inline)
        .popup(isPresented: $isShowAlert, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageError()
        }
    }
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("\(self.errorMessage)".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                
                if (self.statusError == "406") {
                    self.isShowAlert = false
                    routingForgotPassword = true
                }
                
            }) {
                Text(self.statusError == "406" ? "Forgot Pin Transaction".localized(language) : "Back".localized(language))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Text("")
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct PinTransactionLimitView_Previews: PreviewProvider {
    static var previews: some View {
        PinTransactionLimitView(wrongPin: .constant(false)) { pin in
            
        }
    }
}
