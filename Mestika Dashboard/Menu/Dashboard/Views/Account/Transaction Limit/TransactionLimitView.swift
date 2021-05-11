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
    
    var body: some View {
        if pinActive {
            PinTransactionLimitView(wrongPin: $wrongPin) { pin in
                trxLimitVM.saveTrxUserLimit(pin: pin) { result in
                    switch result {
                    case .success( _):
                        //                        presentationMode.wrappedValue.dismiss()
                        showingAlert = true
                        print("Success")
                        
                    case .failure(let error):
                        self.wrongPin = true
                        print("ERROR GET LIST FAVORITES--> \(error)")
                    }
                    
                }
            }
            .alert(isPresented: $showingAlert) {
                return Alert(
                    title: Text("Successful".localized(language)),
                    message: Text("Update limit transaction".localized(language)),
                    dismissButton: .default(Text("OK".localized(language)), action: {
                        presentationMode.wrappedValue.dismiss()
                    }))
            }
        } else {
            ZStack {
                
                VStack(alignment: .center) {
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 20) {
                            
                            TrasactionLimitRow(lable: "Transfer internal rekening milik sendiri (Rupiah)", min: 10000, value: $trxLimitVM.trxOnCifIdr, max: $trxLimitVM.maxTrxOnCifIdr)
                            
                            TrasactionLimitRow(lable: "Transfer internal rekening milik sendiri (Non Rupiah)", min: 10000, value: $trxLimitVM.trxOnCifNonIdr, max: $trxLimitVM.maxTrxOnCifNonIdr)
                            
                            TrasactionLimitRow(lable: "Limit transaksi on us (Rupiah)", min: 10000, value: $trxLimitVM.trxOnUsIdr, max: $trxLimitVM.maxTrxOnUsIdr)
                            
                            TrasactionLimitRow(lable: "Limit transaksi on us (Non Rupiah)", min: 10000, value: $trxLimitVM.trxOnUsNonIdr, max: $trxLimitVM.maxTrxOnUsNonIdr)
                            
                            TrasactionLimitRow(lable: "Limit transaksi virtual akun", min: 10000, value: $trxLimitVM.trxVirtualAccount, max: $trxLimitVM.maxTrxVirtualAccount)
                            
                            TrasactionLimitRow(lable: "Limit transaksi SKN", min: 10000, value: $trxLimitVM.trxSknTransfer, max: $trxLimitVM.maxTrxSknTransfer)
                            
                            TrasactionLimitRow(lable: "Limit transaksi RTGS", min: 10000, value: $trxLimitVM.trxRtgsTransfer, max: $trxLimitVM.maxTrxRtgsTransfer)
                            
                            TrasactionLimitRow(lable: "Limit transaksi IBFT", min: 10000, value: $trxLimitVM.trxOnlineTransfer, max: $trxLimitVM.maxTrxOnlineTransfer)
                            
                            TrasactionLimitRow(lable: "Limit pembayaran tagihan", min: 10000, value: $trxLimitVM.trxBillPayment, max: $trxLimitVM.maxTrxBillPayment)
                            
                            TrasactionLimitRow(lable: "Limit pembelian", min: 10000, value: $trxLimitVM.trxPurchase, max: $trxLimitVM.maxTrxPurchase)
                            
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
}

struct TransactionLimitView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionLimitView()
        }
    }
}
