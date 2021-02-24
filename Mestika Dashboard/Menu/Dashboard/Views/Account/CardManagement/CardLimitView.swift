//
//  LimitCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 06/11/20.
//

import SwiftUI

struct CardLimitView: View {
    
    @State var limitPerTransaksi: Double = 0
    @State var limitPerHari: Double = 20000000
    
    @State var limitPerTransaksiCtrl: String = ""
    
    let maxTransaksi: Double = 50000000
    let maxPenarikanHarian: Double = 20000000
    
    @State private var keyboardOffset: CGFloat = 0
    
    var card: KartuKuDesignViewModel
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    CardView(card: card, cardWidth: UIScreen.main.bounds.width - 60, cardHeight: 202, showContent: true)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    
                    VStack(alignment: .leading, spacing: 30, content: {
                        
                        Text("Limit Kartu")
                            .font(.custom("Montserrat-SemiBold", size: 15))
                        
                        // Limit per Transaksi
                        VStack(alignment: .leading) {
                            Text("per Transaksi (Debit Card)")
                                .font(.custom("Montserrat-Light", size: 12))
                            HStack(alignment:.top){
                                Text("Rp.")
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                
                                TextField("0", text: self.$limitPerTransaksiCtrl, onEditingChanged: {_ in })
                                    .onReceive(limitPerTransaksiCtrl.publisher.collect()) {
                                        let amountString = String($0.prefix(13))
                                        let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                        self.limitPerTransaksiCtrl = cleanAmount.thousandSeparator()
                                        self.limitPerTransaksi = Double(cleanAmount)!
                                    }
                                    .keyboardType(.decimalPad)
                                    .font(.custom("Montserrat-Bold", size: 30))
                                    .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                                
                            }
                            Divider()
                            HStack {
                                Text("Maximal limit per Transaksi")
                                    .font(.custom("Montserrat-Light", size: 10))
                                Text("Rp. 50.000.000,-")
                                    .font(.custom("Montserrat-SemiBold", size: 10))
                            }
                            .foregroundColor(limitPerTransaksi > maxTransaksi ? Color.red : Color(hex: "#232175"))
                        }
                        
                        // Maximal limit penarikan per Hari
                        VStack(alignment: .leading) {
                            
                            Text("per Transaksi (Debit Card)")
                                .font(.custom("Montserrat-Light", size: 12))
                            HStack(alignment:.top){
                                Text("Rp.")
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .foregroundColor(limitPerHari > maxPenarikanHarian ? Color.red : Color(hex: "#232175"))
                                
                                TextField("", value: $limitPerHari,
                                          formatter: NumberFormatter.decimal) { (value) in
                                    
                                    print("onChange : \(value)")
                                } onCommit: {
                                    print("onCommit : \(limitPerTransaksi)")
                                    
                                }.keyboardType(.decimalPad)
                                .font(.custom("Montserrat-Bold", size: 30))
                                .foregroundColor(limitPerHari > maxPenarikanHarian ? Color.red : Color(hex: "#232175"))
                            }
                            Divider()
                            HStack {
                                Text("Maximal limit penarikan harian")
                                    .font(.custom("Montserrat-Light", size: 10))
                                Text("Rp. 20.000.000,-")
                                    .font(.custom("Montserrat-SemiBold", size: 10))
                            }
                            .foregroundColor(limitPerHari > maxPenarikanHarian ? Color.red : Color(hex: "#232175"))
                        }
                        
                        NavigationLink(
                            destination: PINConfirmationView(key: "123456", pin: "", nextView: AnyView(CardLimitView(card: card, showingModal: true))),
                            label: {
                                Text("SIMPAN PERUBAHAN")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                            })
                            .frame(height: 50)
                            .background(Color(hex: "#2334D0"))
                            .cornerRadius(12)
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
            .navigationBarTitle("Limit Kartu", displayMode: .inline)
            .navigationBarItems(trailing:  NavigationLink(destination: CardManagementScreen(), label: {
                Text("Cancel")
            }))
            .onAppear{
                
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
                
                Text("Perubahan Limit Transaksi Kartu Anda Telah Berhasil di Simpan.")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            NavigationLink(destination: BottomNavigationView()) {
                Text("KEMBALI")
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
