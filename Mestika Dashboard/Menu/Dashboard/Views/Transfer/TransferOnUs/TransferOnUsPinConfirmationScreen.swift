//
//  TransferOnUsPinConfirmationScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI
import Indicators

struct TransferOnUsPinConfirmationScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var transferData: TransferOnUsModel
    
    @State var password = ""
    @State var isLoading = false
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool
    @State var wrongPassword = false
    @State var showingAlert = false
    @State var forgotView: Bool = false
    
    @State var messageError: String = ""
    @State var statusError: String = ""
    
    @State var routingForgotPassword: Bool = false
    
    @ObservedObject var transferVM = TransferViewModel()
    
    var body: some View {
        
        NavigationLink(
            destination: TransactionForgotPinView(),
            isActive: self.$routingForgotPassword,
            label: {}
        )
        
        if forgotView {
            TransactionForgotPinView()
        } else {
            ZStack {
                Image("bg_blue")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                NavigationLink(
                    destination: TransferOnUsSuccessInformationScreen(transferData: transferData),
                    isActive: self.$unLocked,
                    label: {EmptyView()}
                )
                .isDetailLink(false)
                
                VStack {
                    
                    if (self.isLoading) {
                        LinearWaitingIndicator()
                            .animated(true)
                            .foregroundColor(.green)
                            .frame(height: 1)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Text("Enter your Transaction PIN".localized(language))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10){
                        ForEach(0..<6, id: \.self){index in
                            PinView(index: index, password: $password, emptyColor: .constant(Color(hex: "#ADAEB0")), fillColor: .constant(Color.white))
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                    
                    
                    Text(wrongPassword ? "Incorrect Pin" : "")
                        .foregroundColor(.red)
                        .fontWeight(.heavy)
                        .padding()
                    
                    Spacer(minLength: 0)
                    
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                        
                        ForEach(1...9,id: \.self) { value in
                            NumPadView(value: "\(value)",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: true)
                        }
                        
                        NumPadView(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: true)
                            .disabled(true)
                            .hidden()
                        
                        NumPadView(value: "0", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: true)
                        
                        NumPadView(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: true)
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 30)
                }
                
                if self.showingAlert {
                    ModalOverlay(tapAction: { withAnimation { self.showingAlert = false } })
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationBarTitle("Transfer ONUS", displayMode: .inline)
            .navigationBarBackButtonHidden(self.isLoading)
            .popup(isPresented: $showingAlert, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageError()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PinOnUs"))) { obj in
                print("SUCCESS PIN")
                self.transferData.pin = password
                submitTransfer()
            }
        }
    }
    
    func submitTransfer() {
        self.isLoading = true
        self.transferVM.transferOnUs(transferData: transferData) { success in
            DispatchQueue.main.async {
                if success {
                    self.isLoading = false
                    self.unLocked = true
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
        self.password = "" /// return to empty pin
    }
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("\(self.messageError)".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                
                if (self.statusError == "407") {
//                    routingForgotPassword = true
                    self.forgotView = true
                }
                
            }) {
                Text(self.statusError == "407" ? "Forgot Pin".localized(language) : "Back".localized(language))
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


#if DEBUG
struct TransferOnUsPinConfirmationScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferOnUsPinConfirmationScreen(password: "", isLoading: false, key: "", unLocked: false, wrongPassword: false).environmentObject(TransferOnUsModel())
    }
}
#endif
