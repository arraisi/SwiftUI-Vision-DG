//
//  LimitCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 06/11/20.
//

import SwiftUI

struct CardLimitView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var isLoading: Bool = false
    @State private var statusError: String = ""
    @State private var messageError: String = ""
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Observable Object
    @State var activateData = LimitKartuKuModel()
    
    @State private var pinActive: Bool = false
    @State private var wrongPin: Bool = false
    
    @State var limitPerTransaksi: Double = 0
    @State var limitPerHari: Double = 0
    @State var limitPenarikanHarian: Double = 0
    @State var limitPembayaran: Double = 0
    @State var limitTransferOnUs: Double = 0
    @State var limitPembelian: Double = 0
    @State var limitIbft: Double = 0
    
    @State var limitPerTransaksiCtrl: String = "0"
    @State var limitPenarikanHarianCtrl: String = "0"
    @State var limitOnUsCtrl: String = "0"
    @State var limitPembayaranCtrl: String = "0"
    @State var limitPembelianCtrl: String = "0"
    @State var limitIbftCtrl: String = "0"
    
    @State var maxTransaksi: Double = 100000000
    @State var maxPenarikanHarian: Double = 100000000
    @State var maxTransferOnUs: Double = 100000000
    @State var maxPembelian: Double = 100000000
    @State var maxPembayaran: Double = 100000000
    @State var maxIbft: Double = 100000000
    
    @State var maxLimitPerTransaksi: String = ""
    @State var maxLimitPenarikan: String = ""
    @State var maxLimitOnUs: String = ""
    @State var maxLimitPembayaran: String = ""
    @State var maxLimitPembelian: String = ""
    @State var maxLimitIbft: String = ""
 
    @State private var keyboardOffset: CGFloat = 0
    
    @State var isNextRoute: Bool = false
    
    var card: KartuKuDesignViewModel
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showingAlert = false
    
    private var disabledBtn: Bool {
        limitPenarikanHarian > maxPenarikanHarian || limitPembelian > maxPembelian || limitTransferOnUs > maxTransferOnUs || limitIbft > maxIbft
    }
    
    var body: some View {
        if pinActive {
            
            CardLimitPinView(wrongPin: $wrongPin) { pin in
                self.activateData.pinTrx = pin
                updateLimitKartuKu()
            }
            
        } else {
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
                                            .onReceive(limitPerTransaksiCtrl.publisher.collect()) {
                                                let amountString = String($0.prefix(13))
                                                let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                                self.limitPerTransaksiCtrl = cleanAmount.thousandSeparator()
                                                self.limitPerTransaksi = Double(cleanAmount) ?? 0
                                                self.activateData.maxIbftPerTrans = cleanAmount
                                                
                                                self.activateData.maxIbftPerTrans = cleanAmount
                                                
                                                if (limitPerTransaksi > maxTransaksi) {
                                                    self.limitPerTransaksiCtrl = self.maxLimitPerTransaksi.thousandSeparator()
                                                }
                                            }
                                            .keyboardType(.decimalPad)
                                            .font(.custom("Montserrat-Bold", size: 30))
                                            .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("Maximum limit of ibft transaction")
                                            .font(.custom("Montserrat-Light", size: 10))
                                        Text("Rp. \(self.maxLimitPerTransaksi.thousandSeparator()),-")
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
                                        .onChange(of: limitPenarikanHarianCtrl) {
                                            print($0)
                                            
                                            let cleanAmount = $0.replacingOccurrences(of: ".", with: "")
                                            self.limitPenarikanHarianCtrl = cleanAmount.thousandSeparator()
                                            self.limitPenarikanHarian = Double(cleanAmount) ?? 0
                                            self.activateData.limitWd = cleanAmount
                                            
                                            self.activateData.limitWd = cleanAmount
                                            
                                            if (limitPenarikanHarian > maxPenarikanHarian) {
                                                self.limitPenarikanHarianCtrl = self.maxLimitPenarikan.thousandSeparator()
                                            }
                                        }
                                            .keyboardType(.decimalPad)
                                            .font(.custom("Montserrat-Bold", size: 30))
                                            .foregroundColor(limitPenarikanHarian > maxPenarikanHarian ? Color.red : Color(hex: "#232175"))
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("Maximum limit of withdraw transactions")
                                            .font(.custom("Montserrat-Light", size: 10))
                                        Text("Rp. \(self.maxLimitPenarikan.thousandSeparator()),-")
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
                                                
                                                self.activateData.limitOnUs = cleanAmount
                                                
                                                if (limitTransferOnUs > maxTransferOnUs) {
                                                    self.limitOnUsCtrl = self.maxLimitOnUs.thousandSeparator()
                                                }
                                            }
                                            .keyboardType(.decimalPad)
                                            .font(.custom("Montserrat-Bold", size: 30))
                                            .foregroundColor(limitTransferOnUs > maxTransferOnUs ? Color.red : Color(hex: "#232175"))
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("Maximum limit of transfer on us")
                                            .font(.custom("Montserrat-Light", size: 10))
                                        Text("Rp. \(self.maxLimitOnUs.thousandSeparator()),-")
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
                                            .foregroundColor(limitPembayaran > maxPembayaran ? Color.red : Color(hex: "#232175"))
                                        
                                        TextField("0", text: self.$limitPembayaranCtrl, onEditingChanged: {_ in
                                        })
                                            .onReceive(limitPembayaranCtrl.publisher.collect()) {
                                                let amountString = String($0.prefix(13))
                                                let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                                self.limitPembayaranCtrl = cleanAmount.thousandSeparator()
                                                self.limitPembayaran = Double(cleanAmount) ?? 0
                                                
                                                
                                                if (cleanAmount == "") {
                                                    self.activateData.limitPayment = "0"
                                                } else {
                                                    self.activateData.limitPayment = cleanAmount
                                                }
                                            
                                                
                                                if (limitPembayaran > maxPembayaran) {
                                                    self.limitPembayaranCtrl = self.maxLimitPembayaran.thousandSeparator()
                                                }
                                            }
                                            .keyboardType(.decimalPad)
                                            .font(.custom("Montserrat-Bold", size: 30))
                                            .foregroundColor(limitPembayaran > maxPembayaran ? Color.red : Color(hex: "#232175"))
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("Maximum limit of payment transaction")
                                            .font(.custom("Montserrat-Light", size: 10))
                                        Text("Rp. \(self.maxLimitPembayaran.thousandSeparator()),-")
                                            .font(.custom("Montserrat-SemiBold", size: 10))
                                    }
                                    .foregroundColor(limitPembayaran > maxPembayaran ? Color.red : Color(hex: "#232175"))
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
                                                
                                                self.activateData.limitPurchase = cleanAmount
                                                
                                                if (limitPembelian > maxPembelian) {
                                                    self.limitPembelianCtrl = self.maxLimitPembelian.thousandSeparator()
                                                }
                                            }
                                            .keyboardType(.decimalPad)
                                            .font(.custom("Montserrat-Bold", size: 30))
                                            .foregroundColor(limitPembelian > maxPembelian ? Color.red : Color(hex: "#232175"))
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("Maximum limit of purchase transaction")
                                            .font(.custom("Montserrat-Light", size: 10))
                                        Text("Rp. \(self.maxLimitPembelian.thousandSeparator()),-")
                                            .font(.custom("Montserrat-SemiBold", size: 10))
                                    }
                                    .foregroundColor(limitPembelian > maxPembelian ? Color.red : Color(hex: "#232175"))
                                }
                                
                                // Limit IBFT
                                VStack(alignment: .leading) {
                                    Text("Limit ibft")
                                        .font(.custom("Montserrat-Light", size: 12))
                                    HStack(alignment:.top){
                                        Text("Rp.")
                                            .font(.custom("Montserrat-Bold", size: 20))
                                            .foregroundColor(limitIbft > maxIbft ? Color.red : Color(hex: "#232175"))
                                        
                                        TextField("0", text: self.$limitIbftCtrl, onEditingChanged: {_ in
                                        })
                                            .onReceive(limitIbftCtrl.publisher.collect()) {
                                                let amountString = String($0.prefix(13))
                                                let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                                self.limitIbftCtrl = cleanAmount.thousandSeparator()
                                                self.limitIbft = Double(cleanAmount) ?? 0
                                                self.activateData.limitIbft = cleanAmount
                                                
                                                self.activateData.limitIbft = cleanAmount
                                                
                                                if (limitIbft > maxIbft) {
                                                    self.limitIbftCtrl = self.maxLimitIbft.thousandSeparator()
                                                }
                                            }
                                            .keyboardType(.decimalPad)
                                            .font(.custom("Montserrat-Bold", size: 30))
                                            .foregroundColor(limitPembelian > maxPembelian ? Color.red : Color(hex: "#232175"))
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("Maximum limit of ibft transaction")
                                            .font(.custom("Montserrat-Light", size: 10))
                                        Text("Rp. \(self.maxLimitIbft.thousandSeparator()),-")
                                            .font(.custom("Montserrat-SemiBold", size: 10))
                                    }
                                    .foregroundColor(limitIbft > maxIbft ? Color.red : Color(hex: "#232175"))
                                }
                                
                                Button(action: {
                                    self.activateData.cardNo = card.cardNo ?? ""
                                    self.activateData.maxIbftPerTrans = "0"
                                    
                                    self.pinActive = true
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
                    .onAppear{
                        
                        self.getLimitTrx()
                        
                        print("GET BALANCE")
                        
                        self.limitPerTransaksiCtrl = card.maxIbftPerTrans ?? "0"
                        self.limitPenarikanHarianCtrl = card.limitWd ?? "0"
                        self.limitOnUsCtrl = card.limitOnUs ?? "0"
                        self.limitPembayaranCtrl = card.limitPayment ?? "0"
                        self.limitPembelianCtrl = card.limitPurchase ?? "0"
                        self.limitIbftCtrl = card.limitIbft ?? "0"
                        
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
                        ModalOverlay(tapAction: { withAnimation { } })
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                }
            })
            .alert(isPresented: $showingAlert) {
                return Alert(
                    title: Text("\(self.statusError)"),
                    message: Text("\(self.messageError)"),
                    dismissButton: .default(Text("OK".localized(language))))
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
            
            Button(
                action: {
                    self.appState.moveToDashboard = true
                },
                label: {
                    Text("Back".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 15)
        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    @ObservedObject var limitTrxVM = TransferViewModel()
    func getLimitTrx() {
        print("Class Code --> \(card.classCode)")
        self.isLoading = true
        self.limitTrxVM.getLimitTransaction(classCode: card.classCode) { success in
            
            if success {
                print("Dapet Limit TRX")
                self.isLoading = false
                
                self.maxLimitPerTransaksi = self.limitTrxVM.limitIbftPerTrx
                self.maxTransaksi = Double(limitTrxVM.limitIbftPerTrx) ?? 0
                
                self.maxLimitPenarikan = self.limitTrxVM.limitPenarikanHarian
                self.maxPenarikanHarian = Double(limitTrxVM.limitPenarikanHarian) ?? 0
                
                self.maxLimitOnUs = self.limitTrxVM.limitOnUs
                self.maxTransferOnUs = Double(limitTrxVM.limitOnUs) ?? 0
                
                self.maxLimitPembayaran = self.limitTrxVM.limitPembayaran
                self.maxPembayaran = Double(limitTrxVM.limitPembayaran) ?? 0
                
                self.maxLimitPembelian = self.limitTrxVM.limitPembelian
                self.maxPembelian = Double(limitTrxVM.limitPembelian) ?? 0
                
                self.maxLimitIbft = self.limitTrxVM.limitIbft
                self.maxIbft = Double(limitTrxVM.limitIbft) ?? 0
            }
            
            if !success {
                print("Gagal Dapet Limit Trx")
                self.isLoading = false
            }
        }
    }
    
    @ObservedObject var kartKuVM = KartuKuViewModel()
    func updateLimitKartuKu() {
        self.isLoading = true
        self.kartKuVM.updateLimitKartuKu(data: activateData) { success in
            if success {
                print("SUCCESS")
                self.pinActive = false
                
                self.isLoading = false
                self.showingModal = true
            }
            
            if !success {
                print("!SUCCESS")
                self.pinActive = false
                
                self.isLoading = false
                if (self.kartKuVM.code == "403") {
                    print("Error 403")
                    self.statusError = self.kartKuVM.code
                    self.messageError = "Pin Transaksi Salah"
                    self.showingAlert = true
                }
                
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
