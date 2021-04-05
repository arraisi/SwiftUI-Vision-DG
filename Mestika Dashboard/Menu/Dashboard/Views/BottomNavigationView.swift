//
//  BottomNavigationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import CodeScanner

struct BottomNavigationView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var isRouteTransferOnUs: Bool = false
    @State private var isRouteTransferOffUs: Bool = false
    
    @ObservedObject private var profileVM = ProfileViewModel()
    
    @State private var showingSlideMenu = false
    @State private var showingSettingMenu = false
    
    @State var selected = 0
    
    @State var initialOffset: CGFloat?
    @State var offset: CGFloat?
    @State var viewIsShown: Bool = true
    
    @State var cardNo: String = ""
    @State var sourceNumber: String = ""
    
    @State var showQrCode: Bool = false
    
    @State private var isShowingScanner = false
    
    @State private var qrisActive = false
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        // more code to come
        print("\nresult : \(result)")
        self.qrisActive = true
    }
    
    var body: some View {
        ZStack {
            
            Color(hex: "#F6F8FB")
            
            NavigationLink(destination: InputPaymentByQrisView().environmentObject(appState), isActive: self.$qrisActive) {
                EmptyView()
            }
            
            ZStack {
                
                VStack {
                    appbar
                    
                    if (selected == 0) {
                        DashboardTabs(cardNo: $cardNo, sourceNumber: $sourceNumber)
                    }
                    
                    if (selected == 1) {
                        TransferTabs(cardNo: self.$cardNo, sourceNumber: self.$sourceNumber, transferOnUsActive: self.$isRouteTransferOnUs, transferOffUsActive: self.$isRouteTransferOffUs)
                    }
                    
                    if (selected == 2) {
                        HistoryTabs(cardNo: self.$cardNo, sourceNumber: self.$sourceNumber)
                    }
                    
                    if (selected == 3) {
                        AccountTabs(showingSettingMenu: self.$showingSettingMenu)
                    }
                    
                    if (selected == 4) {
                        PaymentTransactionTabs()
                    }
                    Spacer()
                }
                
                if (viewIsShown) {
                    VStack {
                        Spacer()
                        ZStack(alignment: .bottom){
                            
                            CustomBottomNavigationView(selected: self.$selected)
                                //                                .padding(.top, 5)
                                .padding(.horizontal, 20)
                                .background(
                                    CurvedShape()
                                )
                            
                            VStack {
                                Button(action: {
                                    
                                    //                                    selected = 4
                                    // temporary qris
                                    self.isShowingScanner = true
                                    print("\n\(selected)")
                                }) {
                                    Image("ic_dashboard")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .padding(18)
                                    
                                }
                                .background(selected == 4 ? Color(hex: "#2334D0") : Color(hex: "#C0C0C0"))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                
                                Text("Buy & Pay")
                                    .foregroundColor(self.selected == 4 ? Color(hex: "#2334D0") : .white)
                                    .font(.system(size: 12))
                            }
                            .offset(y: -5)
                            
                        }
                        .animation(.easeIn)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .onPreferenceChange(OffsetKey.self) {
                if self.initialOffset == nil || self.initialOffset == 0 {
                    self.initialOffset = $0
                }
                
                self.offset = $0
                
                guard let initialOffset = self.initialOffset,
                      let offset = self.offset else {
                    return
                }
                
                
                if(initialOffset > offset){
                    self.viewIsShown = false
                    print("hide")
                } else {
                    self.viewIsShown = true
                    print("show")
                }
            }
            
            
            if (showingSettingMenu) {
                ModalOverlay(tapAction: { withAnimation { self.showingSettingMenu = false } })
                    .edgesIgnoringSafeArea(.all)
            }
            
            if showingSettingMenu {
                withAnimation {
                    PopoverSettingsView()
                        .animation(.easeIn)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .onAppear {
            self.profileVM.getProfile { result in
                self.cardNo = self.profileVM.cardNo
                self.sourceNumber = self.profileVM.accountNumber
                print("\n\n\nPROFILE VM NAME : \(self.profileVM.name)\n\n\n")
            }
        }
        .onReceive(self.appState.$moveToTransfer) { moveToTransfer in
            if moveToTransfer {
                print("Move to Transfer: \(moveToTransfer)")
                self.selected = 0
                self.isRouteTransferOnUs = false
                self.isRouteTransferOffUs = false
                self.appState.moveToTransfer = false
                
            }
        }
        .sheet(isPresented: self.$showQrCode, content: {
            
            Image(uiImage: generateQRCode(from: "123"))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
        })
        .sheet(isPresented: self.$isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var appbar: some View {
        VStack {
            ZStack{ Color(hex: "#232175") }.frame(height: 40)
            Spacer().frame(height: 10)
            HStack {
                Spacer()
                navBarItem
            }
        }
        .padding(.bottom, 10)
    }
    
    var navBarItem: some View {
        HStack(spacing: 30) {
            //            NavigationLink(destination: NotificationScreen(), label: {
            //                Image("ic_bell")
            //            })
            Button(action: {}, label: {
                Image("ic_bell")
            })
            Button(action: {
                self.showQrCode = true
            }, label: {
                Image("ic_qrcode")
            })
        }
        .padding(.horizontal)
    }
    
}

struct CurvedShape : View {
    var body : some View{
        
        Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 55))
            
            path.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2, y: 55), radius: 34, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
            
            path.addLine(to: CGPoint(x: 0, y: 55))
            
        }.fill(Color.white)
        .rotationEffect(.init(degrees: 180))
    }
}


class BottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        BottomNavigationView().previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
    
    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: BottomNavigationView())
    }
    #endif
}
