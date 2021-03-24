//
//  ConfirmationPinOfSavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/03/21.
//

import SwiftUI
import Indicators

struct ConfirmationPinOfSavingAccountView: View {
    
    @StateObject var savingAccountVM = SavingAccountViewModel()
    
    @AppStorage("lock_Password") var key = "123456"
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var pin = ""
    @State var wrongPin = false
    @State var unlocked = false
    @State var success = false
    
    var codePlan: String
    var product: String
    @Binding var deposit: String
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if (self.savingAccountVM.isLoading) {
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
                
                NavigationLink(
                    destination: SuccessOpenNewSavingAccountView(transactionDate: savingAccountVM.transactionDate, deposit: deposit, destinationNumber: savingAccountVM.destinationNumber, product: product),
                    isActive: $success) {EmptyView()}
                
                PinVerification(pin: $pin, onChange: {
                    self.wrongPin = false
                }, onCommit: {
                    //                    if self.pin == self.key {
                    //                        print("UNLOCKED")
                    //                        self.unlocked = true
                    //                    } else {
                    //                        print("INCORRECT")
                    //                        self.wrongPin = true
                    //                    }
                    
                    self.saveSavingAccount()
                })
            }
        }
        .onAppear{
            print("code plan \(codePlan)")
            print("product \(product)")
            print("deposit \(deposit)")
        }
        .navigationBarTitle("Saving Account".localized(language), displayMode: .inline)
    }
    
    func saveSavingAccount() {
        self.savingAccountVM.saveAccount(kodePlan: self.codePlan, deposit: self.deposit.replacingOccurrences(of: ".", with: ""), pinTrx: self.pin) { result in
            if result {
//                self.deposit = self.savingAccountVM.deposit
                self.success = true
            } else {
                self.wrongPin = true
                self.pin = ""
            }
        }
    }
}

struct ConfirmationPinOfSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPinOfSavingAccountView(codePlan: "", product: "", deposit: .constant("0"))
    }
}
