//
//  TransferOnUsScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/10/20.
//

import SwiftUI
import BottomSheet

struct TransferOnUsScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject var savingAccountVM = SavingAccountViewModel()
    @State var listSourceNumber: [String] = []
    
    @State var selectedSourceNumber: String = ""
    @State var selectedBalance: String = ""
    
    /* Function GET USER Status */
    @ObservedObject var profileVM = ProfileViewModel()
    @StateObject var transferVM = TransferViewModel()
    
    @Binding var dest: String
    
    @State var transferData = TransferOnUsModel()
    @State var transactionFrequency = "Select Transaction Frequency".localized(LocalizationService.shared.language)
    @State var transactionVoucher = "Select Voucher".localized(LocalizationService.shared.language)
    @State var destinationName = ""
    @State var destinationNumber = ""
    @State var amount = ""
    @State var selectedAccount = BankAccount(id: 0, namaRekening: "Select Account".localized(LocalizationService.shared.language), productName: "", sourceNumber: "", noRekening: "", saldo: "0.0")
    
    /*
     Dialog's Variables
     */
    @State private var showDialogConfirmation = false
    @State private var showDialogSelectAccount = false
    @State private var showDialogMaxReached = false
    @State private var showDialogMinReached = false
    @State private var showDialogMinTransaction: Bool = false
    
    /*
     View Variables
     */
    @State private var isShowName: Bool = false
    @State private var disabledButton = true
    @State private var routeConfirmation: Bool = false
    
    @State private var maxLimit: Int = 30000000
    @State private var limitTrx: String = "30000000"
    @State private var minLimit: Int = 10000
    
    @State var balance: String = ""
    @State var productName: String = "-"
    
    @State var listBankAccount: [BankAccount] = []
    
    var _listVoucher = ["Voucher Not Available".localized(LocalizationService.shared.language)]
    var _listFrequency = ["Once".localized(LocalizationService.shared.language), "Many times".localized(LocalizationService.shared.language)]
    
    @State private var selectedCalendar: String = "Now"
    
    // Variable Get Name
    @State private var isGetName: Bool = true
    
    // Variable Date
    let now = Date()
    @State var date = Date()
    private var selectedDate: Binding<Date> {
        Binding<Date>(get: { self.date}, set : {
            self.date = $0
            self.setDateString()
        })
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let max = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
        return min...max
    }
    
    func setDateString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: self.now))
        print(formatter.string(from: self.date))
        
        if (formatter.string(from: self.now) == formatter.string(from: self.date)) {
            self.selectedCalendar = "Now"
        } else {
            self.selectedCalendar = "Next"
        }
        
    }
    
    @State private var notesCtrl: String = ""
    
    var body: some View {
        ZStack(alignment: .top, content: {
            VStack {
                Color(hex: "#F6F8FB")
                    .edgesIgnoringSafeArea(.all)
            }
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        noRekeningCard
                        nominalCard
                        
                        calendarCard
                        //                        frekuensiTransaksiCard
                        chooseVoucherCard
                        notesCard
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: TransferOnUsConfirmationScreen().environmentObject(transferData),
                            isActive: self.$routeConfirmation) {
                            EmptyView()
                        }
                        .isDetailLink(false)
                        
                        VStack {
                            Button(action: {
                                self.transferData.destinationName = self.destinationName
                                
                                if (transactionVoucher == "Select Voucher".localized(language) || transactionVoucher == "Voucher Not Available".localized(language)) {
                                    self.transferData.transactionVoucher = ""
                                }
                                
                                UIApplication.shared.endEditing()
                                
                                let amount = Int(self.transferData.amount) ?? 0
                                let myCredit = Int(self.selectedAccount.saldo.replacingOccurrences(of: ".", with: "")) ?? 0
                                
                                if (amount < self.minLimit) {
                                    self.showDialogMinTransaction = true
                                } else if (amount <= self.maxLimit && amount <= myCredit) {
                                    self.transferData.notes = self.notesCtrl
                                    self.transferData.transactionFrequency = transactionFrequency
                                    self.transferData.transactionVoucher = ""
                                    self.transferData.transactionDate = dateFormatter.string(from: self.date)
                                    self.routeConfirmation = true
                                } else if (amount > myCredit ) {
                                    self.showDialogMinReached = true
                                } else {
                                    self.showDialogMaxReached = true
                                }
                                
                            }, label: {
                                Text("CONFIRM TRANSFER".localized(language))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.system(size: 13))
                                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            })
                            .disabled(disabledButton)
                            .background(Color(hex: disabledButton ? "#CBD1D9" : "#232175"))
                            .cornerRadius(12)
                            .padding(.leading, 20)
                            .padding(.trailing, 10)
                            .padding(.bottom)
                        }
                    }
                })
            }
            
            if (self.showDialogSelectAccount || self.showDialogConfirmation || self.showDialogMinReached || self.showDialogMaxReached || self.showDialogMinTransaction) {
                ModalOverlay(tapAction: { withAnimation {
                    self.showDialogMinTransaction = false
                    self.showDialogSelectAccount = false
                    self.showDialogConfirmation = false
                    self.showDialogMaxReached = false
                    self.showDialogMinReached = false
                }})
                .edgesIgnoringSafeArea(.all)
            }
        })
        .navigationBarTitle("Inter-peer Transfer".localized(language), displayMode: .inline)
        .onAppear() {
            self.routeConfirmation = false
            self.transferData = TransferOnUsModel()
            if (dest != "") {
                self.destinationNumber = self.dest
                self.transferData.destinationNumber = self.dest
                inquiryTransfer()
            }
            self.getProfile()
            self.getLimit(code: "70")
            
            self.savingAccountVM.getAccounts { (success) in
                self.savingAccountVM.accounts.forEach { e in
                    
                    if (e.planAllowDebitInHouse == "Y" && e.categoryProduct != "S") {
                        print(e.accountNumber)
                        self.listSourceNumber.append(e.accountNumber)
                    }
                }
                
                self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { (success) in
                    
                }
            }
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .bottomSheet(isPresented: $showDialogConfirmation, height: 300) {
            bottomSheetCard
        }
        .popup(isPresented: $showDialogSelectAccount, type: .floater(), position: .bottom, animation: Animation.spring(),closeOnTap: false, closeOnTapOutside: false) {
            modalSelectBankAccount()
        }
        .popup(isPresented: $showDialogMaxReached, type: .floater(), position: .bottom, animation: Animation.spring(),closeOnTap: false, closeOnTapOutside: false) {
            modalMaxReached()
        }
        .popup(isPresented: $showDialogMinReached, type: .floater(), position: .bottom, animation: Animation.spring(),closeOnTap: false, closeOnTapOutside: false) {
            modalMinReached()
        }
        .popup(isPresented: $showDialogMinTransaction, type: .floater(), position: .bottom, animation: Animation.spring(),closeOnTap: false, closeOnTapOutside: false) {
            modalMinTransaction()
        }
    }
    
    var noRekeningCard: some View {
        VStack {
            HStack {
                Text("Destination Account No".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            VStack {
                TextField("Account".localized(language), text: $destinationNumber, onEditingChanged: {_ in
                    inquiryTransfer()
                }, onCommit: {
                    
                })
                .onReceive(destinationNumber.publisher.collect()) {
                    self.destinationNumber = String($0.prefix(11))
                    self.transferData.destinationNumber = destinationNumber
                    if self.destinationNumber.count == 11 {
                        validateForm()
                    }
                }
                .keyboardType(.numberPad)
                .frame(height: 10)
                .font(.subheadline)
                .padding()
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                if isShowName {
                    HStack {
                        Text(self.transferVM.destinationName)
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 5)
                } else {
                    EmptyView()
                }
            }
            .padding(.bottom, 25)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding()
    }
    
    var nominalCard: some View {
        VStack {
            HStack {
                Text("Amount (Rp)".localized(language))
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            HStack(alignment: .top) {
                Text("Rp.")
                    .foregroundColor(Color(hex: "#232175"))
                    .fontWeight(.bold)
                
                TextField("0", text: self.$amount, onEditingChanged: {_ in })
                    .onReceive(amount.publisher.collect()) {
                        let amountString = String($0.prefix(13))
                        let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                        self.amount = cleanAmount.thousandSeparator()
                        self.transferData.amount = cleanAmount
                        validateForm()
                    }
                    .foregroundColor(Color(hex: "#232175"))
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .keyboardType(.numberPad)
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.bottom, 1)
            .padding(.horizontal, 25)
            
            HStack {
                Text("Transaction Limit".localized(language))
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                
                Spacer()
                
                HStack(alignment: .top) {
                    Text("Rp.")
                        .foregroundColor(.red)
                        .font(.caption2)
                        .fontWeight(.bold)
                    Text("\(limitTrx.thousandSeparator())")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 5)
            .padding(.horizontal, 25)
            
            Divider()
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
            
            //            ListBankAccountView()
            bankAccountCard
                .padding(.bottom, 25)
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding()
    }
    
    var bankAccountCard: some View {
        ZStack {
            HStack {
                
                Menu {
                    ForEach(0..<self.listSourceNumber.count) { index in
                        Button(action: {
                            self.selectedSourceNumber = self.listSourceNumber[index]
                            self.selectedAccount.noRekening = self.selectedSourceNumber
                            self.transferData.sourceNumber = self.selectedSourceNumber
                            
                            if self.savingAccountVM.balanceAccount.count < 1 {
                                self.selectedBalance = "0"
                                self.selectedAccount.saldo = "0"
                            } else {
                                self.selectedBalance = self.savingAccountVM.balanceAccount[index].balance ?? "0"
                                self.transferData.cardNo = self.savingAccountVM.balanceAccount[index].cardNo ?? "0"
                                print(self.transferData.cardNo)
                                print(self.selectedAccount.noRekening)
                                self.selectedAccount.saldo = self.selectedBalance
                            }
                        }) {
                            Text(self.listSourceNumber[index])
                                .bold()
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(.black)
                        }
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(selectedSourceNumber)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Active Balance:".localized(language))
                                .font(.caption)
                                .fontWeight(.ultraLight)
                            
                            if (self.savingAccountVM.balanceAccount.count < 1) {
                                Text("-")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#232175"))
                                    .fontWeight(.semibold)
                            } else {
                                Text("\(self.selectedBalance.thousandSeparator())")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#232175"))
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Image("ic_expand").padding()
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var calendarCard: some View {
        VStack {
            HStack {
                DatePicker(selection: selectedDate, in: dateClosedRange, displayedComponents: .date) {
                    Text(self.selectedCalendar)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.semibold)
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var frekuensiTransaksiCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transactionFrequency)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.light)
                }
                .padding()
                
                Spacer()
                Menu {
                    ForEach(self._listFrequency, id: \.self) { data in
                        Button(action: {
                            self.transactionFrequency = data
                            self.transferData.transactionFrequency = data
                            validateForm()
                        }) {
                            Text(data)
                                .font(.custom("Montserrat-Regular", size: 12))
                        }
                    }
                } label: {
                    Image("ic_expand").padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var chooseVoucherCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transactionVoucher)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.light)
                }
                .padding()
                
                Spacer()
                Menu {
                    ForEach(self._listVoucher, id: \.self) { data in
                        Button(action: {
                            self.transactionVoucher = data
                            self.transferData.transactionVoucher = data
                            validateForm()
                        }) {
                            Text(data)
                                .font(.custom("Montserrat-Regular", size: 12))
                        }
                    }
                } label: {
                    Image("ic_expand").padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var notesCard: some View {
        VStack {
            HStack {
                Text("Notes".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            VStack {
                MultilineTextField("Write a transaction description here".localized(language), text: self.$notesCtrl, onCommit: {
                })
                .onReceive(notesCtrl.publisher.collect()) {
                    self.notesCtrl = String($0.prefix(40))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 5)
            .padding(.bottom, 25)
            
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding()
    }
    
    var bottomSheetCard: some View {
        VStack {
            HStack {
                Text("Confirmed Account Number".localized(language))
                    .foregroundColor(.green)
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 30, height: 30)
                    
                    Text("A")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                }
                
                VStack(alignment: .leading) {
                    Text("\(self.destinationName)")
                        .font(.subheadline)
                    
                    HStack {
                        Text("Mestika :")
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        Text(self.transferData.destinationNumber)
                            .font(.caption)
                            .fontWeight(.ultraLight)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            
            VStack {
                NavigationLink(destination: TransferOnUsConfirmationScreen().environmentObject(transferData), label: {
                    Text("CONFIRM TRANSFER".localized(language))
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.leading, 20)
                .padding(.trailing, 10)
            }
            .padding(.bottom, 20)
        }
    }
    
    func modalMinTransaction() -> some View {
        VStack(alignment: .leading) {
            Image("ic_limit_min")
                .resizable()
                .frame(width: 127, height: 81)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("There are transactions less than the minimum transaction.".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text("Minimum transaction of Rp.".localized(language) + "\(self.minLimit),- . " + "Please change the transaction nominal.".localized(language))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMinTransaction = false
                },
                label: {
                    Text("CHANGE THE NOMINAL".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 10)
            
            Button(
                action: {
                    self.showDialogMinTransaction = false
                },
                label: {
                    Text("CANCEL TRANSACTION".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    func modalMinReached() -> some View {
        VStack(alignment: .leading) {
            Image("ic_limit_min")
                .resizable()
                .frame(width: 127, height: 81)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Minimum Balance Exceeded".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text("Your minimum account balance is Rp.".localized(language) + " \(selectedAccount.saldo.thousandSeparator()),- " + "exceeded. Please change the transaction amount or add a balance to your account.".localized(language))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMinReached = false
                },
                label: {
                    Text("CHANGE THE NOMINAL".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 10)
            
            Button(
                action: {
                    self.showDialogMinReached = false
                },
                label: {
                    Text("CANCEL TRANSACTION".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    func modalMaxReached() -> some View {
        VStack(alignment: .leading) {
            Image("ic_limit_max")
                .resizable()
                .frame(width: 74, height: 81)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Transaction limit exceeded".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text("Transaction limit of Rp.".localized(language) + "\(limitTrx.thousandSeparator()),- " + "Exceeded. Please reduce the nominal amount of the transaction or cancel the transaction.".localized(language))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMaxReached = false
                },
                label: {
                    Text("CHANGE THE NOMINAL".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMaxReached = false
                },
                label: {
                    Text("CANCEL TRANSACTION".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    func modalSelectBankAccount() -> some View {
        VStack {
            HStack {
                Text("Select Account".localized(language))
                    .font(.title3)
                    .fontWeight(.ultraLight)
                
                Spacer()
            }
            
            ForEach(listBankAccount) { data in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(data.productName)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                            
                            HStack {
                                Text("Active Balance:".localized(language))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                                Text("Rp. \(data.saldo.thousandSeparator())")
                                    .font(. caption)
                                    .foregroundColor(Color(hex: "#232175"))
                                    .fontWeight(.semibold)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                }
                //                .background(Color(hex: "#FF00FF"))
                .onTapGesture {
                    self.selectedAccount = data
//                    self.transferData.cardNo = data.noRekening
//                    self.transferData.sourceNumber = data.sourceNumber
                    self.transferData.sourceAccountName = data.productName
                    print(data.noRekening)
                    self.showDialogSelectAccount = false
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func validateForm() {
        if (self.destinationNumber.count == 11 && self.selectedSourceNumber != "" && self.amount != "" && self.transferVM.destinationName != "Akun Tidak Ditemukan") {
            disabledButton = false
        } else {
            disabledButton = true
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "in_ID")
        return formatter
    }
    
    // MARK: GET DESTINATION NAME
    func inquiryTransfer() {
        if transferData.destinationNumber.count == 11  {
            self.isShowName = true
            
            self.transferVM.transferOnUsInquiry(transferData: transferData) { success in
                
                DispatchQueue.main.async {
                    if success {
                        print("\nSUCCESS DESTINATION NAME : \(self.transferVM.destinationName)\n")
                        self.destinationName = self.transferVM.destinationName
                        self.transferData.ref = self.transferVM.reffNumber
                    }
                    
                    if !success {
                        print("NOT SUCCESS")
                        self.transferVM.destinationName = "Akun Tidak Ditemukan"
                    }
                }
            }
        }
    }
    
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                print(self.selectedAccount.sourceNumber)
                self.transferData.username = self.profileVM.name
//                self.transferData.cardNo = self.profileVM.cardNo
//                self.transferData.sourceNumber = self.profileVM.accountNumber
                self.transferData.sourceAccountName = self.profileVM.nameOnCard
                
                self.listBankAccount.removeAll()
                
                self.listBankAccount.append(BankAccount(id: 1, namaRekening: self.profileVM.cardName, productName: self.profileVM.nameOnCard, sourceNumber: self.profileVM.accountNumber, noRekening: self.profileVM.cardNo, saldo: self.profileVM.balance.thousandSeparator()))
                
                self.selectedAccount = self.listBankAccount[0]
                
                
            }
        }
    }
    
    func getLimit(code: String) {
        self.transferVM.getLimitTransaction(classCode: "10") { success in
            if success {
                self.maxLimit = Int(self.transferVM.limitIbft) ?? 0
                self.limitTrx = self.transferVM.limitIbft
            }
        }
    }
}

struct TransferOnUsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferOnUsScreen(dest: .constant(""))
    }
}
