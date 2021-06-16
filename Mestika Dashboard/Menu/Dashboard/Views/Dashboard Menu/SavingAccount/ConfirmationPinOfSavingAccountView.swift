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
    
    @State var isFailedDeposit: Bool = false
    
    @State var showingAlert = false
    @State var routingForgotPassword: Bool = false
    
    var codePlan: String
    var product: String
    @Binding var deposit: String
    
    @State private var isLoading: Bool = false
    
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
                    destination: SuccessOpenNewSavingAccountView(transactionDate: savingAccountVM.transactionDate, deposit: deposit, destinationNumber: savingAccountVM.destinationNumber, product: product, isFailedDeposit: isFailedDeposit),
                    isActive: $success) {EmptyView()}
                
                PinVerification(pin: $pin, onChange: {
                    self.wrongPin = false
                }, onCommit: {
                    self.saveSavingAccount()
                })
            }
            
            if self.showingAlert {
                ModalOverlay(tapAction: { withAnimation { self.showingAlert = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("Saving Account".localized(language), displayMode: .inline)
        .navigationBarBackButtonHidden(isLoading)
        .popup(isPresented: $showingAlert, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
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
            
            Text("Pin Transaksi terblokir".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                
                self.showingAlert = false
                routingForgotPassword = true
                
            }) {
                Text("Forgot Pin Transaction".localized(language))
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
    
    func saveSavingAccount() {
        self.isLoading = true
        self.savingAccountVM.saveAccount(kodePlan: self.codePlan, deposit: self.deposit.replacingOccurrences(of: ".", with: ""), pinTrx: self.pin) { success in
            
            if success {
                self.isLoading = false
                
                self.isFailedDeposit = false
                self.success = true
            }
            
            if !success {
                self.isLoading = false
                
                if savingAccountVM.errorCode == "206" {
                    self.isFailedDeposit = true
                    self.success = true
                } else if (savingAccountVM.errorCode == "406") {
                    self.showingAlert = true
                    self.pin = ""
                } else {
                    self.wrongPin = true
                    self.pin = ""
                }
            }
        }
    }
}

struct ConfirmationPinOfSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPinOfSavingAccountView(codePlan: "", product: "", deposit: .constant("0"))
    }
}
