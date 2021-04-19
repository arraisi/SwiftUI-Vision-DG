//
//  QrisScannerView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 16/04/21.
//

import SwiftUI

struct QrisScannerView: View {
    
    @ObservedObject var scannerVM = ScannerViewModel()
    
    @StateObject var qrisVM = QrisViewModel()
    
    // Observable Object
    @State var qrisData = QrisModel()
    
    @State private var qrisActive = false
    
    var body: some View {
        ZStack {
            
            NavigationLink(destination: InputPaymentByQrisView().environmentObject(qrisData), isActive: self.$qrisActive) {
                EmptyView()
            }
            .isDetailLink(false)
            
            QrCodeScannerView()
                //                    .found(r: self.scannerVM.onFoundQrCode)
                .found(r: self.handleScan)
                .torchLight(isOn: self.scannerVM.torchIsOn)
                .interval(delay: self.scannerVM.scanInterval)
            
            Image("qr_code_frame")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: UIScreen.main.bounds.width - 30.0)
            
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        self.scannerVM.torchIsOn.toggle()
                    }, label: {
                        Image(systemName: self.scannerVM.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                            .imageScale(.large)
                            .foregroundColor(self.scannerVM.torchIsOn ? Color.yellow : Color.blue)
                            .padding()
                    })
                }
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("QR", displayMode: .inline)
    }

    
    func handleScan(_ code: String) {
        print("\nCode : \(code)\n")
        self.qrisData.content = code
        self.qrisVM.parseQris(data: qrisData) { success in
            
            if success {
                print(self.qrisVM.merchantName)
                print(self.qrisVM.merchantCity)
                
                self.qrisData.merchantName = self.qrisVM.merchantName
                self.qrisData.merchantCity = self.qrisVM.merchantCity
                self.qrisData.transactionAmount = self.qrisVM.transactionAmount
                self.qrisData.transactionFee = self.qrisVM.transactionFee
                
                self.qrisActive = true
            }
            
        }
        
//        self.isShowingScanner = false
        // more code to come
//        self.qrisActive = true
    }
    
}

struct QrisScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QrisScannerView()
    }
}
