//
//  DepositAccountView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/04/21.
//

import SwiftUI

struct DepositAccountView: View {
    
    @State var listSourceNumber: [String] = []
    @State var listAccountNumber: [String] = []
    @State var listPlantCode: [String] = []
    @State var listPlantCodeParsing: [String] = []
    @State var listBalance: [String] = []
    @State var listTypeAccount: [String] = []
    @State var listCardNo: [String] = []
    @State var listCardNoParsing: [String] = []
    
    @StateObject var productsSavingAccountVM = ProductsSavingAccountViewModel()
    @StateObject var savingAccountVM = SavingAccountViewModel()
    
    @ObservedObject var profileVM = ProfileViewModel()
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var depositBalance: String = ""
    
    @State var currency = "0"
    var minimumSaldo = "0"
    var biayaAdministrasi = "0"
    @State var minimumSetoranAwal = "0"
    
    @State var accountDeposit: String = "Select Account Deposit"
    @State var cardNo: String = ""
    @State var selectSourceNumber: String = ""
    
    @State var minSetoranDbl: Double = 0
    @State var depositDbl: Double = 0
    
    @State var routingConfirmation: Bool = false
    
    @State var isLoading: Bool = false
    
    @State var transferData = TransferOnUsModel()
    
    var nextBtnDisabled: Bool {
        accountDeposit == "Select Account Deposit" || depositBalance == "" || depositBalance == "0" || depositDbl < minSetoranDbl
    }
    
    var body: some View {
        LoadingView(isShowing: self.$isLoading) {
            ZStack {
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 20) {
                        
                        VStack {
                            
                            HStack {
                                Text("Account")
                                Spacer()
                            }
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            
                            HStack {
                                Menu {
                                    ForEach(0..<self.listAccountNumber.count) { index in
                                        
                                        Button(action: {
                                            self.accountDeposit = self.listAccountNumber[index]
                                            
//                                            self.getProducDetails(planCode: self.listPlantCodeParsing[index])
                                            
                                            if (self.listPlantCodeParsing[index] == "20") {
                                                self.minSetoranDbl = 0
                                                self.minimumSetoranAwal = "0"
                                            } else if (self.listPlantCodeParsing[index] == "22") {
                                                self.minSetoranDbl = 10000
                                                self.minimumSetoranAwal = "10000"
                                            } else {
                                                self.minSetoranDbl = 100000
                                                self.minimumSetoranAwal = "100000"
                                            }
                                            
                                        }) {
                                            Text(self.listAccountNumber[index])
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                    }
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(accountDeposit)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .fontWeight(.bold)
                                    }
                                    .padding()
                                    
                                    Spacer()
                                    
                                    Image("ic_expand").padding()
                                }
                            }
                            .background(Color(hex: "#F6F8FB"))
                            .cornerRadius(10)
                            .padding(.horizontal, 15)
                            .padding(.bottom, 10)
                            
                        }
                        .padding(25)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                        
                        VStack {
                            
                            HStack {
                                Text("Deposit Amount (Rp)".localized(language))
                                Spacer()
                            }
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            
                            VStack {
                                
                                HStack(alignment: .top, spacing: 0) {
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 24))
                                    
                                    TextField("0", text: $depositBalance)
                                        .font(.custom("Montserrat-Bold", size: 34))
                                        .onReceive(depositBalance.publisher.collect()) {
                                            let amountString = String($0.prefix(13))
                                            let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                            self.depositBalance = cleanAmount.thousandSeparator()
                                            
                                            self.depositDbl = Double(cleanAmount) ?? 0
                                            
//                                            if (self.depositDbl > Double(self.currency)!) {
//                                                self.depositBalance = self.currency.thousandSeparator()
//                                            }
                                        }
                                        .keyboardType(.numberPad)
                                    Spacer()
                                }
                                .foregroundColor(Color("DarkStaleBlue"))
                                
                                Divider()
                            }
                        }
                        .padding(25) // padding content
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        
                        VStack {
                            
                            HStack {
                                Text("Total Active Balance".localized(language))
                                    .font(.custom("Montserrat-Bold", size: 12))
                                
                                Spacer()
                                
                                HStack(alignment: .top, spacing: 0) {
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 10))
                                    Text(currency.thousandSeparator() + ",00")
                                        .font(.custom("Montserrat-Bold", size: 14))
                                }
                                .foregroundColor(Color("StaleBlue"))
                            }
                            
                            SavingAccountDetailRow1(label: "Minimum Initial Deposit".localized(language), value: minimumSetoranAwal)
                            
                        }
                        .padding(.horizontal, 25) // padding content
                        .padding(.vertical, 15) // padding content
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10)
                        .padding(.horizontal, 25)
                        
                        SavingAccountDetailRow(label: "Minimum Deposit Next".localized(language), value: "100000")
                        
                        SavingAccountDetailRow(label: "Minimum Balance".localized(language), value: "100000")
                        
                        SavingAccountDetailRow(label: "Biaya Administratif / Bulan".localized(language), value: "0")
                    
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 85)
                    
                }
                
                VStack {
                    Spacer()
                    VStack {
                        
                        NavigationLink(
                            destination: ConfirmationOfDepositAccountView().environmentObject(transferData),
                            isActive: self.$routingConfirmation,
                            label: {}
                        )
                        .isDetailLink(false)
                        
                        Button(
                            action: {
                                self.transferData.notes = "Deposit"
                                self.transferData.amount = self.depositBalance
                                self.transferData.destinationNumber = self.accountDeposit
                                
                                self.routingConfirmation = true
                            },
                            label: {
                                Text("Deposit Now")
                                    .padding()
                                    .font(.custom("Montserrat-Bold", size: 14))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    .background(nextBtnDisabled ? Color(.lightGray) : Color("StaleBlue"))
                                    .cornerRadius(15)
                            }
                        )
                        .padding(.horizontal, 25)
                        .frame(maxWidth: .infinity, maxHeight: 65)
                        .background(Color.white)
                        .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10, x: 2, y: 0)
                    }
                }
            }
        }
        .navigationBarTitle("Account Deposit", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            self.isLoading = true
//            getProfile()
            
            self.savingAccountVM.getAccounts { (success) in
                self.savingAccountVM.accounts.forEach { e in
                    print(e.accountNumber)
                    print(e.planCode)
                    self.listSourceNumber.append(e.accountNumber)
                    self.listPlantCode.append(e.planCode)
                    self.listTypeAccount.append(e.accountType ?? "")
                    self.listCardNo.append(e.cardNumber)
                }
                
                self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { (success) in
                    self.isLoading = false
                    
                    for i in 0..<self.savingAccountVM.balanceAccount.count {
                        
//                        if (self.listTypeAccount[i] == "S") {
//                            self.currency = self.savingAccountVM.balanceAccount[i].balance?.thousandSeparator() ?? "0"
//                        }
                        
                        self.currency = self.savingAccountVM.balanceAccount[0].balance?.thousandSeparator() ?? "0"
                        self.cardNo = self.savingAccountVM.balanceAccount[0].cardNo ?? ""
                        self.selectSourceNumber = self.listSourceNumber[0]
                        
                        self.transferData.cardNo = self.savingAccountVM.balanceAccount[0].cardNo ?? ""
                        self.transferData.sourceNumber = self.self.listSourceNumber[0]
                        
                        if (self.savingAccountVM.balanceAccount[i].creditDebit == "") {
                            print("DATA CREDIT DEBIT")
                            print(self.listSourceNumber[i])
                            print(self.listPlantCode[i])
                            print(self.listCardNo[i])
                            self.listPlantCodeParsing.append(self.listPlantCode[i])
                            self.listAccountNumber.append(self.listSourceNumber[i])
                            self.listCardNoParsing.append(self.listCardNo[i])
                        }
                    }
                }
            }
        }
    }
    
    func SavingAccountDetailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Montserrat-Bold", size: 12))
            
            Spacer()
            
            HStack(alignment: .top, spacing: 0) {
                Text("Rp.")
                    .font(.custom("Montserrat-Bold", size: 10))
                Text(value.thousandSeparator())
                    .font(.custom("Montserrat-Bold", size: 12))
            }
            .foregroundColor(Color("StaleBlue"))
        }
        .padding(.horizontal, 25) // padding content
        .padding(.vertical, 15) // padding content
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10)
        .padding(.horizontal, 25)
    }
    
    func SavingAccountDetailRow1(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Montserrat-Bold", size: 12))
            
            Spacer()
            
            HStack(alignment: .top, spacing: 0) {
                Text("Rp. ")
                    .font(.custom("Montserrat-Bold", size: 10))
                Text(value.thousandSeparator())
                    .font(.custom("Montserrat-Bold", size: 12))
            }
            .foregroundColor(Color("StaleBlue"))
        }
    }
    
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                
//                self.currency = self.profileVM.balance.thousandSeparator()
            }
        }
    }
    
    func getProducDetails(planCode: String) {
        self.productsSavingAccountVM.getProductsDetails(planCode: planCode) { result in
            
            print("result -> \(String(describing: result))")
            print("minimumSetoranAwal \(productsSavingAccountVM.minimumSetoranAwal ?? "0")")
        }
    }
}

struct DepositAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DepositAccountView()
    }
}
