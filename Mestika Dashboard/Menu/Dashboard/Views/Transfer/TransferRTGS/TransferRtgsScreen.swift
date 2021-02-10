//
//  TransferRtgsScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/02/21.
//

import SwiftUI

struct TransferRtgsScreen: View {
    
    // Observable Object
    @State var transferData = TransferOffUsModel()
    
    // Variable Transfer Type
    var _listTransferType = ["RTGS", "SKN"]
    @State private var transferType: String = ""
    
    // Variable List BANK
    @State private var bankSelector: String = ""
    
    // Variable NoRekening
    @State private var noRekeningCtrl: String = ""
    @State var selectedAccount = BankAccount(id: 0, namaRekening: "Pilih Rekening", sourceNumber: "", noRekening: "", saldo: "0.0")
    @State var listBankAccount: [BankAccount] = []
    
    // Variable Amount
    @State var amount = ""
    private var maxLimit: Int = 900000
    private var minLimit: Int = 10000
    
    // Variable Transaction Frequecy
    var _listFrequency = ["Sekali", "Berkali-kali"]
    @State var transactionFrequency = "Pilih Frekuensi Transaksi"
    
    // Variable Voucher
    var _listVoucher = ["VCR-50K", "VCR-100K", "VCR-150K", "VCR-250K"]
    @State var transactionVoucher = "Pilih Voucher"
    
    // Variable Notes
    @State private var notesCtrl: String = ""
    
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
                        frekuensiTransaksiCard
                        chooseVoucherCard
                        notesCard
                        
                        Spacer()
                        
                        Button(action: {
                            
                            let amount = Int(self.transferData.amount) ?? 0
                            let myCredit = Int(self.selectedAccount.saldo.replacingOccurrences(of: ".", with: "")) ?? 0
                            
                            if (amount <= self.minLimit) {
                                self.showDialogMinTransaction = true
                            } else if (amount <= self.maxLimit && amount <= myCredit) {
                                
                                if (self.transferData.transactionType == "Online") {
                                    self.showDialogConfirmation = true
                                } else {
                                    print("OKE")
                                    self.isRouteTransaction = true
                                }
                                
                            } else if (amount > myCredit ) {
                                self.showDialogMinReached = true
                            } else {
                                self.showDialogMaxReached = true
                            }
                            
                        }, label: {
                            Text("KONFIRMASI TRANSFER")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disabledButton)
                        .background(disabledButton ? Color.gray : Color(hex: "#232175"))
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
        }
        .navigationBarTitle("Transfer ke Bank Lain", displayMode: .inline)
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
            self.transferType = _listTransferType[0]
            self.transactionFrequency = _listFrequency[0]
            self.transferData.transactionFrequency = _listFrequency[0]
            self.transferData.transactionType = _listTransferType[0]
            getProfile()
            getListBank()
        }
    }
    
    var chooseTransactionType: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transferType)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding()
                
                Spacer()
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
                    Text("Pilih Bank")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 25)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(bankSelector)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                    .padding()
                    
                    Spacer()
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
                    Text("No Rekening Tujuan")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                HStack {
                    TextField("Rekening", text: self.$noRekeningCtrl, onEditingChanged: { changed in
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
                Text("Jumlah Besaran (Rp)")
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
                Text("Limit Transaksi")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                
                Spacer()
                
                HStack(alignment: .top) {
                    Text("Rp.")
                        .foregroundColor(.red)
                        .font(.caption2)
                        .fontWeight(.bold)
                    Text("900.000")
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
                VStack(alignment: .leading) {
                    Text("Sekarang")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Image("ic_calendar_dark")
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
                Text("Catatan")
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            VStack {
                TextField("Tulis keterangan Transaksi disini", text: self.$notesCtrl, onEditingChanged: { changed in
                    self.transferData.notes = self.notesCtrl
                })
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
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
            HStack {
                VStack(alignment: .leading) {
                    Text(self.selectedAccount.namaRekening)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("Saldo Aktif :")
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
            .onTapGesture {
                UIApplication.shared.endEditing()
                self.showDialogSelectAccount = true
            }
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color(hex: "#F6F8FB"))
        .cornerRadius(15)
    }
    
    // MARK: - MODAL
    
    func bottomSheetCard() -> some View {
        VStack {
            HStack {
                Text("Nomor Rekening Terkonfirmasi")
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
                NavigationLink(destination: TransferRtgsConfirmation().environmentObject(transferData), label: {
                    Text("KONFIRMASI TRANSFER")
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
            
            Text(NSLocalizedString("Transaksi ada kurang dari minimum transaksi.", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString("Transaksi minimum Rp. \(self.minLimit),- . Silahkan mengganti nominal transaksi.", comment: ""))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMinTransaction = false
                },
                label: {
                    Text("UBAH NOMINAL")
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
                    Text("BATALKAN TRANSAKSI")
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
            
            Text(NSLocalizedString("Saldo Minimum Terlampaui", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString("Saldo minimum rekening Anda Rp. \(selectedAccount.saldo.thousandSeparator()),- terlampaui. Silahkan mengganti nominal transaksi atau menambahkan saldo ke rekening Anda.", comment: ""))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMinReached = false
                },
                label: {
                    Text("UBAH NOMINAL")
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
                    Text("BATALKAN TRANSAKSI")
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
            
            Text(NSLocalizedString("Limit Nilai transaksi terlampaui", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString("Limit nilai transaksi Rp.900.000,- terlampaui. Silahkan kurangi jumlah nominal transaksi atau batalkan transaksi.", comment: ""))
                .font(.custom("Montserrat-Light", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.showDialogMaxReached = false
                },
                label: {
                    Text("UBAH NOMINAL")
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
                    Text("BATALKAN TRANSAKSI")
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
                Text("Pilih Akun")
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
                                Text("Saldo Aktif :")
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
    
    func validateForm() {
        if (self.transferData.destinationNumber.count == 16 &&
                self.transferData.amount != "" &&
                self.transferData.transactionFrequency != "Pilih Frekuensi Transaksi") {
            disabledButton = false
        } else {
            if (self.transferData.transactionVoucher == "Pilih Voucher") {
                self.transferData.transactionVoucher = "-"
            }
            disabledButton = true
        }
    }
    
    @ObservedObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                self.transferData.username = self.profileVM.name
                self.listBankAccount.removeAll()
                self.listBankAccount.append(BankAccount(id: 1, namaRekening: self.profileVM.nameOnCard, sourceNumber: self.profileVM.accountNumber, noRekening: self.profileVM.cardNo, saldo: self.profileVM.balance.thousandSeparator()))
                self.selectedAccount = self.listBankAccount[0]
                self.transferData.cardNo = selectedAccount.noRekening
                self.transferData.sourceNumber = selectedAccount.sourceNumber
                self.transferData.sourceAccountName = selectedAccount.namaRekening
            }
        }
    }
    
    @ObservedObject var referenceVM = ReferenceSummaryViewModel()
    func getListBank() {
        self.referenceVM.getAllSchedule { success in
            
            if success {
                print("SUCCESS")
                self.bankSelector = self.referenceVM._listBank[0].bankName
                print(self.referenceVM._listBank.count)
            }
            
            if !success {
                print("!SUCCESS")
            }
        }
    }
}

struct TransferRtgsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferRtgsScreen()
    }
}
