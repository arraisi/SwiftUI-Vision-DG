//
//  TransferRtgsScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/02/21.
//

import SwiftUI

struct TransferRtgsScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    // Observable Object
    @State var transferData = TransferOffUsModel()
    
    // Variable Transfer Type
    var _listTransferType = ["RTGS", "SKN"]
    @State private var transferType: String = NSLocalizedString("Select Transaction Type".localized(LocalizationService.shared.language), comment: "")
    
    // Variable List BANK
    @State private var bankSelector: String = NSLocalizedString("Choose Destination Bank".localized(LocalizationService.shared.language), comment: "")
    
    @Binding var dest: String
    
    // Variable NoRekening
    @State private var noRekeningCtrl: String = ""
    @State var selectedAccount = BankAccount(id: 0, namaRekening: NSLocalizedString("Select Account".localized(LocalizationService.shared.language), comment: ""), productName: "", sourceNumber: "", noRekening: "", saldo: "0.0")
    @State var listBankAccount: [BankAccount] = []
    
    // Variable Amount
    @State var amount = ""
    @State private var maxLimit: Int = 10000000
    @State private var limitTrx: String = "10000000"
    @State private var minLimit: Int = 0
    
    // Variable Transaction Frequecy
    var _listFrequency = [NSLocalizedString("Once".localized(LocalizationService.shared
                                                                .language), comment: ""), NSLocalizedString("Many times".localized(LocalizationService.shared.language), comment: "")]
    @State var transactionFrequency = NSLocalizedString("Select Transaction Frequency".localized(LocalizationService.shared.language), comment: "")
    
    // Variable Voucher
    var _listVoucher = [NSLocalizedString("Voucher Not Available".localized(LocalizationService.shared.language), comment: "")]
    @State var transactionVoucher = NSLocalizedString("Select Voucher".localized(LocalizationService.shared.language), comment: "")
    
    // Variable Notes
    @State private var notesCtrl: String = ""
    
    @State private var selectedCalendar: String = NSLocalizedString("Now".localized(LocalizationService.shared.language), comment: "")
    
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
            self.selectedCalendar = NSLocalizedString("Now".localized(LocalizationService.shared.language), comment: "")
        } else {
            self.selectedCalendar = NSLocalizedString("Next".localized(LocalizationService.shared.language), comment: "")
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
                            
                            if (transactionVoucher == NSLocalizedString("Select Voucher".localized(language), comment: "") || transactionVoucher == NSLocalizedString("Voucher Not Available".localized(language), comment: "")) {
                                self.transferData.transactionVoucher = ""
                            }
                            
                            if (amount < self.minLimit) {
                                self.showDialogMinTransaction = true
                            } else if (amount <= myCredit) {
                                
                                if (self.transferData.transactionType == "Online") {
                                    self.showDialogConfirmation = true
                                } else {
                                    self.transferData.destinationNumber = self.noRekeningCtrl
                                    self.transferData.transactionType = self.transferType
                                    self.transferData.notes = self.notesCtrl
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
                            Text(NSLocalizedString("CONFIRM TRANSFER".localized(language), comment: ""))
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disableForm)
                        .background(disableForm ? Color.gray : Color(hex: "#232175"))
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
                destination: TransferRtgsDestination().environmentObject(transferData),
                isActive: self.$isRouteTransaction,
                label: {
                    EmptyView()
                })
                .isDetailLink(false)
        }
        .navigationBarTitle(NSLocalizedString("Transfer to Other Bank".localized(language), comment: ""), displayMode: .inline)
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
            self.transferData = TransferOffUsModel()
//            self.transferType = _listTransferType[0]
            if (dest != "") {
                self.noRekeningCtrl = self.dest
            }
            self.transferData.transactionFrequency = _listFrequency[0]
            self.transferData.transactionVoucher = _listVoucher[0]
            self.transferData.transactionType = _listTransferType[0]
            getProfile()
            getListBank()
            self.getLimit(code: "70")
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
                    Text(NSLocalizedString("Choose Bank".localized(language), comment: ""))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 25)
                
                HStack {
                    Menu {
                        ForEach(0..<self.referenceVM._listBank.count) { index in
                            
                            Button(action: {
                                self.bankSelector = self.referenceVM._listBank[index].bankName
                                self.transferData.bankName = self.referenceVM._listBank[index].bankName
                                self.transferData.combinationBankName = self.referenceVM._listBank[index].combinationName
                                self.transferData.destinationBankCode = self.referenceVM._listBank[index].swiftCode
                            }) {
                                Text(self.referenceVM._listBank[index].bankName)
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
                    Text(NSLocalizedString("Destination Account No".localized(language), comment: ""))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                HStack {
                    TextField(NSLocalizedString("Account".localized(language), comment: ""), text: self.$noRekeningCtrl, onEditingChanged: { changed in
                        self.transferData.destinationNumber = self.noRekeningCtrl
                    })
                    .keyboardType(.numberPad)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .onReceive(noRekeningCtrl.publisher.collect()) {
                        self.noRekeningCtrl = String($0.prefix(16))
                    }
                }
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.bottom, 25)
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
                Text(NSLocalizedString("Amount (Rp)".localized(language), comment: ""))
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
                Text(NSLocalizedString("Transaction Limit".localized(language), comment: ""))
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
                        .foregroundColor(transactionFrequency == NSLocalizedString("Select Transaction Frequency".localized(language), comment: "") ? .gray : .black)
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
                        .foregroundColor(transactionVoucher == NSLocalizedString("Select Voucher".localized(language), comment: "") ? .gray : .black)
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
                Text(NSLocalizedString("Notes".localized(language), comment: ""))
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            VStack {
                MultilineTextField(NSLocalizedString("Write a transaction description here".localized(language), comment: ""), text: self.$notesCtrl, onCommit: {
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
    
    var bankAccountCard: some View {
        ZStack {
            
            Button(
                action: {
                    UIApplication.shared.endEditing()
                    self.showDialogSelectAccount = true
                },
                label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(self.selectedAccount.namaRekening)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                            
                            HStack {
                                Text(NSLocalizedString("Active Balance:".localized(language), comment: ""))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                                Text(self.selectedAccount.saldo)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#232175"))
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        Spacer()
                        
                        Image("ic_expand")
                    }
                    .padding()
                }
            )
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color(hex: "#F6F8FB"))
        .cornerRadius(15)
    }
    
    // MARK: - MODAL
    
    func bottomSheetCard() -> some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Confirmed Account Number".localized(language), comment: ""))
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
                        Text(NSLocalizedString("CONFIRM TRANSFER".localized(language), comment: ""))
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
            
            Text(NSLocalizedString(NSLocalizedString("There are transactions less than the minimum transaction.".localized(language), comment: ""), comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString(NSLocalizedString("Minimum transaction".localized(language), comment: "") + "Rp. \(self.minLimit),- . " + NSLocalizedString("Please change the transaction nominal.".localized(language), comment: ""), comment: ""))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMinTransaction = false
                },
                label: {
                    Text(NSLocalizedString("CHANGE THE NOMINAL".localized(language), comment: ""))
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
                    Text(NSLocalizedString("CANCEL TRANSACTION".localized(language), comment: ""))
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
            
            Text(NSLocalizedString(NSLocalizedString("Minimum Balance Exceeded".localized(language), comment: ""), comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString(NSLocalizedString("Minimum balance in your account".localized(language), comment: "") + "Rp. \(selectedAccount.saldo.thousandSeparator()),- " + NSLocalizedString("exceeded. Please change the transaction amount or add a balance to your account.".localized(language), comment: ""), comment: ""))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMinReached = false
                },
                label: {
                    Text(NSLocalizedString("CHANGE THE NOMINAL".localized(language), comment: ""))
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
                    Text(NSLocalizedString("CANCEL TRANSACTION".localized(language), comment: ""))
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
            
            Text(NSLocalizedString(NSLocalizedString("Transaction limit exceeded".localized(language), comment: ""), comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString(NSLocalizedString("Transaction Limit".localized(language), comment: "") + " Rp.\(limitTrx.thousandSeparator()),- " + NSLocalizedString("Exceeded. Please reduce the nominal amount of the transaction or cancel the transaction.".localized(language), comment: ""), comment: ""))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMaxReached = false
                },
                label: {
                    Text(NSLocalizedString("CHANGE THE NOMINAL".localized(language), comment: ""))
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
                    Text(NSLocalizedString("CANCEL TRANSACTION".localized(language), comment: ""))
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
                Text(NSLocalizedString("Select Account".localized(language), comment: ""))
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
                                Text(NSLocalizedString("Active Balance:".localized(language), comment: ""))
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
                    self.transferData.cardNo = data.noRekening
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
        if (self.noRekeningCtrl.count >= 9 && self.amount != "" && self.transferType != NSLocalizedString("Select Transaction Type".localized(language), comment: "") && self.bankSelector != NSLocalizedString("Choose Destination Bank".localized(language), comment: "")) {
            return false
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
                self.transferData.cardNo = self.profileVM.cardNo
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
                self.transferData.bankName = self.referenceVM._listBank[0].bankName
                self.transferData.destinationBankCode = self.referenceVM._listBank[0].swiftCode
                self.transferData.combinationBankName = self.referenceVM._listBank[0].combinationName
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
}

struct TransferRtgsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferRtgsScreen(dest: .constant(""))
    }
}
