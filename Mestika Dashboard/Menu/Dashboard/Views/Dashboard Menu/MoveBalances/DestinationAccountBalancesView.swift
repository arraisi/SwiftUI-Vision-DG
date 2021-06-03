//
//  DestinationAccountBalancesView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI
import Indicators

struct MoveBalanceCard: Identifiable, Hashable {
    var id: Int
    var typeTabungan, saldo, cardNo: String
    var color: String
}

struct DestinationAccountBalancesView: View {
    
    // Observable Object
    @State var transaksiData = MoveBalancesModel()
    
    // Local Variable
    @State private var listSourceNumber: [String] = []
    @State private var listTabunganName: [String] = []
    @State private var listCardNo: [String] = []
    @State private var listBalance: [String] = []
    
    // Bool
    @State private var isLoading: Bool = false
    @State private var isShowAlert: Bool = false
    @State private var showFreezeMenu: Bool = false
    
    // Alert Message
    @State private var messageError: String = ""
    @State private var statusError: String = ""
    
    // Routing
    @State private var nextRouting: Bool = false
    
    var body: some View {
        ZStack {
            
            // Route Link
            NavigationLink(
                destination: FormMoveBalanceView().environmentObject(transaksiData),
                isActive: self.$nextRouting,
                label: {}
            )
            
            // bg color
            Color(hex: "#F4F7FA")
            
            VStack {
                //                if (self.isLoading) {
                //                    LinearWaitingIndicator()
                //                        .animated(true)
                //                        .foregroundColor(.green)
                //                        .frame(height: 1)
                //                        .padding(.bottom, 10)
                //                }
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    // title text
                    VStack(alignment: .leading) {
                        Text("Pindah Saldo")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Silahkan pilih tabungan tujuan pemindahan saldo dari rekening utama")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 20)
                    
                    // list account
                    
                    if (self.isLoading) {
                        ShimmerView()
                            .frame(width: UIScreen.main.bounds.width - 50, height: 170)
                            .cornerRadius(15)
                    } else if !self.listBalance.isEmpty {
                        ForEach(0..<self.listSourceNumber.count, id: \.self) { index in
                            Button(action: {
                                
                                self.transaksiData.destinationNumber = self.listSourceNumber[index]
                                self.transaksiData.transferType = "Pindah Saldo"
                                self.transaksiData.destinationName = self.listTabunganName[index]
                                self.transaksiData.sourceAccountName = "Rekening Utama"
                                
                                self.nextRouting = true
                                
                            }, label: {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        Spacer()
                                        Image("logo_m_mestika")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                    }
                                    .padding(.trailing, 15)
                                    
                                    Text("\(self.listTabunganName[index])")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 18))
                                        .padding(.bottom, 5)
                                    
                                    HStack(alignment: .top) {
                                        Text("Rp.")
                                            .fontWeight(.bold)
                                        
                                        Text("\(self.listBalance[index].thousandSeparator())")
                                            .fontWeight(.heavy)
                                            .font(.system(size: 30))
                                    }
                                    .padding(.bottom, 5)
                                    
                                    Text("\(self.listSourceNumber[index])")
                                        .font(.system(size: 15))
                                }
                                .padding([.vertical, .leading], 15)
                                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                                .background(Color(hex: "#2334D0"))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                            })
                        }
                    } else {
                        Text("Anda Tidak Memiliki Sub Account.\nSilahkan Tambahkan Terlebih Dahulu.")
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                    }
                })
                .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
            }
            
            if (showFreezeMenu) {
                ModalOverlay(tapAction: { withAnimation { } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Pindah Saldo", displayMode: .inline)
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("\(self.statusError)"),
                message: Text("\(self.messageError)"),
                dismissButton: .default(Text("OK"))
            )
        }
        .popup(isPresented: $showFreezeMenu, type: .toast, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            popupFreezeAccount()
                .padding(.bottom, 15)
        }
        .onAppear {
            self.checkFreezeAccount()
            self.listSourceNumber.removeAll()
            self.listTabunganName.removeAll()
            self.listBalance.removeAll()
            self.listCardNo.removeAll()
            getAccountBalance()
        }
    }
    
    // func get balance main account
    @ObservedObject var profileVM = ProfileViewModel()
    func getMainAccount() {
        self.profileVM.getProfile { success in
            DispatchQueue.main.async {
                if success {
                    self.transaksiData.sourceNumber = self.profileVM.accountNumber
                    self.transaksiData.cardNo = self.profileVM.cardNo
                    
                    // Get List
                    getListAccount()
                }
                
                if !success {
                    self.isLoading = false
                    
                    self.isShowAlert = true
                    self.statusError = self.profileVM.statusCode
                    self.messageError = "Cannot Get Main Account"
                }
            }
        }
    }
    
    // func get balance
    func getAccountBalance() {
        self.isLoading = true
        
        self.profileVM.getAccountBalance { success in
            if success {
                
                if (self.profileVM.creditDebit == "D") {
                    self.transaksiData.mainBalance = "0"
                } else {
                    self.transaksiData.mainBalance = self.profileVM.balance
                }
                
                getMainAccount()
            }
            
            if !success {
                self.isLoading = false
                
                self.isShowAlert = true
                self.statusError = "500"
                self.messageError = "Cannot Get Main Account Balance"
            }
        }
    }
    
    func checkFreezeAccount() {
        self.profileVM.getAccountFreeze { sucess in
            
//            self.showFreezeMenu = true
            
            if sucess {
                if self.profileVM.freezeAccount {
                    self.showFreezeMenu = true
                }
            }
            
        }
    }
    
    // func get list account
    @StateObject var savingAccountVM = SavingAccountViewModel()
    func getListAccount() {
        self.savingAccountVM.getAccounts { success in
            
            DispatchQueue.main.async {
                if success {
                    self.savingAccountVM.accounts.forEach { a in
                        
                        if (a.categoryProduct == "S") {
                            
                            self.listSourceNumber.append(a.accountNumber)
                            self.listTabunganName.append(a.productName ?? "No Name")
                            
                        }
                    }
                    
                    if (self.listSourceNumber.isEmpty) {
                        self.isLoading = false
                        print("No Sub Account")
                    } else {
                        self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { success in
                            
                            DispatchQueue.main.async {
                                if success {
                                    
                                    self.isLoading = false
                                    self.savingAccountVM.balanceAccount.forEach { b in
                                        self.listBalance.append(b.balance ?? "0")
                                    }
                                }
                                
                                if !success {
                                    self.isLoading = false
                                    
                                    self.isShowAlert = true
                                    self.statusError = "500"
                                    self.messageError = "Failed Parse Balance"
                                }
                            }
                            
                        }
                    }
                    
                }
                
                if !success {
                    self.isLoading = false
                    
                    self.isShowAlert = true
                    self.statusError = "500"
                    self.messageError = "Failed Parse Account"
                }
            }
            
        }
    }
    
    // MARK: POPUP MESSAGE ERROR
    func popupFreezeAccount() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Akun anda telah dibekukan")
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showFreezeMenu = false
            }) {
                Text("Back")
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

struct DestinationAccountBalancesView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationAccountBalancesView()
    }
}
