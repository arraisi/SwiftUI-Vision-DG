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
    @Binding var isFingerprint: Bool
    @Binding var isShowModal: Bool
    
    @State var username: String = ""
    @State var phoneNumber: String = ""
    
    /* Data Binding */
    @ObservedObject private var authVM = AuthViewModel()
    @State private var isShowingAlert = false
    @State private var isLoading: Bool = true
    
    @State private var timeLogout = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var showAlertTimeout: Bool = false
    
    @State var leftTime: Date = Date()
    
    // Route variables
    @State private var personalDataActive: Bool = false
    @State private var addressDataActive: Bool = false
    @State private var otherDataActive: Bool = false
    @State private var trxLimitActive: Bool = false
    @State private var forgotPasswordActived = false
    
    /* CORE DATA */
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @FetchRequest(entity: NewDevice.entity(), sortDescriptors: []) var device: FetchedResults<NewDevice>
    
    
    var body: some View {
        
        let tap = TapGesture()
            .onEnded { _ in
                self.getTimeoutParam()
                print("View tapped!")
            }
        
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
                            .padding(.bottom, 40)
                        
                    }
                }
            })
            .navigationBarHidden(true)
        }
        .gesture(tap)
        .onReceive(timer) { time in
            //            print(self.timeLogout)
            
            if self.timeLogout > 0 {
                self.timeLogout -= 1
            }
            
            if self.timeLogout < 1 {
                showAlertTimeout = true
                isShowingAlert = true
            }
        }
        .onReceive(self.appState.$moveToAccountTab) { moveToAccountTab in
            if moveToAccountTab {
                //                getCoreDataNewDevice()
                print("Move to moveToDashboard: \(moveToAccountTab)")
                //                activateWelcomeView()
                DispatchQueue.main.async {
                    self.addressDataActive = false
                    self.otherDataActive = false
                    self.personalDataActive = false
                    self.trxLimitActive = false
                    self.forgotPasswordActived = false
                    self.appState.moveToAccountTab = false
                }
            }
        }
        .onAppear(perform: {
            self.getTimeoutParam()
            
            if let value = device.last?.fingerprintFlag {
                print("CORE DATA - Finger Print = \(value)")
                self.isFingerprint = value
            }
            self.profileVM.getProfile { (isSuccess) in
                print("\nGet customer phoenix in account tab is success: \(isSuccess)\n")
                
                self.isLoading = false
                self.username = profileVM.name
                self.phoneNumber = profileVM.telepon
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
                    
                    // MARK: ACCOUNT TAB
                    Group {
                        NavigationLink(destination : FormChangePersonalDataView(), isActive: self.$personalDataActive){
                            EmptyView()
                        }
                        .isDetailLink(false)
                        
                        Button(action: {
                            self.personalDataActive = true
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Personal Data".localized(language))
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        })
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    // MARK: ADDRESS DATA
                    Group {
                        NavigationLink(destination : FormChangeAddressView(), isActive: self.$addressDataActive){
                            EmptyView()
                        }
                        .isDetailLink(false)
                        
                        Button(action: {
                            self.addressDataActive = true
                        }) {
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
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    // MARK: OTHER DATA
                    Group {
                        NavigationLink(destination : FormChangeOtherDataView(), isActive: self.$otherDataActive)
                        {
                            EmptyView()
                        }
                        .isDetailLink(false)
                        
                        Button(action: {
                            self.otherDataActive = true
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Other Data".localized(language))
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        })
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
                    
                    ZStack {
                        NavigationLink(
                            destination: TransactionLimitView(),
                            isActive: $trxLimitActive,
                            label: { EmptyView() }
                        ).introspectNavigationController { navController  in
                            navController.view.gestureRecognizers = []
                        }
                        
                        Button(action: {
                            self.trxLimitActive = true
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Transaction Limit".localized(language))
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        })
                    }
                    
                    
                    //                    Divider()
                    //                        .padding(.horizontal, 10)
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
                            .onTapGesture {
                                if !self.isFingerprint {
                                    self.isShowModal = true
                                } else {
                                    self.authVM.disableBiometricLogin { result in
                                        
                                        print("result : \(result)")
                                        if result {
                                            print("DISABLE FINGER PRINT SUCCESS")
                                            self.isFingerprint = false
                                            saveDataNewDeviceToCoreData()
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
                                Text("Change Transaction PIN".localized(language))
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
                                    Text("Forgot Transaction PIN".localized(language))
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
            
            if showAlertTimeout {
                
                return Alert(title: Text("Session Expired"), message: Text("You have to re-login"), dismissButton: .default(Text("OK".localized(language)), action: {
                    self.authVM.postLogout { success in
                        if success {
                            print("SUCCESS LOGOUT")
                            DispatchQueue.main.async {
                                self.appState.moveToWelcomeView = true
                            }
                        }
                    }
                }))
            }
            
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
        //        .onAppear {
        //            self.profileVM.getProfile { success in
        //
        //                if success {
        //                    print("\n\n\nPROFILE VM NAME : \(self.profileVM.name)\n\n\n")
        //                    self.isLoading = false
        //                }
        //
        //                if !success {
        //                    self.isLoading = false
        //                }
        //            }
        //            getUserInfo()
        //        }
        
    }
    
    //    func getUserInfo() {
    //        self.user.forEach { (data) in
    //            self.username = data.namaLengkapFromNik!
    //            self.phoneNumber = data.noTelepon!
    //        }
    //    }
    
    func getTimeoutParam() {
        print("GET PARAM")
        self.authVM.passwordParam() { success in
            if success {
                self.timeLogout = self.authVM.maxIdleTime
            }
        }
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
}

struct AccountTabs_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabs(showingSettingMenu: .constant(false), isFingerprint: .constant(false), isShowModal: .constant(false))
    }
}
