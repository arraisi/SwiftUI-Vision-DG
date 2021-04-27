//
//  MoveBalancePinView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI
import Indicators

struct MoveBalancePinView: View {
    
    // Environtment Object
    @EnvironmentObject var transactionData: MoveBalancesModel
    
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
    
    // Message
    @State var messageError: String = ""
    @State var statusError: String = ""
    
    var body: some View {
        ZStack {
            
            NavigationLink(
                destination: SuccessMoveBalancesView().environmentObject(transactionData),
                isActive: self.$success,
                label: {}
            )
            
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
                    self.transactionData.pin = pin
                    self.success = true
                })
            }
        }
        .navigationBarTitle("Pindah Saldo".localized(language), displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("\(self.statusError)"),
                message: Text("\(self.messageError)"),
                dismissButton: .default(Text("OK".localized(language))))
        }
    }
}

struct MoveBalancePinView_Previews: PreviewProvider {
    static var previews: some View {
        MoveBalancePinView().environmentObject(MoveBalancesModel())
    }
}
