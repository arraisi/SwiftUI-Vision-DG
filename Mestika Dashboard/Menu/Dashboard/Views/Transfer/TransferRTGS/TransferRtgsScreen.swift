//
//  TransferRtgsScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/02/21.
//

import SwiftUI

struct TransferRtgsScreen: View {
    
    @StateObject var savingAccountVM = SavingAccountViewModel()
    @State var listSourceNumber: [String] = []
    
    @State var selectedSourceNumber: String = ""
    @State var selectedBalance: String = ""
    
    @State var isShowName: Bool = false
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    // Observable Object
    @State var transferData = TransferOffUsModel()
    
    // Variable Transfer Type
    var _listTransferType = ["RTGS", "SKN", "Online"]
    @State private var transferType: String = "Select Transaction Type".localized(LocalizationService.shared.language)
    
    // Variable List BANK
    @State private var bankSelector: String = "Choose Destination Bank".localized(LocalizationService.shared.language)
    
    @State private var destinationType: String = "Receiver Type".localized(LocalizationService.shared.language)
    
    @State private var citizenShipCtrl: String = "Citizenship".localized(LocalizationService.shared.language)
    
    // Variale Destination Type
    var _listDestinationType = ["Personal", "Company".localized(LocalizationService.shared.language), "Group".localized(LocalizationService.shared.language), "Foundation".localized(LocalizationService.shared.language)]
    
    // Variable Citizen Ship
    var _listCitizenShip = ["Resident", "Non Resident"]
    
    @Binding var dest: String
    @Binding var type: String
    @Binding var destBank: String
    @Binding var nameCst: String
    @Binding var desc: String
    
    // Variable NoRekening
    @State private var noRekeningCtrl: String = ""
    @State private var destinationNameCtrl: String = ""
    @State var selectedAccount = BankAccount(id: 0, namaRekening: "Select Account".localized(LocalizationService.shared.language), productName: "", sourceNumber: "", noRekening: "", saldo: "0.0")
    @State var listBankAccount: [BankAccount] = []
    
    // Variable Amount
    @State var amount = ""
    @State private var maxLimit: Int = 10000000
    @State private var limitTrx: String = "10000000"
    @State private var minLimit: Int = 0
    
    // Variable Transaction Frequecy
    var _listFrequency = ["Once".localized(LocalizationService.shared
                                                                .language), "Many times".localized(LocalizationService.shared.language)]
    @State var transactionFrequency = "Select Transaction Frequency".localized(LocalizationService.shared.language)
    
    // Variable Voucher
    var _listVoucher = ["Voucher Not Available".localized(LocalizationService.shared.language)]
    @State var transactionVoucher = "Select Voucher".localized(LocalizationService.shared.language)
    
    // Variable Notes
    @State private var notesCtrl: String = ""
    
    @State private var selectedCalendar: String = "Now".localized(LocalizationService.shared.language)
    
    // Variable Modal
    @State private var showDialogMinReached: Bool = false
    @State private var showDialogMaxReached: Bool = false
    @State private var showDialogMinTransaction: Bool = false
    @State private var showDialogConfirmation: Bool = false
    @State private var showDialogSelectAccount: Bool = false
    
    // Variable Disable
    @State private var disabledButton = true
    
    // Variable Route
    @State private var isRouteTransaction: Bool = false
    
    // Variable Date
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
            self.selectedCalendar = "Now".localized(LocalizationService.shared.language)
        } else {
            self.selectedCalendar = "Next".localized(LocalizationService.shared.language)
        }
        
    }
    
    let now = Date()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#F6F8FB")
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        chooseTransactionType
                        cardBankAndRekening
                        nominalCard
                        calendarCard
                        //                        frekuensiTransaksiCard
                        chooseVoucherCard
                        notesCard
                        
                        Spacer()
                        
                        Button(action: {
                            UIApplication.shared.endEditing()
                            let amount = Int(self.transferData.amount) ?? 0
                            let myCredit = Int(self.selectedAccount.saldo.replacingOccurrences(of: ".", with: "")) ?? 0
                            
                            if (transactionVoucher == "Select Voucher".localized(language) || transactionVoucher == "Voucher Not Available".localized(language)) {
                                self.transferData.transactionVoucher = ""
                            }
                            
                            if (amount < self.minLimit) {
                                self.showDialogMinTransaction = true
                            } else if (amount <= myCredit) {
                                
                                if (self.transferData.transactionType == "Online") {
//                                    self.showDialogConfirmation = true
                                    
                                    self.transferData.destinationNumber = self.noRekeningCtrl
                                    self.transferData.destinationName = self.destinationNameCtrl
                                    self.transferData.typeDestination = self.destinationType
                                    self.transferData.transactionType = self.transferType
//
                                    if (desc == "") {
                                        self.transferData.notes = self.notesCtrl
                                    }
                                    
                                    self.transferData.transactionDate = dateFormatter.string(from: self.date)
                                    print("OKE")
                                    self.isRouteTransaction = true
                                    
                                } else {
                                    self.transferData.destinationNumber = self.noRekeningCtrl
                                    self.transferData.destinationName = self.destinationNameCtrl
                                    self.transferData.citizenship = self.citizenShipCtrl
                                    self.transferData.typeDestination = self.destinationType
                                    self.transferData.transactionType = self.transferType
//
                                    if (desc == "") {
                                        self.transferData.notes = self.notesCtrl
                                    }
                                    
                                    self.transferData.transactionDate = dateFormatter.string(from: self.date)
                                    print("OKE")
                                    self.isRouteTransaction = true
                                }
                                
                            } else if (amount > myCredit ) {
                                self.showDialogMinReached = true
                            } else {
                                self.showDialogMaxReached = true
                            }
                            
                        }, label: {
                            Text("CONFIRM TRANSFER".localized(language))
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disableForm)
                        .background(disableForm ? Color.gray : Color(hex: "#232175"))
//                        .background(Color(hex: "#232175"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                })
            }
            
            if (self.showDialogMinReached || self.showDialogMaxReached || self.showDialogSelectAccount || self.showDialogMinTransaction) {
                ModalOverlay(tapAction: { withAnimation {
                    self.showDialogMaxReached = false
                    self.showDialogMinReached = false
                    self.showDialogSelectAccount = false
                    self.showDialogMinTransaction = false
                }})
                .edgesIgnoringSafeArea(.all)
            }
            
            NavigationLink(
                destination: TransferRtgsConfirmation().environmentObject(transferData),
                isActive: self.$isRouteTransaction,
                label: {
                    EmptyView()
                })
                .isDetailLink(false)
        }
        .navigationBarTitle("Transfer to Other Bank".localized(language), displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .bottomSheet(isPresented: $showDialogConfirmation, height: 300) {
            bottomSheetCard()
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
        .popup(isPresented: $showDialogSelectAccount, type: .floater(), position: .bottom, animation: Animation.spring(),closeOnTap: false, closeOnTapOutside: false) {
            modalSelectBankAccount()
        }
        .onAppear {
            self.isRouteTransaction = false
            self.transferData = TransferOffUsModel()
//            self.transferType = _listTransferType[0]
            if (dest != "") {
                print(desc)
                self.noRekeningCtrl = self.dest
                self.transferType = self.type
                self.bankSelector = self.destBank
                self.transferData.destinationName = self.nameCst
                self.destinationNameCtrl = self.nameCst
                self.transferData.notes = self.desc
            }
            self.transferData.transactionFrequency = _listFrequency[0]
            self.transferData.transactionVoucher = _listVoucher[0]
            self.transferData.transactionType = _listTransferType[0]
            getProfile()
            getListBank()
            self.getLimit(code: "70")
            
            self.savingAccountVM.getAccounts { (success) in
                self.savingAccountVM.accounts.forEach { e in
                    
                    if (e.planAllowDebitDomestic == "Y" && e.categoryProduct != "S") {
                        print(e.accountNumber)
                        self.listSourceNumber.append(e.accountNumber)
                    }
                    
                }
                
                self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { (success) in
                    
                }
            }
        }
    }
    
    var chooseTransactionType: some View {
        VStack {
            Menu {
                ForEach(self._listTransferType, id: \.self) { data in
                    Button(action: {
                        self.transferType = data
                        self.transferData.transactionType = data
                    }) {
                        Text(data)
                            .font(.custom("Montserrat-Regular", size: 12))
                    }
                }
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(transferType)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Image("ic_expand").padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding()
    }
    
    var cardBankAndRekening: some View {
        VStack {
            // Field Pilih Bank
            VStack {
                HStack {
                    Text("Choose Bank".localized(language))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 25)
                
                HStack {
                    Menu {
                        ForEach(0..<self.referenceVM._listBank.count, id: \.self) { index in
                            
                            Button(action: {
                                self.bankSelector = self.referenceVM._listBank[index].name
                                self.transferData.bankName = self.referenceVM._listBank[index].name
                                self.transferData.destinationBankCode = self.referenceVM._listBank[index].code
                            }) {
                                Text(self.referenceVM._listBank[index].name)
                                    .font(.custom("Montserrat-Regular", size: 12))
                            }
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(bankSelector)
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
            
            // Field No Rekening Tujuan
            VStack {
                HStack {
                    Text("Destination Account No".localized(language))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                HStack {
                    TextField("Account".localized(language), text: self.$noRekeningCtrl, onEditingChanged: { changed in
                        self.transferData.destinationNumber = self.noRekeningCtrl
                        inquiryTransfer()
                    })
                    .keyboardType(.numberPad)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .onReceive(noRekeningCtrl.publisher.collect()) {
                        if (transferType == "Online") {
                            self.noRekeningCtrl = String($0.prefix(11))
                        } else {
                            self.noRekeningCtrl = String($0.prefix(16))
                        }
                    }
                }
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
            }
            
            if transferType == "Online" {
                
                if isShowName {
                    HStack {
                        Text(self.limitVM.destinationName)
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                } else {
                    EmptyView()
                }
                
            } else {
                VStack {
                    HStack {
                        
                        TextField("Destination Name".localized(language), text: self.$destinationNameCtrl, onEditingChanged: { changed in
                            self.transferData.destinationName = self.destinationNameCtrl
                        })
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding()
                    }
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                }
                
                // Field Type Destination
                VStack {
                    HStack {
                        Text("Beneficiary Type".localized(language))
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
    //                .padding(.top, 25)
                    
                    HStack {
                        Menu {
                            ForEach(self._listDestinationType, id: \.self) { data in
                                Button(action: {
                                    self.destinationType = data
                                    self.transferData.typeDestination = data
            //                        validateForm()
                                }) {
                                    Text(data)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(destinationType)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .fontWeight(destinationType == "Receiver Type".localized(LocalizationService.shared.language) ? .bold : .light)
                                }
                                .padding()
                                
                                Spacer()
                                
                                Image("ic_expand").padding()
                            }
                        }
                    }
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                }
                
                // Filed Resident
                VStack {
                    HStack {
                        Text("Resident Status".localized(language))
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
    //                .padding(.top, 25)
                    
                    Menu {
                        ForEach(self._listCitizenShip, id: \.self) { data in
                            Button(action: {
                                self.citizenShipCtrl = data
                                self.transferData.citizenship = data
        //                        validateForm()
                            }) {
                                Text(data)
                                    .font(.custom("Montserrat-Regular", size: 12))
                            }
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(citizenShipCtrl)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fontWeight(citizenShipCtrl == "Citizenship".localized(LocalizationService.shared.language) ? .bold : .light)
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
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding(.bottom)
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
                    Text("\(self.selectedAccount.saldo.thousandSeparator())")
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
            
            bankAccountCard
                .padding(.bottom, 25)
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding(.bottom)
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
                        .foregroundColor(transactionFrequency == "Select Transaction Frequency".localized(language) ? .gray : .black)
                        .fontWeight(.light)
                }
                .padding()
                
                Spacer()
                Menu {
                    ForEach(self._listFrequency, id: \.self) { data in
                        Button(action: {
                            self.transactionFrequency = data
                            self.transferData.transactionFrequency = data
                        }) {
                            Text(data)
                                .bold()
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
                        .foregroundColor(transactionVoucher == "Select Voucher".localized(language) ? .gray : .black)
                        .fontWeight(.light)
                }
                .padding()
                
                Spacer()
                Menu {
                    ForEach(self._listVoucher, id: \.self) { data in
                        Button(action: {
                            self.transactionVoucher = data
                            self.transferData.transactionVoucher = data
                        }) {
                            Text(data)
                                .bold()
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
    
//    var bankAccountCard: some View {
//        ZStack {
//
//            Button(
//                action: {
//                    UIApplication.shared.endEditing()
//                    self.showDialogSelectAccount = true
//                },
//                label: {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(self.selectedAccount.namaRekening)
//                                .font(.subheadline)
//                                .foregroundColor(Color(hex: "#232175"))
//                                .fontWeight(.bold)
//
//                            HStack {
//                                Text("Active Balance:".localized(language))
//                                    .font(.caption)
//                                    .fontWeight(.ultraLight)
//                                Text(self.selectedAccount.saldo)
//                                    .font(.caption)
//                                    .foregroundColor(Color(hex: "#232175"))
//                                    .fontWeight(.semibold)
//                            }
//                        }
//
//                        Spacer()
//
//                        Image("ic_expand")
//                    }
//                    .padding()
//                }
//            )
//        }
//        .frame(width: UIScreen.main.bounds.width - 60)
//        .background(Color(hex: "#F6F8FB"))
//        .cornerRadius(15)
//    }
    
    
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
                                self.transferData.cardNo = self.savingAccountVM.balanceAccount[index].cardNo ?? ""
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
    
    // MARK: - MODAL
    
    func bottomSheetCard() -> some View {
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
                    
                    Text("J")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                }
                
                VStack(alignment: .leading) {
                    Text("JOHN LENNON")
                        .font(.subheadline)
                    
                    HStack {
                        Text("Mestika :")
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Text(self.noRekeningCtrl)
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
                NavigationLink(
                    destination: TransferRtgsConfirmation().environmentObject(transferData),
                    label: {
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
            
            Text("Minimum transaction".localized(language) + "Rp. \(self.minLimit),- . " + "Please change the transaction nominal.".localized(language))
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
            
            Text("Minimum balance in your account".localized(language) + "Rp. \(selectedAccount.saldo.thousandSeparator()),- " + "exceeded. Please change the transaction amount or add a balance to your account.".localized(language))
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
            
            Text("Transaction Limit".localized(language) + " Rp.\(limitTrx.thousandSeparator()),- " + "Exceeded. Please reduce the nominal amount of the transaction or cancel the transaction.".localized(language))
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
                            Text(data.namaRekening)
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
                    self.transferData.sourceNumber = data.sourceNumber
                    self.transferData.sourceAccountName = data.namaRekening
                    print(data.noRekening)
                    self.showDialogSelectAccount = false
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - FUNCTION DATA
    
    var disableForm: Bool {
        
        if (self.transferType == "Online") {
            print("Validation IBFT")
            if (self.destinationNameCtrl.isNotEmpty() && self.selectedSourceNumber.isNotEmpty() && self.noRekeningCtrl.count >= 9 && self.amount != "" && self.transferType != "Select Transaction Type".localized(language) && self.bankSelector != "Choose Destination Bank".localized(language)) {
                return false
            }
        } else {
            print("Validation RTGS")
            if (self.destinationNameCtrl.isNotEmpty() && self.selectedSourceNumber.isNotEmpty() && self.noRekeningCtrl.count >= 9 && self.amount != "" && self.transferType != "Select Transaction Type".localized(language) && self.bankSelector != "Choose Destination Bank".localized(language) && self.destinationType != "Receiver Type".localized(language) && self.citizenShipCtrl != "Citizenship".localized(language)) {
                return false
            }
        }
        return true
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "in_ID")
        return formatter
    }
    
    @ObservedObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                self.transferData.username = self.profileVM.name
                self.listBankAccount.removeAll()
                self.listBankAccount.append(BankAccount(id: 1, namaRekening: self.profileVM.nameOnCard, productName: self.profileVM.nameOnCard, sourceNumber: self.profileVM.accountNumber, noRekening: self.profileVM.cardNo, saldo: self.profileVM.balance.thousandSeparator()))
                self.selectedAccount = self.listBankAccount[0]
//                self.transferData.cardNo = self.profileVM.cardNo
                self.transferData.sourceNumber = self.profileVM.accountNumber
                self.transferData.sourceAccountName = self.profileVM.nameOnCard
                
                //                getLimit(code: self.profileVM.classCode)
            }
        }
    }
    
    @ObservedObject var referenceVM = ReferenceSummaryViewModel()
    func getListBank() {
        self.referenceVM.getAllSchedule { success in
            
            if success {
                print("SUCCESS")
//                self.bankSelector = self.referenceVM._listBank[0].bankName
                self.transferData.bankName = self.referenceVM._listBank[0].name
                self.transferData.destinationBankCode = self.referenceVM._listBank[0].code
                self.transferData.combinationBankName = ""
                print(self.referenceVM._listBank.count)
            }
            
            if !success {
                print("!SUCCESS")
            }
        }
    }
    
    @ObservedObject var limitVM = TransferViewModel()
    func getLimit(code: String) {
        self.limitVM.getLimitTransaction(classCode: "70") { success in
            if success {
                self.maxLimit = Int(self.limitVM.limitIbft) ?? 0
                self.limitTrx = self.limitVM.limitIbft
            }
        }
    }
    
    // MARK: GET DESTINATION NAME
    func inquiryTransfer() {
        if transferData.destinationNumber.count == 11 {
            self.isShowName = true
            
            self.limitVM.transferIbftInquiry(transferData: transferData) { success in
                
                DispatchQueue.main.async {
                    if success {
                        print("\nSUCCESS DESTINATION NAME : \(self.limitVM.destinationName)\n")
                        self.destinationNameCtrl = self.limitVM.destinationName
                        
                        self.transferData.ref = self.limitVM.reffNumber
                        self.transferData.destinationNumber = self.limitVM.destinationNumber
                        self.transferData.destinationName = self.limitVM.destinationName
                    }
                    
                    if !success {
                        print("NOT SUCCESS")
                        self.destinationNameCtrl = "Akun Tidak Ditemukan"
                        self.limitVM.destinationName = "Akun Tidak Ditemukan"
                    }
                }
            }
        }
    }
}

struct TransferRtgsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferRtgsScreen(dest: .constant(""), type: .constant(""), destBank: .constant(""), nameCst: .constant(""), desc: .constant(""))
    }
}
