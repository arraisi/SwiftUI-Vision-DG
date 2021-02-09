//
//  TransferRtgsValidationPin.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/02/21.
//

import SwiftUI

struct TransferRtgsValidationPin: View {
    @EnvironmentObject var transferData: TransferOffUsModel
    
    @State var password = ""
    @State var isLoading = false
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool
    @State var wrongPassword = false
    @State var showingAlert = false
    
    @ObservedObject var transferVM = TransferViewModel()
    
    var body: some View {
        if unLocked {
            TransferRtgsSuccess(transferData: transferData)
        } else {
            ZStack {
                Image("bg_blue")
                    .resizable()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Spacer(minLength: 0)
                    
                    Text("Masukkan PIN Transaksi anda")
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
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .hidden()
                        
                        NumPadView(value: "0", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: true)
                        
                        NumPadView(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword, keyDeleteColor: .constant(.white), isTransferOnUs: true)
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 30)
                }
            }
            .navigationBarTitle("Transfer \(self.transferData.transactionType)", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                return Alert(
                    title: Text("Message"),
                    message: Text("\(self.transferVM.message)"),
                    dismissButton: .default(Text("Oke")))
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PinOnUs"))) { obj in
                print("SUCCESS PIN")
                submitTransfer()
            }
        }
    }
    
    func submitTransfer() {
//        self.isLoading = true
        self.isLoading = false
        self.unLocked = true
//        self.transferVM.transferOnUs(transferData: transferData) { success in
//            DispatchQueue.main.async {
//                if success {
//                    self.isLoading = false
//                    self.unLocked = true
//                }
//
//                if !success {
//                    self.isLoading = false
//                    self.showingAlert = true
//                }
//            }
//        }
    }
}

struct TransferRtgsValidationPin_Previews: PreviewProvider {
    static var previews: some View {
        TransferRtgsValidationPin(password: "", isLoading: false, key: "", unLocked: false, wrongPassword: false).environmentObject(TransferOffUsModel())
    }
}
