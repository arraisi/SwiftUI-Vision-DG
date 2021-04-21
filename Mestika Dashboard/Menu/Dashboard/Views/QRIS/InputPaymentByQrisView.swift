//
//  InputPaymentByQrisView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/03/21.
//

import SwiftUI

struct InputPaymentByQrisView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var nominalTrx: String = ""
    @State var nominalTips: String = ""
    
    @State private var isShowingScanner = true
    
    @State private var qrisActive = false
    
    @StateObject var savingAccountVM = SavingAccountViewModel()
    @State var listSourceNumber: [String] = []
    @State var selectedSourceNumber: String = "Select Source Number"
    
    @State var disableAmount: Bool = true
    @State var disableFee: Bool = true
    
    // Environtment Object
    @EnvironmentObject var qrisData: QrisModel
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 15) {
                
                HStack {
                    Image("ic_saving_account")
                        .resizable()
                        .frame(width: 69, height: 69)
                }
                
                VStack(alignment: .center) {
                    Text("\(self.qrisData.merchantName)")
                        .font(.custom("Montserrat-Bold", size: 14))
                        .foregroundColor(Color("DarkStaleBlue"))
                    Text("\(self.qrisData.merchantCity)")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(Color("DarkStaleBlue"))
                    Text("TERMA00001")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(Color("DarkStaleBlue"))
                }
                .padding()
                
                VStack(spacing: 5) {
                    HStack {
                        
                        Text("Source Number".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        HStack {
                            Menu {
                                ForEach(self.listSourceNumber, id: \.self) { data in
                                    Button(action: {
                                        self.selectedSourceNumber = data
                                    }) {
                                        Text(data)
                                            .font(.custom("Montserrat-SemiBold", size: 10))
                                    }
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(selectedSourceNumber)
                                            .font(.custom("Montserrat-SemiBold", size: 10))
                                            .foregroundColor(Color.black.opacity(0.6))
                                            .fontWeight(selectedSourceNumber == "Select Source Number".localized(LocalizationService.shared.language) ? .bold : .none)
                                    }
                                    
                                    Spacer()
                                    
                                    Image("ic_expand").padding()
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    HStack {
                        Text("Nominal Transaksi".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        HStack {
                            TextField("0", text: self.$nominalTrx)
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                                .keyboardType(.numberPad)
                                .disabled(disableAmount)
//                                .onReceive(nominalTrx.publisher.collect()) {
//                                    let amountString = String($0.prefix(13))
//                                    let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
//
//                                    self.nominalTrx = cleanAmount.thousandSeparator()
//                                    self.qrisData.transactionAmount = cleanAmount
//                                }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.07))
                        .cornerRadius(10)
                    }
                    
                    HStack {
                        Text("Tips".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        HStack {
                            TextField("0", text: self.$nominalTips)
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                                .keyboardType(.numberPad)
                                .disabled(disableFee)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                }
                
                HStack {
//                    Text("Persentase tips adalah 5.0% dari nominal transaksi")
                    Spacer()
                }
                .font(.custom("Montserrat-Regular", size: 10))
                .foregroundColor(Color.gray)
                
                NavigationLink(
                    destination: ConfirmationPinQrisView().environmentObject(qrisData),
                    isActive: self.$qrisActive) {
                    EmptyView()
                }
                
                Button(action: {
                    self.qrisData.fromAccountName = "Test"
                    self.qrisData.fromAccount = self.selectedSourceNumber
                    self.qrisData.transactionAmount = self.nominalTrx
                    self.qrisData.transactionFee = self.nominalTips
                    
                    self.qrisActive = true
                }) {
                    Text("Next".localized(language))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .disabled(disableForm)
                .background(disableForm ? .gray : Color(hex: "#2334D0"))
                .cornerRadius(12)
            }
            .padding(25) // padding content
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color("DarkStaleBlue").opacity(0.2), radius: 10)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            
            Spacer()
        }
//        .onReceive(self.appState.$moveToDashboard) { value in
//            if value {
//                //                getCoreDataNewDevice()
//                print("Move to moveToDashboard: \(value)")
//                //                activateWelcomeView()
//                self.qrisActive = false
//                self.appState.moveToDashboard = false
//            }
//        }
        .navigationBarTitle("Pembayaran QRIS", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .padding(.vertical, 30)
//        .sheet(isPresented: $isShowingScanner) {
//            CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
//        }
        .onAppear {
            
            
            if (self.qrisData.transactionAmount == "-1") {
                self.disableAmount = false
                self.nominalTrx = ""
                self.nominalTips = self.qrisData.transactionFee
            } else if (self.qrisData.transactionFee == "-1") {
                self.disableFee = false
                self.nominalTrx = self.qrisData.transactionAmount
                self.nominalTips = ""
            } else {
                self.disableAmount = true
                self.nominalTrx = self.qrisData.transactionAmount
                self.nominalTips = self.qrisData.transactionFee
            }
            
            self.savingAccountVM.getAccounts { (success) in
                self.savingAccountVM.accounts.forEach { e in
                    print(e.accountNumber)
                    self.listSourceNumber.append(e.accountNumber)
                    
                }
            }
        }
        
    }
    
    var disableForm: Bool {
        if self.selectedSourceNumber == "Select Source Number" || (!disableFee && nominalTips == "") {
            return true
        }
        
        return false
    }
    
//    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
//        self.isShowingScanner = false
//        // more code to come
//        print("\nresult : \(result)")
//    }
}

struct InputPaymentByQrisView_Previews: PreviewProvider {
    static var previews: some View {
        InputPaymentByQrisView()
    }
}
