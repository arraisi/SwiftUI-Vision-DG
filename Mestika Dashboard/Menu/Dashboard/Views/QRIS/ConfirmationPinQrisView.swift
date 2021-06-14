//
//  ConfirmationPinQrisView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/03/21.
//

import SwiftUI
import Indicators

struct ConfirmationPinQrisView: View {
    
    @AppStorage("lock_Password") var key = "123456"
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var pin = ""
    @State var wrongPin = false
    @State var unlocked = false
    @State var success = false
    
    @State var errorMessage: String = ""
    @State var statusError: String = ""
    
    @State var isShowAlert: Bool = false
    
    @State var pendingRoute: Bool = false
    
    @StateObject var qrisVM = QrisViewModel()
    
    @State var routingForgotPassword: Bool = false
    
    // Environtment Object
    @EnvironmentObject var qrisData: QrisModel
    
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
                
                if (self.qrisVM.isLoading) {
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
                    destination: SuccessPaymentQrisView().environmentObject(qrisData),
                    isActive: $unlocked) {EmptyView()}
                
                NavigationLink(
                    destination: PendingPaymentQrisView().environmentObject(qrisData),
                    isActive: $pendingRoute) {EmptyView()}
                
                PinVerification(pin: $pin, onChange: {
                    self.wrongPin = false
                }, onCommit: {
                    self.qrisData.pinTrx = pin
                    
                    self.qrisVM.payQris(data: qrisData) { success in
                        
                        if success {
                            self.qrisData.pan = self.qrisVM.pan
                            self.qrisData.transactionDate = self.qrisVM.transactionDate
                            self.qrisData.reffNumber = self.qrisVM.reffNumber
                            self.qrisData.responseCode = self.qrisVM.responseCode
                            
                            
                            if (self.qrisData.responseCode == "00") {
                                self.unlocked = true
                            } else if (self.qrisData.responseCode == "68") {
                                self.pendingRoute = true
                            }
                            
                        }
                        
                        if !success {
                            self.errorMessage = self.qrisVM.message
                            self.statusError = self.qrisVM.code
                            self.isShowAlert = true
                            resetField()
                        }
                        
                    }
                })
            }
            
            if self.isShowAlert {
                ModalOverlay(tapAction: { withAnimation { self.isShowAlert = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("Pembayaran QRIS", displayMode: .inline)
        .popup(isPresented: $isShowAlert, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageError()
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
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

struct ConfirmationPinQrisView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPinQrisView()
    }
}
