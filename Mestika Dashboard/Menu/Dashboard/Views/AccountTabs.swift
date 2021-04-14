//
//  AccountTabs.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import LocalAuthentication

struct AccountTabs: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Function GET USER Status */
    @StateObject var profileVM = ProfileViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @Binding var showingSettingMenu : Bool
    @State var username: String = ""
    @State var phoneNumber: String = ""
    
    /* Data Binding */
    @ObservedObject private var authVM = AuthViewModel()
    @State private var isFingerprint = false
    @State private var isNextRoute = false
    
    @State private var isShowingAlert = false
    
    @State private var forgotPasswordActived = false
    
    @State private var isLoading: Bool = true
    @State private var isShowModal: Bool = false
    @State private var biometricChanged: Bool = false
    
    /* CORE DATA */
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @FetchRequest(entity: NewDevice.entity(), sortDescriptors: []) var device: FetchedResults<NewDevice>
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                GeometryReader { geometry in
                    Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                        .frame(height: 0)
                }
                
                ZStack {
                    VStack {
                        profileInfo
                        menuGrid
                            .padding(.bottom)
                        
                    }
                }
            })
            .navigationBarHidden(true)
            
            if (self.isShowModal) {
                ModalOverlay(tapAction: { withAnimation {
                    self.isShowModal = false
                } })
                .edgesIgnoringSafeArea(.all)
            }
        }
        .popup(isPresented: $isShowModal, type: .floater(verticalPadding: 200), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            
            PopupConfirmationAuth()
                .padding(15)
            
        }
        .onReceive(self.appState.$moveToAccountTab) { moveToAccountTab in
            if moveToAccountTab {
                //                getCoreDataNewDevice()
                print("Move to moveToDashboard: \(moveToAccountTab)")
                //                activateWelcomeView()
                self.forgotPasswordActived = false
                self.appState.moveToAccountTab = false
            }
        }
        .onAppear(perform: {
            if let value = device.last?.fingerprintFlag {
                print("CORE DATA - Finger Print = \(value)")
                self.isFingerprint = value
            }
        })
    }
    
    var profileInfo: some View {
        VStack {
            HStack(alignment: .center) {
                Image("foryou-card-1")
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
                    .clipShape(Circle())
                
                if isLoading {
                    ProgressView()
                        .padding(.leading)
                } else {
                    VStack(alignment: .leading) {
                        Text("\(self.profileVM.name)")
                            .font(.custom("Montserrat-Bold", size: 22))
                            .foregroundColor(Color(hex: "#2334D0"))
                        
                        Text("+62\(self.profileVM.telepon)")
                            .font(.custom("Montserrat-SemiBold", size: 16))
                    }
                }
                
                Spacer()
            }
            .padding(.bottom)
        }
        .padding()
    }
    
    // MARK: -MENU GRID VIEW
    var menuGrid: some View {
        VStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Account".localized(language))
                            .foregroundColor(Color(hex: "#232175"))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    //                    HStack {
                    //                        VStack(alignment: .leading) {
                    //                            Text("Personal Data")
                    //                                .foregroundColor(Color(hex: "#1D2238"))
                    //                                .font(.subheadline)
                    //                                .fontWeight(.bold)
                    //                        }
                    //
                    //                        Spacer()
                    //                    }
                    //                    .padding(.vertical, 5)
                    //                    .padding(.horizontal, 20)
                    //
                    //                    Divider()
                    //                        .padding(.horizontal, 10)
                    
                    NavigationLink(destination : FormChangeAddressView()){
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Address".localized(language))
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    NavigationLink(destination : FormChangeContactView(txtPhone: self.$profileVM.telepon, txtEmail: self.$profileVM.email)){
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Contact".localized(language))
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    NavigationLink(destination : LanguageSettingScreen()){
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Language".localized(language))
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                }
                .frame(width: UIScreen.main.bounds.width - 30)
            }
            
            ZStack {
                VStack {
                    HStack {
                        Text("Security".localized(language))
                            .foregroundColor(Color(hex: "#232175"))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Toggle(
                                isOn: $isFingerprint,
                                label: {
                                    Text("Activation".localized(language) + " \(Biometric().type() == .faceID ? "Face ID" : "Finger Print")")
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                            )
                            .onChange(of: self.isFingerprint) { value in
                                
                                self.biometricChanged = value
                                
                                //perform your action here...
                                saveDataNewDeviceToCoreData()
                                if value {
                                    
                                    self.isShowModal = true
                                    
                                } else {
                                    self.authVM.disableBiometricLogin { result in
                                        
                                        print("result : \(result)")
                                        if result {
                                            print("DISABLE FINGER PRINT SUCCESS")
                                        }
                                        
                                        if !result {
                                            self.isFingerprint = true
                                            print("DISABLE FINGER PRINT FAILED")
                                            saveDataNewDeviceToCoreData()
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    NavigationLink(destination : FormChangePasswordView()) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Change Password".localized(language))
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    NavigationLink(destination : FormChangePinTransactionView()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Change PIN Transaction".localized(language))
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    ZStack {
                        NavigationLink(destination: FormInputResetNewPinScreen(cardNo: self.profileVM.cardNo), isActive: self.$forgotPasswordActived) {
                            EmptyView()
                        }
                        .isDetailLink(false)
                        
                        Button(action : {self.forgotPasswordActived=true}){
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Forgot PIN Transaction".localized(language))
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    Button(
                        action: {
                            self.isShowingAlert = true
                        },
                        label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Logout".localized(language))
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                        }
                    )
                }
                .frame(width: UIScreen.main.bounds.width - 30)
            }
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text("Are you sure you want to exit the Bank Mestika application?".localized(language)),
                primaryButton: .default(Text("YES".localized(language)), action: {
                    self.authVM.postLogout { success in
                        if success {
                            print("SUCCESS LOGOUT")
                            DispatchQueue.main.async {
                                self.appState.moveToWelcomeView = true
                            }
                        }
                    }
                }),
                secondaryButton: .cancel(Text("NO".localized(language))))
        }
        .onAppear {
            //            getProfile()
            self.profileVM.getProfile { success in
                
                if success {
                    print("\n\n\nPROFILE VM NAME : \(self.profileVM.name)\n\n\n")
                    self.isLoading = false
                }
                
                if !success {
                    self.isLoading = false
                }
            }
            getUserInfo()
        }
        
    }
    
    func PopupConfirmationAuth() -> some View {
        VStack(alignment: .leading) {
            Text("Do you want to activate this feature?".localized(language))
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 5)
            
            Text("Digital Bangking application will access the fingerprint data registered on your device".localized(language))
                .font(.custom("Montserrat-Medium", size: 14))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    
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
                    self.isShowModal = false
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
                }
                
                if !result {
                    self.isFingerprint = false
                    print("ENABLE FINGER PRINT FAILED")
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
    
    func getUserInfo() {
        self.user.forEach { (data) in
            self.username = data.namaLengkapFromNik!
            self.phoneNumber = data.noTelepon!
        }
    }
    
    func saveDataNewDeviceToCoreData()  {
        print("------SAVE ACCOUNT TO CORE DATA-------")
        
        if device.count == 0 {
            let data = NewDevice(context: managedObjectContext)
            data.fingerprintFlag = self.isFingerprint
        } else {
            device.last?.fingerprintFlag = self.isFingerprint
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
    }
}

struct AccountTabs_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabs(showingSettingMenu: .constant(false))
    }
}
