//
//  ConfirmationPinOfDepositAccountView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/04/21.
//

import SwiftUI
import Indicators

struct ConfirmationPinOfDepositAccountView: View {
    
    @AppStorage("lock_Password") var key = "123456"
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var isLoading = false
    
    @State var pin = ""
    @State var wrongPin = false
    @State var unlocked = false
    @State var success = false
    @State var showingAlert = false
    
    @State var messageError: String = ""
    @State var statusError: String = ""
    
    @ObservedObject var transferVM = TransferViewModel()
    
    @EnvironmentObject var transferData: TransferOnUsModel
    
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
                
                NavigationLink(
                    destination: DetailTransactionDepositAccountView(transferData: transferData),
                    isActive: $success) {EmptyView()}
                    .isDetailLink(false)
                
                PinVerification(pin: $pin, onChange: {
                    self.wrongPin = false
                }, onCommit: {
                    self.transferData.pin = pin
                    self.submitTransfer()
                })
            }
        }
        .navigationBarTitle("Account Deposit".localized(language), displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("\(self.statusError)"),
                message: Text("\(self.messageError)"),
                dismissButton: .default(Text("OK".localized(language))))
        }
    }
    
    func submitTransfer() {
        self.isLoading = true
        self.transferVM.transferOnUs(transferData: transferData) { success in
            DispatchQueue.main.async {
                if success {
                    self.isLoading = false
                    self.success = true
                    self.unlocked = true
                    self.transferData.trxDateResp = self.transferVM.transactionDate
                }
                
                if !success {
                    self.statusError = self.transferVM.code
                    self.messageError = self.transferVM.message
                    self.isLoading = false
                    self.showingAlert = true
                    resetField()
                }
            }
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
}

struct ConfirmationPinOfDepositAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPinOfDepositAccountView()
    }
}
