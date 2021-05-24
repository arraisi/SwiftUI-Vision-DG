//
//  BottomNavigationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import LocalAuthentication

struct BottomNavigationView: View {
    
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var appState: AppState
    @State private var isRouteTransferOnUs: Bool = false
    @State private var isRouteTransferOffUs: Bool = false
    
    @ObservedObject private var profileVM = ProfileViewModel()
    @ObservedObject private var authVM = AuthViewModel()
    
    @State private var showingSlideMenu = false
    @State private var showingSettingMenu = false
    
    @State var selected = 0
    
    @State var initialOffset: CGFloat?
    @State var offset: CGFloat?
    @State var viewIsShown: Bool = true
    
    @State var cardNo: String = ""
    @State var sourceNumber: String = ""
    
    @State var showQrCode: Bool = false
    @State private var qrisActive = false
    @State private var inboxActive: Bool = false
    
    @State private var isFingerprint: Bool = false
    @State private var isShowConfirmationBiometricAuth: Bool = false
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    /* CORE DATA */
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @FetchRequest(entity: NewDevice.entity(), sortDescriptors: []) var device: FetchedResults<NewDevice>
    
    
    var body: some View {
        ZStack {
            
            Color(hex: "#F6F8FB")
            
            NavigationLink(destination: QrisScannerView().environmentObject(appState), isActive: self.$qrisActive) {
                EmptyView()
            }
            .isDetailLink(false)
            
            ZStack {
                
                VStack {
                    appbar
                    
                    if (selected == 0) {
                        DashboardTabs(tmpMyAccount: DashboardAccountModel(), cardNo: $cardNo, sourceNumber: $sourceNumber)
                    }
                    
                    if (selected == 1) {
                        TransferTabs(cardNo: self.$cardNo, sourceNumber: self.$sourceNumber, transferOnUsActive: self.$isRouteTransferOnUs, transferOffUsActive: self.$isRouteTransferOffUs)
                    }
                    
                    if (selected == 2) {
                        HistoryTabs(cardNo: self.$cardNo, sourceNumber: self.$sourceNumber)
                    }
                    
                    if (selected == 3) {
                        AccountTabs(showingSettingMenu: self.$showingSettingMenu, isFingerprint: self.$isFingerprint, isShowModal: self.$isShowConfirmationBiometricAuth)
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
                                    self.qrisActive = true
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
            
            
            if (showingSettingMenu || isShowConfirmationBiometricAuth) {
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
                self.qrisActive = false
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
        .popup(isPresented: $isShowConfirmationBiometricAuth, type: .floater(verticalPadding: 200), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            
            PopupConfirmationBiometricAuth()
                .padding(15)
            
        }
    }
    
    // Fungsi untuk setting biometric login
    func PopupConfirmationBiometricAuth() -> some View {
        VStack(alignment: .leading) {
            Text("Do you want to activate this feature?".localized(language))
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 5)
            
            Text("Digital Bangking application will access the".localized(language) + " \(Biometric().type() == .faceID ? "Face ID" : "Finger Print") " + "data registered on your device".localized(language))
                .font(.custom("Montserrat-Medium", size: 14))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    print("\n\n\nEnable Finger Print")
                    enableBiometricLogin()
                    
                },
                label: {
                    Text("OK".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .frame(maxWidth: .infinity, minHeight: 40)
                .padding(.bottom, 5)
            
            Button(
                action: {
                    self.isFingerprint = false
                    self.isShowConfirmationBiometricAuth = false
                    saveDataNewDeviceToCoreData()
                },
                label: {
                    Text("Cancel".localized(language))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color.white)
                .cornerRadius(12)
                .frame(maxWidth: .infinity, minHeight: 40)
        }
        .padding([.top], 40)
        .padding([.bottom, .leading, .trailing], 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    // MARK: Biometric Authentication Check
    func enableBiometricLogin() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.authVM.enableBiometricLogin { result in
                print("result : \(result)")
                if result {
                    print("ENABLE FINGER PRINT SUCCESS")
                    self.isFingerprint = true
                    saveDataNewDeviceToCoreData()
                }
                
                if !result {
                    print("ENABLE FINGER PRINT FAILED")
                    self.isFingerprint = false
                    saveDataNewDeviceToCoreData()
                }
            }
            
        } else {
            
            guard let settingUrl = URL(string : "App-Prefs:") else {
                return
            }
            
            UIApplication.shared.open(settingUrl)
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
    
    func saveDataNewDeviceToCoreData()  {
        print("------SAVE ACCOUNT TO CORE DATA-------")
        
        if device.count == 0 {
            let data = NewDevice(context: managedObjectContext)
            data.fingerprintFlag = self.isFingerprint
        } else {
            device.last?.fingerprintFlag = self.isFingerprint
            print("\nDevice last finger print")
            print(device.last?.fingerprintFlag as Any)
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
    }
    // Fungsi untuk setting biometric login
    
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
            NavigationLink(
                destination: InboxView(),
                isActive: self.$inboxActive,
                label: { EmptyView() }
            )
            
            Button(action: {
                self.inboxActive = true
            }, label: {
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
