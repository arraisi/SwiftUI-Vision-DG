//
//  WelcomeView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 25/11/20.
//

import SwiftUI
import Combine
import PopupView
import JitsiMeetSDK
import Indicators
import SystemConfiguration

struct WelcomeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var isShowJitsi: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    // Route Variable Register
    @State var isKetentuanViewActive: Bool = false
    @State var isActiveRootLogin: Bool = false
    @State var isNoAtmOrRekViewActive: Bool = false
    @State var isFormPilihJenisAtm: Bool = false
    @State var isFormPilihJenisAtmNasabah: Bool = false
    @State var isRescheduleInterview: Bool = false
    @State var isFormPilihSchedule: Bool = false
    @State var isIncomingVideoCall: Bool = false
    @State var isFormPilihScheduleAndATM: Bool = false
    @State var isFormOTPForRescheduleActive: Bool = false
    @State var isCancelRegister: Bool = false
    
    // Route Variable Login
    @State var isLoginViewActive: Bool = false
    @State var isFirstLoginViewActive: Bool = false
    @State var isFirstOTPLoginViewActive: Bool = false
    @State var isPasswordViewActive: Bool = false
    @State var isLoginNewDevice: Bool = false
    
    var jitsiMeetView: JitsiView?
    
    // View Variables
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @FetchRequest(entity: ScheduleInterview.entity(), sortDescriptors: [])
    var schedule: FetchedResults<ScheduleInterview>
    
    @FetchRequest(entity: NewDevice.entity(), sortDescriptors: [])
    var newDevice: FetchedResults<NewDevice>
    
    var registerData = RegistrasiModel()
    var loginData = LoginBindingModel()
    var productATMData = AddProductATM()
    
    @State private var statusLogin: String = ""
    
    // Device ID
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    // Image Carousel
    @State var images = ["slider_pic_1", "slider_pic_2", "slider_pic_3"]
    
    @State private var dateInterview = "-"
    @State private var timeInterview = "-"
    
    @State var isLoading = false
    @State var showingAlert = false
    @State var alertMessage = ""
    
    // Modal Variables
    @State var isShowModal = false
    @State var modalSelection = ""
    @State var isShowAlertInternetConnection = false
    
    @State private var isShowAlert: Bool = false
    
    @State var jitsiRoom = ""
    
    @State var phoneNumber = ""
    
    @State var messageWebsocket: String = ""
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    var body: some View {
        
        let tap = TapGesture()
            .onEnded { _ in
                print("View tapped!")
                
//                let dataRoom: [String: Any] = ["room_id": "12345"]
//                NotificationCenter.default.post(name: NSNotification.Name("Detail"), object: nil, userInfo: dataRoom)
            }
        
        NavigationView {
            
            ZStack {
                
                Color(hex: "#232175")
                
                VStack(spacing: 10) {
                    Spacer()
                    
                    if (self.isLoading) {
                        LinearWaitingIndicator()
                            .animated(true)
                            .foregroundColor(.green)
                            .frame(height: 1)
                    }
                    
                    Header
                        .padding([.horizontal, .top], 20)
                    
                    Spacer()
                    
                    WelcomeViewCarousel(data: self.$images) { index in
                        print("carousel index: \(index)")
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        
                        Button(action : {
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            
                            if self.isNetworkReachability(with: flags) {
                                getUserStatus(deviceId: deviceId!)
                            } else {
                                self.isShowAlertInternetConnection = true
                            }
                            
                        }) {
                            Text("REGISTER".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        }
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(15)
                        .disabled(isLoading)
                        
                        Button(action : {
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            if self.isNetworkReachability(with: flags) {
                                //                                self.isLoginViewActive = true
                                self.getUserStatusForLogin(deviceId: deviceId!)
                            } else {
                                self.isShowAlertInternetConnection = true
                            }
                        }) {
                            Text("LOGIN".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        }
                        .disabled(isLoading)
                        
                        NavigationLink(
                            destination: FirstOTPLoginView(isNewDeviceLogin: self.$isLoginNewDevice).environmentObject(registerData),
                            isActive: self.$isLoginViewActive,
                            label: {}
                        )
                        .isDetailLink(false)
                        .disabled(isLoading)
                        
                        NavigationLink(
                            destination: FirstLoginView().environmentObject(registerData),
                            isActive: self.$isFirstLoginViewActive,
                            label: {}
                        )
                        .isDetailLink(false)
                        .disabled(isLoading)
                        
                        NavigationLink(
                            destination: FirstOTPLoginView(isNewDeviceLogin: self.$isLoginNewDevice).environmentObject(registerData),
                            isActive: self.$isFirstOTPLoginViewActive,
                            label: {}
                        )
                        .isDetailLink(false)
                        .disabled(isLoading)
                        
                        NavigationLink(
                            destination: LoginScreen(isNewDeviceLogin: .constant(false)).environmentObject(registerData),
                            isActive: self.$isPasswordViewActive,
                            label: {}
                        )
                        .isDetailLink(false)
                        .disabled(isLoading)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                
                if (self.isShowModal||self.isShowAlertInternetConnection) {
                    ModalOverlay(tapAction: { withAnimation {
                        self.isShowModal = false
                        self.isShowAlertInternetConnection = false
                    } })
                }
                
                NavigationLink(
                    destination: IncomingVideoCallView(jitsiRoom: self.$jitsiRoom),
                    isActive: self.$isIncomingVideoCall,
                    label: {}
                )
                .isDetailLink(false)
            }
            .gesture(tap)
            .navigationBarItems(trailing: EmptyView())
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .onReceive(self.appState.$moveToWelcomeView) { moveToWelcomeView in
                if moveToWelcomeView {
                    self.isShowModal = false
                    getCoreDataNewDevice()
                    print("Move to Welcome: \(moveToWelcomeView)")
                    activateWelcomeView()
                    self.appState.moveToWelcomeView = false
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("Schedule"))) { obj in
                print("RECEIVED SCHEDULE")
                if let dateInfo = obj.userInfo, let info = dateInfo["dateInterview"] {
                    print(info)
                    dateInterview = info as! String
                }
                
                if let timeInfo = obj.userInfo, let info = timeInfo["timeInterview"] {
                    print(info)
                    timeInterview = info as! String
                }
                
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("Detail"))) { obj in
                print("RECEIVED JITSI START")
                if let userInfo = obj.userInfo, let info = userInfo["room_id"] {
                    print("Ini Info \(info)")
                    
                    let foo: String? = info as? String
                    let bar = foo as Any
                    
                    if bar as? String == nil {
                        print("INFO DOANG")
                    } else {
                        self.jitsiRoom = info as! String
                        print(jitsiRoom)
                        
                        self.isIncomingVideoCall = true
                        print("VCALL")
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("JitsiEnd"))) { obj in
                print("RECEIVED JITSI END")
                jitsiMeetView?.cleanUp()
                self.isIncomingVideoCall = false
                getUserStatus(deviceId: deviceId!)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CheckWebsocket"))) { obj in
                self.messageWebsocket = "Websocket Connect"
                self.isShowAlert = true
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ErrorWebsocket"))) { obj in
                self.messageWebsocket = "Websocket Error"
                self.isShowAlert = true
            }
            .alert(isPresented: $isShowAlert) {
                return Alert(
                    title: Text("MESSAGE".localized(language)),
                    message: Text("\(self.messageWebsocket)"),
                    dismissButton: .default(Text("OK".localized(language)))
                )
            }
            .onAppear {
                getCoreDataNewDevice()
                getCoreDataRegister()
                getMobileVersion()
                //                getUserStatusKyc(deviceId: deviceId!)
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                
                if self.isNetworkReachability(with: flags) {
                    self.isShowAlertInternetConnection = false
                } else {
                    self.isShowAlertInternetConnection = true
                }
            }
            .popup(isPresented: $isShowModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMenu()
            }
            .popup(isPresented: $isShowAlertInternetConnection, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                PopupNoInternetConnection()
            }
            .introspectNavigationController { navigationController in
                self.appState.navigationController = navigationController
            }
        }
    }
    
    var Header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome to".localized(language))
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(.white)
                
                Image("logo_mestika")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .padding(.top, -2)
                
            }
            Spacer()
        }
    }
    
    // MARK: - POPUP MENU SELECTION
    func popupMenu() -> some View {
        switch modalSelection {
        case "CREATED" :
            if (self.user.first?.isNasabahMestika == true) {
                return AnyView(PopupKYCScheduled())
            } else {
                return AnyView(PopupCreated())
            }
        case "KYC_SCHEDULED" :
            return AnyView(PopupKYCScheduled())
        case "KYC_WAITING" :
            return AnyView(PopupKYCWaiting())
        case "WAITING" :
            return AnyView(PopupWaiting())
        case "ACTIVE" :
            return AnyView(ScreeningLoggedModal())
        case "NOT_APPROVED" :
            return AnyView(PopupNotApproved())
        case "LOGGED_IN" :
            return AnyView(ScreeningLoggedModal())
        case "LOGGED_OUT" :
            return AnyView(ScreeningLoggedModal())
        case "DEFAULT" :
            return AnyView(ScreeningNasabahModal())
        default:
            return AnyView(ScreeningNasabahModal())
        }
    }
    
    // MARK: - POPUP STATUS : CREATED
    func PopupCreated() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_bell")
                .resizable()
                .frame(width: 75, height: 90)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("INFORMATION SUBMIT VIDEO SCHEDULE".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("You haven't submitted Videocall schedule".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            if (self.user.last?.isNasabahMestika == true) {
                
                Button(
                    action: {
                        self.isFormPilihSchedule = true
                    },
                    label: {
                        Text("Submit Videocall Schedule".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                )
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
                
                NavigationLink(
                    destination: VerificationPINView().environmentObject(registerData).environmentObject(productATMData),
                    isActive: self.$isFormPilihSchedule,
                    label: {}
                )
                .isDetailLink(false)
                
            } else  {
                Button(
                    action: {
                        self.isFormPilihScheduleAndATM = true
                    }, label: {
                        Text("Submit Videocall Schedule".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                )
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
                
                NavigationLink(
                    destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForCreateSchedule: .active).environmentObject(registerData),
                    isActive: self.$isFormPilihScheduleAndATM, label: {}
                )
                .isDetailLink(false)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: - POPUP STATUS : KYC_SCHEDULED
    func PopupKYCScheduled() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_bell")
                .resizable()
                .frame(width: 75, height: 90)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("ATM PRODUCT SUBMIT INFORMATION".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("You haven't submitted your product and ATM design".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    if (self.user.last?.isNasabahMestika == true) {
                        self.isFormPilihJenisAtmNasabah = true
                    } else {
                        self.isFormPilihJenisAtm = true
                    }
                },
                label: {
                    Text("ATM Product Submit Page".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 20)
            
            NavigationLink(
                destination: PhoneOTPRegisterNasabahView(editModeForStatusCreated: .active, rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(registerData).environmentObject(productATMData), isActive: self.$isFormPilihJenisAtmNasabah,
                label: {})
                .isDetailLink(false)
            
            NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForChooseATM: .active).environmentObject(productATMData).environmentObject(registerData), isActive: self.$isFormPilihJenisAtm, label: {EmptyView()})
                .isDetailLink(false)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: - POPUP STATUS : KYC_WAITING
    func PopupKYCWaiting() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_cs")
                .resizable()
                .frame(width: 64, height: 90)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Please wait".localized(language))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("We have received your data, please wait for our CS to contact you at:".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Date".localized(language))
                        .frame(width: 100, alignment: .leading)
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(":")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(dateInterview == "-" ? (schedule.last?.tanggalInterview) ?? "" : dateInterview)")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                HStack {
                    Text("Time".localized(language))
                        .frame(width: 100, alignment: .leading)
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(":")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(timeInterview == "-" ? (schedule.last?.jamInterview ?? "") : timeInterview)")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
            }
            
            NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForReschedule: .active).environmentObject(registerData), isActive: self.$isFormOTPForRescheduleActive) {
                EmptyView()
            }
            .isDetailLink(false)
            
            if (self.registerData.isNasabahmestika == true) {
                NavigationLink(destination: PhoneOTPRegisterNasabahView(editModeForStatusCreated: .inactive, editModeForStatusKycWaiting: .active, rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(registerData)){
                    Text("Reschedule".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 5)
            } else {
                Button(action: {
                    self.isFormOTPForRescheduleActive.toggle()
                }){
                    Text("Reschedule".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 5)
            }
            
            if (self.registerData.isNasabahmestika == true) {
                
                Button(
                    action: {
                        self.isCancelRegister = true
                    },
                    label: {
                        Text("Cancel Request".localized(language))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                )
                .background(Color.white)
                .cornerRadius(12)
                .padding(.bottom, 20)
                
                NavigationLink(
                    destination: PhoneOTPRegisterNasabahView(editModeForCancel: .active, rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(registerData),
                    isActive: self.$isCancelRegister) {
                    EmptyView()
                }
                .isDetailLink(false)
                
                
            } else {
                
                Button(
                    action: {
                        self.isCancelRegister = true
                    },
                    label: {
                        Text("Cancel Request".localized(language))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                )
                .background(Color.white)
                .cornerRadius(12)
                .padding(.bottom, 20)
                
                NavigationLink(
                    destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForCancel: .active).environmentObject(registerData),
                    isActive: self.$isCancelRegister) {
                    EmptyView()
                }
                .isDetailLink(false)
            }
            
            NavigationLink(
                destination: SuccessRegisterView().environmentObject(registerData),
                isActive: self.$isRescheduleInterview,
                label: {}
            )
            .isDetailLink(false)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: - POPUP STATUS : WAITING
    func PopupWaiting() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_clock")
                .resizable()
                .frame(width: 91, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Approval in progress".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Approval is in process. Results will be sent via SMS or email".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: change destination
            Button(action:{
                self.isShowModal = false
            }, label: {
                Text("I wait".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            })
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 5)
            
            Text("")
                .padding(.bottom, 15)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: - POPUP STATUS : ACTIVE
    func PopupActive() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_bell")
                .resizable()
                .frame(width: 75, height: 90)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("ACCOUNT OPENING APPROVED".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Congratulations, your new account opening has been approved".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: back to home
            Button(action:{
                self.isShowModal = false
            }, label: {
                Text("Back to Main Page".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            })
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: - POPUP STATUS : NOT_APPROVED
    func PopupNotApproved() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("OPENING OF ACCOUNTS HAS DENIED".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Sorry, your online account opening has been declined".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    UserDefaults.standard.set("reset", forKey: "reset_register")
                },
                label: {
                    Text("Back to Main Page".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: - POPUP SELECTOR REGISTER NASABAH
    func ScreeningNasabahModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Before Starting..!!".localized(language))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text("Are you a customer of Bank Mestika?".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            NavigationLink(
                destination: KetentuanRegisterNonNasabahView(rootIsActive: .constant(false)).environmentObject(registerData),
                isActive: self.$isKetentuanViewActive) {
                EmptyView()
            }
            .isDetailLink(false)
            
            Button(action: {
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                if self.isNetworkReachability(with: flags) {
                    self.appState.nasabahIsExisting = false
                    self.isKetentuanViewActive = true
                } else {
                    self.isShowAlertInternetConnection = true
                }
            }) {
                Text("No, I am not".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(destination: NoAtmOrRekeningVerificationView(rootIsActive: .constant(false)).environmentObject(registerData).environmentObject(appState), isActive: self.$isNoAtmOrRekViewActive) {
                EmptyView()
            }
            .isDetailLink(false)
            
            Button(action: {
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                if self.isNetworkReachability(with: flags) {
                    self.appState.nasabahIsExisting = true
                    self.isNoAtmOrRekViewActive = true
                } else {
                    self.isShowAlertInternetConnection = true
                }
            }) {
                Text("Yes, I am a customer of Bank Mestika".localized(language))
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 30)
            .cornerRadius(12)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - POPUP SELECTOR LOGGED_IN OR LOGGED_OUT
    func ScreeningLoggedModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("You Have Registered".localized(language))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text("Please log in into your Account".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            NavigationLink(
                destination: LoginScreen(isNewDeviceLogin: .constant(false)).environmentObject(registerData),
                isActive: self.$isKetentuanViewActive) {
                EmptyView()
            }
            .isDetailLink(false)
            
            Button(action: {
                
                self.userVM.userCheck(deviceId: deviceId!) { success in
                    
                    if success {
                        print("CODE STATUS : \(self.userVM.code)")
                        print("MESSAGE STATUS : \(self.userVM.message)")
                        
                        self.statusLogin = self.userVM.message
                        
                        if (self.statusLogin == "LOGGED_IN") {
                            self.isPasswordViewActive = true
                        } else if (self.statusLogin == "LOGGED_OUT") {
                            self.isPasswordViewActive = true
                        } else {
                            self.isLoginNewDevice = false
                            
                            user.forEach { (data) in
                                registerData.noTelepon = data.noTelepon!
                            }
                            
                            self.isFirstOTPLoginViewActive = true
                        }
                    }
                    
                    if !success {
                        print("NOT SUCCESS")
                    }
                }
            }) {
                Text("LOGIN".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Text("")
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - POPUP CHECK CONNECTION INTERNET
    func PopupNoInternetConnection() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Please check your internet connection".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: change destination
            Button(
                action: {
                    self.isShowAlertInternetConnection = false
                },
                label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    /* Function Activate Popup */
    func activateWelcomeView() {
        self.isKetentuanViewActive = false
        self.isLoginViewActive = false
        self.isFirstLoginViewActive = false
        self.isFirstOTPLoginViewActive = false
        self.isPasswordViewActive = false
        self.isNoAtmOrRekViewActive = false
        self.isFormPilihJenisAtm = false
        self.isFormPilihJenisAtmNasabah = false
        self.isRescheduleInterview = false
        self.isFormPilihSchedule = false
        self.isIncomingVideoCall = false
        self.isFormPilihScheduleAndATM = false
        self.isFormOTPForRescheduleActive = false
        self.isCancelRegister = false
    }
    
    /* Function Check Network Reachability */
    func isNetworkReachability(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }
    
    /* Function GET Mobile Version */
    @ObservedObject var mobileVersionVM = MobileVersionViewModel()
    func getMobileVersion() {
        print("GET VERSION MOBILE")
        
        DispatchQueue.main.async {
            self.mobileVersionVM.getMobileVersion { success in
                
                if success {
                    print("LOADING : \(self.mobileVersionVM.isLoading)")
                    print("INI VERSION NUMBER : \(self.mobileVersionVM.versionNumber)")
                    print("INI VERSION NAME : \(self.mobileVersionVM.versionName)")
                    print("INI VERSION PATCH : \(self.mobileVersionVM.versionCodePatch)")
                    print("INI VERSION MINOR : \(self.mobileVersionVM.versionCodeMinor)")
                }
            }
        }
    }
    
    /* Function GET USER Status */
    @ObservedObject var userVM = UserRegistrationViewModel()
    func getUserStatus(deviceId: String) {
        print("GET USER STATUS")
        print("DEVICE ID : \(deviceId)")
        
        self.userVM.userCheck(deviceId: deviceId) { success in
            
            if success {
                print("CODE STATUS : \(self.userVM.code)")
                print("MESSAGE STATUS : \(self.userVM.message)")
                
                let reset = UserDefaults.standard.string(forKey: "reset_register")
                
                if (reset == "reset") {
                    self.modalSelection = "DEFAULT"
                    self.isShowModal = true
                } else {
                    self.modalSelection = self.userVM.message
                    self.isShowModal = true
                }
            }
            
            if !success {
                self.modalSelection = "DEFAULT"
                self.isShowModal = true
            }
        }
    }
    
    /* Function GET USER Status For Login */
    func getUserStatusForLogin(deviceId: String) {
        print("GET USER STATUS")
        print("DEVICE ID : \(deviceId)")
        
        self.userVM.userCheck(deviceId: deviceId) { success in
            
            if success {
                print("CODE STATUS : \(self.userVM.code)")
                print("MESSAGE STATUS : \(self.userVM.message)")
                
                switch userVM.message {
                case "ACTIVE":
                    self.isLoginNewDevice = false
                    user.forEach { (data) in
                        registerData.noTelepon = data.noTelepon!
                    }
                    print(registerData.noTelepon)
                    self.isFirstOTPLoginViewActive = true
                    print("CASE ACTIVE")
                case "LOGGED_IN":
                    self.isPasswordViewActive = true
                    print("CASE LOGGED_IN")
                case "LOGGED_OUT":
                    print("self.userVM.phoneNumber \(self.userVM.phoneNumber)")
                    self.isPasswordViewActive = true
                    print("CASE LOGGED_OUT")
                default:
                    print("USER NOT FOUND")
                    self.isLoginNewDevice = true
                    self.isFirstLoginViewActive = true
                }
            }
            
            if !success {
                self.isFirstLoginViewActive = true
            }
        }
    }
    
    /* Function GET USER Status For KYC STATUS */
    func getUserStatusKyc(deviceId: String) {
        print("GET USER STATUS")
        print("DEVICE ID : \(deviceId)")
        
        self.userVM.userCheck(deviceId: deviceId) { success in
            
            if success {
                print("CODE STATUS : \(self.userVM.code)")
                print("MESSAGE STATUS : \(self.userVM.message)")
                
                _ = UserDefaults.standard.string(forKey: "reset_register")
                
                self.statusLogin = self.userVM.message
                
                if (self.userVM.message == "KYC_WAITING" || self.userVM.message == "WAITING" || self.userVM.message == "ACTIVE") {
                    self.modalSelection = self.userVM.message
                    self.isShowModal = true
                }
            }
            
            if !success {
                self.modalSelection = "DEFAULT"
                self.isShowModal = true
            }
        }
    }
    
    /* Function Get From Code Data to Register Data */
    func getCoreDataRegister() {
        user.forEach { (data) in
            self.phoneNumber = data.noTelepon!
            self.registerData.nik = data.nik!
            self.registerData.noTelepon = data.noTelepon!
            self.registerData.email = data.email!
            self.registerData.pekerjaanId = Int(data.pekerjaanId)
            self.registerData.pekerjaan = data.pekerjaan!
            
            // Data ATM
            self.registerData.atmOrRekening = data.atmOrRekening!
            self.registerData.noAtm = data.noAtm!
            self.registerData.noRekening = data.noRekening!
            self.registerData.accNo = data.accNo!
            
            // Data From NIK
            self.registerData.namaLengkapFromNik = data.namaLengkapFromNik!
            self.registerData.nomorKKFromNik = data.nomorKKFromNik!
            self.registerData.jenisKelaminFromNik = data.jenisKelaminFromNik!
            self.registerData.tempatLahirFromNik = data.tempatLahirFromNik!
            self.registerData.tanggalLahirFromNik = data.tanggalLahirFromNik!
            self.registerData.agamaFromNik = data.agamaFromNik!
            self.registerData.statusPerkawinanFromNik = data.statusPerkawinanFromNik!
            self.registerData.pendidikanFromNik = data.pendidikanFromNik!
            self.registerData.jenisPekerjaanFromNik = data.jenisPekerjaanFromNik!
            self.registerData.namaIbuFromNik = data.namaIbuFromNik!
            self.registerData.statusHubunganFromNik = data.statusHubunganFromNik!
            
            // Data Perusahaan
            self.registerData.namaPerusahaan = data.namaPerusahaan!
            self.registerData.alamatPerusahaan = data.alamatPerusahaan!
            self.registerData.kodePos = data.kodePos!
            self.registerData.kecamatan = data.kecamatan!
            self.registerData.kelurahan = data.kelurahan!
//            self.registerData.rtrw = data.rtrw!
            
            // Data Surat Menyurat
            self.registerData.alamatKeluarga = data.alamatKeluarga!
            self.registerData.kodePosKeluarga = data.kodePosKeluarga!
            self.registerData.kecamatanKeluarga = data.kecamatanKeluarga!
            self.registerData.kelurahanKeluarga =  data.kelurahanKeluarga!
            
            self.registerData.isNasabahmestika = data.isNasabahMestika
        }
    }
    
    func getCoreDataNewDevice() {
        newDevice.forEach { (data) in
            if let telepon = data.noTelepon {
                self.phoneNumber = telepon
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(AppState())
    }
}
