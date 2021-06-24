//
//  TransactionLimitView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 07/05/21.
//

import SwiftUI

struct TransactionLimitView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let data: GlobalLimitModel = load("globalLimitData.json")
    let userData: UserLimitModel = load("userLimitData.json")
    
    @StateObject var trxLimitVM = TransactionLimitViewModel()
    
    @State private var pinActive: Bool = false
    @State private var wrongPin: Bool = false
    @State private var showingAlert: Bool = false
    
    @State private var iconAlert: String = "xmark.octagon.fill"
    @State private var messageCode: String = ""
    @State private var messageStatus: String = ""
    
    @State var routingForgotPassword: Bool = false
    
    var body: some View {
        
        NavigationLink(
            destination: TransactionForgotPinView(),
            isActive: self.$routingForgotPassword,
            label: {}
        )
        
        if pinActive {
            ZStack {
                PinTransactionLimitView(wrongPin: $wrongPin) { pin in
                    trxLimitVM.saveTrxUserLimit(pin: pin) { result in
                        switch result {
                        case .success( _):
                            iconAlert = "ic_success"
                            messageCode = "Successful"
                            messageStatus = "Update limit transaction"
                            
                            showingAlert = true
                            print("Success")
                            
                        case .failure(let error):
                            
                            switch error {
                            case .custom(code: 404):
                                messageCode = "Failed"
                                messageStatus = "Failed to save or update user limit"
                                
                                showingAlert = true
                            case .custom(code: 406):
                                messageCode = "406"
                                messageStatus = "PIN Transaksi Terblokir"
                                
                                showingAlert = true
                            default:
                                self.wrongPin = true
                                print("ERROR FAVORITES--> \(error)")
                            }
                        }
                        
                    }
                }
                
                if self.showingAlert {
                    ModalOverlay(tapAction: { withAnimation { self.showingAlert = false } })
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .popup(isPresented: $showingAlert, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageError()
            }
        } else {
            ZStack {
                
                VStack(alignment: .center) {
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 20) {
                            
                            TrasactionLimitRow(lable: "Transfer internal rekening milik sendiri (Rupiah)", min: 10000, value: $trxLimitVM.trxOnCifIdr, txtValue: $trxLimitVM.trxOnCifIdrTxt, max: $trxLimitVM.maxTrxOnCifIdr)
                            
                            TrasactionLimitRow(lable: "Transfer internal rekening milik sendiri (Non Rupiah)", min: 10000, value: $trxLimitVM.trxOnCifNonIdr, txtValue: $trxLimitVM.trxOnCifNonIdrTxt, max: $trxLimitVM.maxTrxOnCifNonIdr)
                            
                            TrasactionLimitRow(lable: "Limit transaksi on us (Rupiah)", min: 10000, value: $trxLimitVM.trxOnUsIdr, txtValue: $trxLimitVM.trxOnUsIdrTxt, max: $trxLimitVM.maxTrxOnUsIdr)
                            
                            TrasactionLimitRow(lable: "Limit transaksi on us (Non Rupiah)", min: 10000, value: $trxLimitVM.trxOnUsNonIdr, txtValue: $trxLimitVM.trxOnUsNonIdrTxt, max: $trxLimitVM.maxTrxOnUsNonIdr)
                            
                            TrasactionLimitRow(lable: "Limit transaksi virtual akun", min: 10000, value: $trxLimitVM.trxVirtualAccount, txtValue: $trxLimitVM.trxVirtualAccountTxt, max: $trxLimitVM.maxTrxVirtualAccount)
                            
                            TrasactionLimitRow(lable: "Limit transaksi SKN", min: 10000, value: $trxLimitVM.trxSknTransfer, txtValue: $trxLimitVM.trxSknTransferTxt, max: $trxLimitVM.maxTrxSknTransfer)
                            
                            TrasactionLimitRow(lable: "Limit transaksi RTGS", min: 10000, value: $trxLimitVM.trxRtgsTransfer, txtValue: $trxLimitVM.trxRtgsTransferTxt, max: $trxLimitVM.maxTrxRtgsTransfer)
                            
                            TrasactionLimitRow(lable: "Limit transaksi IBFT", min: 10000, value: $trxLimitVM.trxOnlineTransfer, txtValue: $trxLimitVM.trxOnlineTransferTxt, max: $trxLimitVM.maxTrxOnlineTransfer)
                            
                            TrasactionLimitRow(lable: "Limit pembayaran tagihan", min: 10000, value: $trxLimitVM.trxBillPayment, txtValue: $trxLimitVM.trxBillPaymentTxt, max: $trxLimitVM.maxTrxBillPayment)
                            
                            TrasactionLimitRow(lable: "Limit pembelian", min: 10000, value: $trxLimitVM.trxPurchase, txtValue: $trxLimitVM.trxPurchaseTxt, max: $trxLimitVM.maxTrxPurchase)
                            
                        }
                        .padding()
                        .padding(.top, 20)
                    }
                    
                    
                    Spacer()
                    
                    VStack {
                        HStack(alignment: .center) {
                            Button(action: {
                                self.pinActive = true
                            }, label: {
                                Text("SIMPAN")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 300, height: 40)
                            })
                            .background(Color("StaleBlue"))
                            .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        
                    }
                    .padding(5)
                    .background(Color.white)
                }
            }
            .navigationBarTitle("Transaction Limit", displayMode: .inline)
            .onTapGesture() {
                UIApplication.shared.endEditing()
            }
            .onAppear(perform: {
                //                trxLimitVM.mappingGlobalLimitData(data: data)
                //                trxLimitVM.mappingUserLimitData(data: userData)
                trxLimitVM.findTrxGlobalLimit()
                trxLimitVM.findTrxUserLimit()
            })
        }
        
    }
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: self.iconAlert)
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("\(self.messageStatus)".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                
                if (self.messageCode == "406") {
                    self.showingAlert = false
                    routingForgotPassword = true
                } else {
                    self.showingAlert = false
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }) {
                Text(self.messageCode == "406" ? "Forgot Pin Transaction".localized(language) : "Back".localized(language))
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

struct TransactionLimitView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionLimitView()
        }
    }
}
