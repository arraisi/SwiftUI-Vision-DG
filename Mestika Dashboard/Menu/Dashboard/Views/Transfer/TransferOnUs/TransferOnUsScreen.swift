//
//  TransferOnUsScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/10/20.
//

import SwiftUI
import BottomSheet

struct TransferOnUsScreen: View {
    
    @State var transferData = TransferOnUsModel()
    @State var transactionFrequency = "Pilih Frekuensi Transaksi"
    @State var transactionVoucher = "Pilih Voucher"
    @State var destinationNumber = ""
    @State var amount = ""
    @State var selectedAccount = BankAccount(id: 0, namaRekening: "Pilih Rekening", productName: "", sourceNumber: "", noRekening: "", saldo: "0.0")
    
    @State private var showDialogConfirmation = false
    @State private var showDialogSelectAccount = false
    @State private var showDialogMaxReached = false
    @State private var showDialogMinReached = false
    @State private var showDialogMinTransaction: Bool = false
    
    @State private var isShowName: Bool = false
    @State private var showName: String = ""
    
    @State private var disabledButton = true
    
    @State private var routeConfirmation: Bool = false
    
    private var maxLimit: Int = 900000
    private var minLimit: Int = 10000
    
    /* Function GET USER Status */
    @ObservedObject var profileVM = ProfileViewModel()
    
    @State var balance: String = ""
    @State var productName: String = "-"
    
    @State var listBankAccount: [BankAccount] = []
    
    var _listVoucher = ["Voucher Tidak Tersedia"]
    var _listFrequency = ["Sekali", "Berkali-kali"]
    
    @State private var selectedCalendar: String = "Now"
    
    // Variable Date
    let now = Date()
    @State var date = Date()
    private var selectedDate: Binding<Date> {
      Binding<Date>(get: { self.date}, set : {
          self.date = $0
          self.setDateString()
      })
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
                ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
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
//                        .isDetailLink(false)
                        
                        VStack {
                            Button(action: {
                                //                                    MARK: To be replaced with actual data
                                self.transferData.destinationName = self.showName
                                
                                UIApplication.shared.endEditing()
                                let amount = Int(self.transferData.amount) ?? 0
                                let myCredit = Int(self.selectedAccount.saldo.replacingOccurrences(of: ".", with: "")) ?? 0
                                
                                if (amount < self.minLimit) {
                                    self.showDialogMinTransaction = true
                                } else if (amount <= self.maxLimit && amount <= myCredit) {
                                    self.transferData.notes = self.notesCtrl
                                    self.transferData.transactionFrequency = transactionFrequency
                                    self.transferData.transactionVoucher = transactionVoucher
                                    self.transferData.transactionDate = dateFormatter.string(from: self.date)
                                    self.routeConfirmation = true
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
        .navigationBarTitle("Transfer Antar Sesama", displayMode: .inline)
        .onAppear() {
            self.transferData = TransferOnUsModel()
            self.getProfile()
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
                Text("No Rekening Tujuan")
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            VStack {
                TextField("Rekening", text: $destinationNumber, onEditingChanged: {_ in
                    inquiryTransfer()
                }, onCommit: {
                    
                })
                    .onReceive(destinationNumber.publisher.collect()) {
                        self.destinationNumber = String($0.prefix(11))
                        self.transferData.destinationNumber = destinationNumber
                        validateForm()
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
                        Text(self.showName)
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
            Button(
                action: {
                    UIApplication.shared.endEditing()
                    self.showDialogSelectAccount = true
                },
                label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(self.selectedAccount.productName)
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
                }
            )
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var calendarCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(self.selectedCalendar)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                DatePicker("", selection: selectedDate, in: Date()..., displayedComponents: .date)
                    .labelsHidden()
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
                MultilineTextField("Tulis keterangan Transaksi disini", text: self.$notesCtrl, onCommit: {
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
                    
                    Text("A")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                }
                
                VStack(alignment: .leading) {
                    Text("\(self.transferData.destinationName)")
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
                            Text(data.productName)
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
        if (self.destinationNumber.count == 11) {
            self.isShowName = true
        }
        
        if (self.destinationNumber.count == 11 && self.amount != "") {
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
    
    @ObservedObject var transferVM = TransferViewModel()
    func inquiryTransfer() {
        self.transferVM.transferOnUsInquiry(transferData: transferData) { success in
            DispatchQueue.main.async {
                if success {
                    print("SUCCESS")
                    self.showName = self.transferVM.destinationName
                }
                
                if !success {
                    print("NOT SUCCESS")
                    self.showName = "Akun Tidak Ditemukan"
                }
            }
        }
    }
    
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                self.transferData.username = self.profileVM.name
                
                self.listBankAccount.removeAll()
                
                self.listBankAccount.append(BankAccount(id: 1, namaRekening: self.profileVM.cardName, productName: self.profileVM.nameOnCard, sourceNumber: self.profileVM.accountNumber, noRekening: self.profileVM.cardNo, saldo: self.profileVM.balance.thousandSeparator()))
                
                self.selectedAccount = self.listBankAccount[0]
                
                self.transferData.cardNo = selectedAccount.noRekening
                self.transferData.sourceNumber = selectedAccount.sourceNumber
                self.transferData.sourceAccountName = selectedAccount.productName
            }
        }
    }
}

struct TransferOnUsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferOnUsScreen()
    }
}