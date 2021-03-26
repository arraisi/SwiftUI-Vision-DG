//
//  InputPaymentByQrisView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/03/21.
//

import SwiftUI
import CodeScanner


struct InputPaymentByQrisView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var nominalTrx: String = ""
    @State var nominalTips: String = ""
    
    @State private var isShowingScanner = true
    
    @State private var qrisActive = false
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 15) {
                
                HStack {
                    Image("ic_saving_account")
                        .resizable()
                        .frame(width: 69, height: 69)
                }
                
                VStack(alignment: .center) {
                    Text("GRAMEDIA")
                        .font(.custom("Montserrat-Bold", size: 14))
                        .foregroundColor(Color("DarkStaleBlue"))
                    Text("Karawaci Kelapa Dua")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(Color("DarkStaleBlue"))
                    Text("TERMA00001")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(Color("DarkStaleBlue"))
                }
                .padding()
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Nominal Transaksi".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        HStack {
                            TextField("0", text: self.$nominalTrx)
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.07))
                        .cornerRadius(10)
                    }
                    
                    HStack {
                        Text("Tips".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        HStack {
                            TextField("0", text: self.$nominalTips)
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(Color.black.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: 170)
                        .background(Color("DarkStaleBlue").opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                }
                
                HStack {
                    Text("Persentase tips adalah 5.0% dari nominal transaksi")
                    Spacer()
                }
                .font(.custom("Montserrat-Regular", size: 10))
                .foregroundColor(Color.gray)
                
                NavigationLink(
                    destination: ChooseAccountQrisView(),
                    isActive: self.$qrisActive) {
                    EmptyView()
                }
                .isDetailLink(false)
                
                Button(action: {self.qrisActive = true}) {
                    Text("Next".localized(language))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
            }
            .padding(25) // padding content
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color("DarkStaleBlue").opacity(0.2), radius: 10)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            
            Spacer()
        }
        .onReceive(self.appState.$moveToDashboard) { value in
            if value {
                //                getCoreDataNewDevice()
                print("Move to moveToDashboard: \(value)")
                //                activateWelcomeView()
                self.qrisActive = false
                self.appState.moveToDashboard = false
            }
        }
        .navigationBarTitle("Pembayaran QRIS", displayMode: .inline)
        .padding(.vertical, 30)
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
        }
        
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        // more code to come
        print("\nresult : \(result)")
    }
}

struct InputPaymentByQrisView_Previews: PreviewProvider {
    static var previews: some View {
        InputPaymentByQrisView()
    }
}
