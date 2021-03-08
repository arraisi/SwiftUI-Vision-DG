//
//  LimitCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 06/11/20.
//

import SwiftUI

struct CardLimitView: View {
    
    @State private var isLoading: Bool = false
    @State private var statusError: String = ""
    @State private var messageError: String = ""
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    // Observable Object
    @State var activateData = LimitKartuKuModel()
    
    @State var limitPerTransaksi: Double = 0
    @State var limitPerHari: Double = 20000000
    @State var limitPenarikanHarian: Double = 0
    @State var limitTransferOnUs: Double = 0
    @State var limitPembelian: Double = 0
    
    @State var limitPerTransaksiCtrl: String = "0"
    @State var limitPenarikanHarianCtrl: String = "0"
    @State var limitOnUsCtrl: String = "0"
    @State var limitPembayaranCtrl: String = "0"
    @State var limitPembelianCtrl: String = "0"
    @State var limitIbftCtrl: String = "0"
    
    let maxTransaksi: Double = 50000000
    let maxPenarikanHarian: Double = 10000000
    let maxTransferOnUs: Double = 10000000
    let maxPembelian: Double = 10000000
    
    @State private var keyboardOffset: CGFloat = 0
    
    @State var isNextRoute: Bool = false
    
    var card: KartuKuDesignViewModel
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showingAlert = false
    
    private var disabledBtn: Bool {
        limitPenarikanHarian > maxPenarikanHarian || limitPembelian > maxPembelian || limitTransferOnUs > maxTransferOnUs
    }
    
    var body: some View {
        LoadingView(isShowing: self.$isLoading, content: {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        CardView(card: card, cardWidth: UIScreen.main.bounds.width - 60, cardHeight: 202, showContent: true)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                        
                        VStack(alignment: .leading, spacing: 30, content: {
                            
                            Text("Card Limit".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                            
                            // IBFT per Transaksi
                            VStack(alignment: .leading) {
                                Text("Ibft per transaksi")
                                    .font(.custom("Montserrat-Light", size: 12))
                                HStack(alignment:.top){
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                    
                                    TextField("0", text: self.$limitPerTransaksiCtrl, onEditingChanged: {_ in
                                    })
                                    .disabled(true)
                                        .onReceive(limitPerTransaksiCtrl.publisher.collect()) {
                                            let amountString = String($0.prefix(13))
                                            let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                            self.limitPerTransaksiCtrl = cleanAmount.thousandSeparator()
                                            self.activateData.limitIbft = cleanAmount
                                        }
                                        .keyboardType(.decimalPad)
                                        .font(.custom("Montserrat-Bold", size: 30))
                                        .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                    
                                }
                                Divider()
                                HStack {
                                    Text("Maximum limit of ibft transaction")
                                        .font(.custom("Montserrat-Light", size: 10))
                                    Text("Rp. 0,-")
                                        .font(.custom("Montserrat-SemiBold", size: 10))
                                }
                                .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                            }
                            
                            // Limit penarikan harian ATM
                            VStack(alignment: .leading) {
                                Text("Limit penarikan harian di ATM")
                                    .font(.custom("Montserrat-Light", size: 12))
                                HStack(alignment:.top){
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                    
                                    TextField("0", text: self.$limitPenarikanHarianCtrl, onEditingChanged: {_ in
                                    })
                                        .onReceive(limitPenarikanHarianCtrl.publisher.collect()) {
                                            let amountString = String($0.prefix(13))
                                            let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                            self.limitPenarikanHarianCtrl = cleanAmount.thousandSeparator()
                                            self.limitPenarikanHarian = Double(cleanAmount) ?? 0
                                            self.activateData.limitWd = cleanAmount
                                        }
                                        .keyboardType(.decimalPad)
                                        .font(.custom("Montserrat-Bold", size: 30))
                                        .foregroundColor(limitPenarikanHarian > maxPenarikanHarian ? Color.red : Color(hex: "#232175"))
                                    
                                }
                                Divider()
                                HStack {
                                    Text("Maximum limit of withdraw transactions")
                                        .font(.custom("Montserrat-Light", size: 10))
                                    Text("Rp. 10.000.000,-")
                                        .font(.custom("Montserrat-SemiBold", size: 10))
                                }
                                .foregroundColor(limitPenarikanHarian > maxPenarikanHarian ? Color.red : Color(hex: "#232175"))
                            }
                            
                            // Limit On Us
                            VStack(alignment: .leading) {
                                Text("Limit transaksi on us")
                                    .font(.custom("Montserrat-Light", size: 12))
                                HStack(alignment:.top){
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                    
                                    TextField("0", text: self.$limitOnUsCtrl, onEditingChanged: {_ in
                                    })
                                        .onReceive(limitOnUsCtrl.publisher.collect()) {
                                            let amountString = String($0.prefix(13))
                                            let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                            self.limitOnUsCtrl = cleanAmount.thousandSeparator()
                                            self.limitTransferOnUs = Double(cleanAmount) ?? 0
                                            self.activateData.limitOnUs = cleanAmount
                                        }
                                        .keyboardType(.decimalPad)
                                        .font(.custom("Montserrat-Bold", size: 30))
                                        .foregroundColor(limitTransferOnUs > maxTransferOnUs ? Color.red : Color(hex: "#232175"))
                                    
                                }
                                Divider()
                                HStack {
                                    Text("Maximum limit of transfer on us")
                                        .font(.custom("Montserrat-Light", size: 10))
                                    Text("Rp. 10.000.000,-")
                                        .font(.custom("Montserrat-SemiBold", size: 10))
                                }
                                .foregroundColor(limitTransferOnUs > maxTransferOnUs ? Color.red : Color(hex: "#232175"))
                            }
                            
                            // Limit Pembayaran
                            VStack(alignment: .leading) {
                                Text("Limit pembayaran")
                                    .font(.custom("Montserrat-Light", size: 12))
                                HStack(alignment:.top){
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                    
                                    TextField("0", text: self.$limitPembayaranCtrl, onEditingChanged: {_ in
                                    })
                                    .disabled(true)
                                        .onReceive(limitPembayaranCtrl.publisher.collect()) {
                                            let amountString = String($0.prefix(13))
                                            let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                            self.limitPembayaranCtrl = cleanAmount.thousandSeparator()
                                            self.activateData.limitPayment = cleanAmount
                                        }
                                        .keyboardType(.decimalPad)
                                        .font(.custom("Montserrat-Bold", size: 30))
                                        .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                    
                                }
                                Divider()
                                HStack {
                                    Text("Maximum limit of payment transaction")
                                        .font(.custom("Montserrat-Light", size: 10))
                                    Text("Rp. 0,-")
                                        .font(.custom("Montserrat-SemiBold", size: 10))
                                }
                                .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                            }
                            
                            // Limit Pembelian
                            VStack(alignment: .leading) {
                                Text("Limit pembelian")
                                    .font(.custom("Montserrat-Light", size: 12))
                                HStack(alignment:.top){
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .foregroundColor(limitPembelian > maxPembelian ? Color.red : Color(hex: "#232175"))
                                    
                                    TextField("0", text: self.$limitPembelianCtrl, onEditingChanged: {_ in
                                    })
                                        .onReceive(limitPembelianCtrl.publisher.collect()) {
                                            let amountString = String($0.prefix(13))
                                            let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                            self.limitPembelianCtrl = cleanAmount.thousandSeparator()
                                            self.limitPembelian = Double(cleanAmount) ?? 0
                                            self.activateData.limitPurchase = cleanAmount
                                        }
                                        .keyboardType(.decimalPad)
                                        .font(.custom("Montserrat-Bold", size: 30))
                                        .foregroundColor(limitPembelian > maxPembelian ? Color.red : Color(hex: "#232175"))
                                    
                                }
                                Divider()
                                HStack {
                                    Text("Maximum limit of purchase transaction")
                                        .font(.custom("Montserrat-Light", size: 10))
                                    Text("Rp. 10.000.000,-")
                                        .font(.custom("Montserrat-SemiBold", size: 10))
                                }
                                .foregroundColor(limitPembelian > maxPembelian ? Color.red : Color(hex: "#232175"))
                            }
                            
                            Button(action: {
                                self.activateData.cardNo = card.cardNo
                                self.activateData.maxIbftPerTrans = "0"
                                self.activateData.limitPayment = "0"
                                self.isNextRoute = true
                            }, label: {
                                Text("SAVE CHANGES".localized(language))
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                            })
                            .disabled(disabledBtn)
                            .frame(height: 50)
                            .background(disabledBtn ? Color(.lightGray) : Color(hex: "#2334D0"))
                            .cornerRadius(12)
                            
                            NavigationLink(
                                destination: CardLimitVerificationPinView(unLocked: false).environmentObject(activateData),
                                isActive: self.$isNextRoute,
                                label: {
                                    EmptyView()
                                })
                        })
                        .padding(20)
                        .padding(.top, 20)
                        .background(Color.white)
                        .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                        .padding(30)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, self.keyboardOffset)
                    .animation(.spring())
                    
                }
                .background(Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all))
                .modifier(DismissingKeyboard())
                .navigationBarTitle("Card Limit".localized(language), displayMode: .inline)
                .navigationBarItems(trailing:  NavigationLink(destination: CardManagementScreen(), label: {
                    Text("Cancel".localized(language))
                }))
                .onAppear{
                    
                    print("GET BALANCE")
                    print(card.limitOnUs)
                    self.limitPerTransaksiCtrl = card.maxIbftPerTrans!
                    self.limitPenarikanHarianCtrl = card.limitWd!
                    self.limitOnUsCtrl = card.limitOnUs!
                    self.limitPembayaranCtrl = card.limitPayment!
                    self.limitPembelianCtrl = card.limitPurchase!
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notif) in
                        let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        let height = value.height
                        self.keyboardOffset = height
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notif) in
                        self.keyboardOffset = 0
                    }
                    
                }
                
                // Background Color When Modal Showing
                if self.showingModal {
                    ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                        .edgesIgnoringSafeArea(.all)
                }
                
            }
        })
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("\(self.statusError)"),
                message: Text("\(self.messageError)"),
                dismissButton: .default(Text("Oke")))
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LimitKartuKu"))) { obj in
            print("ON RESUME")
            
            self.isLoading = true
            if let pinTrx = obj.userInfo, let info = pinTrx["pinTrx"] {
                print(info)
                self.activateData.pinTrx = info as! String
            }
            
            print(self.activateData.cardNo)
            print(self.activateData.pinTrx)
            
            updateLimitKartuKu()
        }
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            createBottomFloater()
        }
    }
    
    // MARK: - BOTTOM FLOATER FOR MESSAGE
    func createBottomFloater() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ic_check")
                    .resizable()
                    .frame(width: 80, height: 80)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                
                Text("Perubahan Limit Transaksi Kartu Anda Telah Berhasil di Simpan")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            NavigationLink(destination: BottomNavigationView()) {
                Text("Back".localized(language))
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 15)
        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    @ObservedObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.isLoading = true
        self.profileVM.getProfile { success in
            if success {
                print(self.profileVM.limitOnUs)
                self.isLoading = false
                
                self.limitPerTransaksiCtrl = self.profileVM.maxIbftPerTrans
                self.limitPenarikanHarianCtrl = self.profileVM.limitWd
                self.limitOnUsCtrl = self.profileVM.limitOnUs
                self.limitPembayaranCtrl = self.profileVM.limitPayment
                self.limitPembelianCtrl = self.profileVM.limitPurchase
            }
            
            if !success {
                self.isLoading = false
            }
        }
    }
    
    @ObservedObject var kartKuVM = KartuKuViewModel()
    func updateLimitKartuKu() {
        self.kartKuVM.updateLimitKartuKu(data: activateData) { success in
            if success {
                print("SUCCESS")
                self.isLoading = false
                self.showingModal = true
            }
            
            if !success {
                print("!SUCCESS")
                
                self.isLoading = false
                if (self.kartKuVM.code == "400") {
                    print("Error 400")
                    self.statusError = self.kartKuVM.code
                    self.messageError = "Bad Request"
                    self.showingAlert = true
                }
                
                if (self.kartKuVM.code == "401") {
                    self.statusError = self.kartKuVM.code
                    self.messageError = self.kartKuVM.message
                    self.showingAlert = true
                }
                
                if (self.kartKuVM.code == "500") {
                    self.statusError = self.kartKuVM.code
                    self.messageError = self.kartKuVM.message
                    self.showingAlert = true
                }
            }
        }
    }
}

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}

//struct CardLimitView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardLimitView(card: myCardData[0])
//    }
//}
