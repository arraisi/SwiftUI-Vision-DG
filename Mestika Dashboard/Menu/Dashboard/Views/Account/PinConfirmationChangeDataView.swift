//
//  PinConfirmationChangeDataView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/05/21.
//

import SwiftUI
import Indicators

struct PinConfirmationChangeDataView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @AppStorage("lock_Password") var key = "123456"
    
    // Variable
    @State var isLoading = false
    
    // PIN
    @State var pin = ""
    @State var wrongPin = false
    @State var unlocked = false
    @State var success = false
    @State var showingAlert = false
    
    var body: some View {
        ZStack {
            
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
    
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
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PinConfirmationChangeDataView_Previews: PreviewProvider {
    static var previews: some View {
        PinConfirmationChangeDataView()
    }
}
