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
    @State var listBalance: [String] = []
    @State var selectedSourceNumber: String = "Select Source Number"
    @State var selectedBalance: String = "0"
    
    @State var dblAmount: Double = 0
    @State var dblBalance: Double = 0
    
    @State var disableAmount: Bool = true
    @State var disableFee: Bool = true
    
    // Environtment Object
    @EnvironmentObject var qrisData: QrisModel
    
    @State var isLoading: Bool = false
    
    var body: some View {
        
        LoadingView(isShowing: self.$isLoading, content: {
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
                    }
                    .padding()
                    
                    VStack {
                        Text("Jumlah Besaran (Rp)".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 13))
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        // Amount QRIS
                        HStack(alignment: .top) {
                            Text("Rp.")
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                            
                            TextField("0", text: self.$nominalTrx, onEditingChanged: {_ in })
    //                            .onReceive(amount.publisher.collect()) {
    //                                let amountString = String($0.prefix(13))
    //                                let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
    //                                self.amount = cleanAmount.thousandSeparator()
    //                                self.transferData.amount = cleanAmount
    //                            }
                                .foregroundColor(Color(hex: "#232175"))
                                .font(.system(size: 30, weight: .bold, design: .default))
                                .keyboardType(.numberPad)
                                .disabled(disableAmount)
                            
                            Spacer()
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 1)
                        
                        // Tips QRIS
                        HStack(alignment: .top) {
                            Text("Tips Rp.")
                                .foregroundColor(Color(hex: "#232175"))
                                .font(.system(size: 15, weight: .light, design: .default))
                            
                            TextField("0", text: self.$nominalTips, onEditingChanged: {_ in })
                                .foregroundColor(Color(hex: "#232175"))
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .keyboardType(.numberPad)
                                .disabled(disableFee)
                            
                            Spacer()
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 1)
                        
                        Divider()
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                        
                        Text("Source Number".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 13))
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Menu {
                                ForEach(0..<self.listSourceNumber.count, id: \.self) { index in
                                    Button(action: {
                                        self.selectedSourceNumber = self.listSourceNumber[index]
                                        
                                        self.selectedBalance = self.listBalance[index]
                                        self.dblBalance = Double(self.listBalance[index]) ?? 0
    //                                    self.selectedBalance = "0"
                                    }) {
                                        Text(self.listSourceNumber[index])
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
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkStaleBlue").opacity(0.1))
                        .cornerRadius(10)
                        
                        Text("Saldo Aktif : Rp \(selectedBalance.thousandSeparator())")
                            .font(.custom("Montserrat-SemiBold", size: 11))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
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
        })
        .navigationBarTitle("Pembayaran QRIS", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .padding(.vertical, 30)
        .onAppear {
            self.isLoading = true
            
            if (self.qrisData.transactionAmount == "-1") {
                self.disableAmount = false
                self.nominalTrx = ""
                self.dblAmount = 0
                self.nominalTips = self.qrisData.transactionFee
            } else {
                self.disableAmount = true
                self.nominalTrx = self.qrisData.transactionAmount
                self.nominalTips = self.qrisData.transactionFee
                self.dblAmount = Double(self.nominalTrx) ?? 0
            }
            
            if (self.qrisData.transactionFee == "-1") {
                self.disableFee = false
                self.nominalTrx = self.qrisData.transactionAmount
                self.nominalTips = ""
            } else {
                self.disableFee = true
                self.nominalTrx = self.qrisData.transactionAmount
                self.nominalTips = self.qrisData.transactionFee
            }
            
            self.savingAccountVM.getAccounts { (success) in
                self.savingAccountVM.accounts.forEach { e in
                    
                    if (e.accountType == "S") {
                        print(e.accountNumber)
                        self.listSourceNumber.append(e.accountNumber)
                    }
                }
                
                self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { success in
                    
                    if success {
                        self.isLoading = false
                        
                        self.savingAccountVM.balanceAccount.forEach { b in
                            if b.creditDebit == "D" {
                                self.listBalance.append("0")
                            } else {
                                self.listBalance.append(b.balance ?? "0")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    var disableForm: Bool {
        if self.selectedSourceNumber == "Select Source Number" || (!disableFee && nominalTips == "") || (!disableAmount && nominalTrx == "") || (self.dblAmount > self.dblBalance) {
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
        InputPaymentByQrisView().environmentObject(QrisModel())
    }
}
