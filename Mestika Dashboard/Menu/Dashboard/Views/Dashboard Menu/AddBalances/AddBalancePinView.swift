//
//  AddBalancePinView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI
import Indicators

struct AddBalancePinView: View {
    
    @EnvironmentObject var appState: AppState
    
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
                destination: SuccessAddBalanceView(transferData: transactionData).environmentObject(appState),
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
                    submitData()
                })
            }
            
            if self.showingAlert {
                ModalOverlay(tapAction: { withAnimation { self.showingAlert = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
//        .alert(isPresented: $showingAlert) {
//            return Alert(
//                title: Text("\(self.statusError)"),
//                message: Text("\(self.messageError)"),
//                dismissButton: .default(Text("OK".localized(language))))
//        }
        .popup(isPresented: $showingAlert, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageError()
        }
    }
    
    // func submit data
    @ObservedObject var transferVM = TransferViewModel()
    func submitData() {
        self.isLoading = true
        self.transferVM.moveBalance(transferData: transactionData) { success in
            DispatchQueue.main.async {
                if success {
                    self.isLoading = false
                    self.success = true
                    self.transactionData.trxDateResp = self.transferVM.transactionDate
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
            
            Button(action: {}) {
                Text("Back".localized(language))
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

struct AddBalancePinView_Previews: PreviewProvider {
    static var previews: some View {
        AddBalancePinView().environmentObject(MoveBalancesModel())
    }
}
