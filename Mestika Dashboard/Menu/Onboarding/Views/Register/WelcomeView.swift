//
//  WelcomeView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 25/11/20.
//

import SwiftUI
import Combine
import PopupView
import JitsiMeet
import Indicators
import SystemConfiguration

struct WelcomeView: View {
    
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
    
    // Route Variable Login
    @State var isLoginViewActive: Bool = false
    @State var isFirstLoginViewActive: Bool = false
    @State var isFirstOTPLoginViewActive: Bool = false
    @State var isPasswordViewActive: Bool = false
    
    // View Variables
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @FetchRequest(entity: ScheduleInterview.entity(), sortDescriptors: [])
    var schedule: FetchedResults<ScheduleInterview>
    
    var registerData = RegistrasiModel()
    var loginData = LoginBindingModel()
    var productATMData = AddProductATM()
    
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
    
    @State var jitsiRoom = ""
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    var body: some View {
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
                            Text(NSLocalizedString("Register", comment: ""))
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
                            Text(NSLocalizedString("Login", comment: ""))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        }
                        .disabled(isLoading)
                        
                        NavigationLink(
                            destination: FirstOTPLoginView().environmentObject(registerData),
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
                            destination: FirstOTPLoginView().environmentObject(registerData),
                            isActive: self.$isFirstOTPLoginViewActive,
                            label: {}
                        )
                        .isDetailLink(false)
                        .disabled(isLoading)
                        
                        NavigationLink(
                            destination: FirstPasswordAppLoginView(),
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
            .navigationBarItems(trailing: EmptyView())
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .onReceive(self.appState.$moveToWelcomeView) { moveToWelcomeView in
                if moveToWelcomeView {
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
                    print(info)
                    self.jitsiRoom = info as! String ?? ""
                    print(jitsiRoom)
                    
                    self.isIncomingVideoCall = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("JitsiEnd"))) { obj in
                print("RECEIVED JITSI END")
                getUserStatus(deviceId: deviceId!)
            }
            .onAppear {
                getCoreDataRegister()
                getMobileVersion()
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                
                if self.isNetworkReachability(with: flags) {
                    self.isShowAlertInternetConnection = false
                } else {
                    self.isShowAlertInternetConnection = true
                }
            }
            .onAppear() {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("Detail"), object: nil, queue: .main) { (_) in
                    
                }
            }
            .fullScreenCover(isPresented: $isShowJitsi) {
                JitsiView(jitsi_room: self.$jitsiRoom)
            }
            .popup(isPresented: $isShowModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMenu()
            }
            .alert(isPresented: $showingAlert) {
                return Alert(
                    title: Text(NSLocalizedString("Message", comment: "")),
                    message: Text(self.alertMessage),
                    dismissButton: .default(Text("Oke")))
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
                Text(NSLocalizedString("Welcome to", comment: ""))
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
            return AnyView(PopupActive())
        case "NOT_APPROVED" :
            return AnyView(PopupNotApproved())
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
            
            Text(NSLocalizedString("INFORMASI SUBMIT JADWAL VIDEOCALL", comment: ""))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Anda belum melakukan submit jadwal Videocall", comment: ""))
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
                        Text(NSLocalizedString("Halaman Submit Jadwal Videocall", comment: ""))
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
                        Text(NSLocalizedString("Halaman Submit Jadwal Videocall", comment: ""))
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
            
            Text(NSLocalizedString("INFORMASI SUBMIT PRODUK ATM", comment: ""))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Anda belum melakukan submit produk dan desain ATM", comment: ""))
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
                    Text(NSLocalizedString("Halaman Submit Produk ATM", comment: ""))
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
            
            Text(NSLocalizedString("Mohon Tunggu", comment: ""))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Data Anda telah kami terima, mohon tunggu CS kami untuk menghubungi Anda pada :", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(NSLocalizedString("Tanggal", comment: ""))
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
                    Text(NSLocalizedString("Jam", comment: ""))
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
                    Text(NSLocalizedString("Reschedule Jadwal", comment: ""))
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
                    Text(NSLocalizedString("Reschedule Jadwal", comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 5)
            }
            
            if (self.registerData.isNasabahmestika == true) {
                NavigationLink(destination: PhoneOTPRegisterNasabahView(editModeForCancel: .active, rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(registerData)){
                    Text(NSLocalizedString("Batalkan Permohonan", comment: ""))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.bottom, 20)
            } else {
                NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForCancel: .active).environmentObject(registerData)){
                    Text(NSLocalizedString("Batalkan Permohonan", comment: ""))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.bottom, 20)
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
            
            Text(NSLocalizedString("Persetujuan sedang dalam proses", comment: ""))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Persetujuan sedang dalam proses. Hasil akan dikirimkan melalui SMS atau email", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: change destination
            Button(action:{
                self.isShowModal = false
            }, label: {
                Text(NSLocalizedString("Saya Tunggu", comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            })
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 5)
            
            
            if (registerData.isNasabahmestika == true) {
                NavigationLink(destination: PhoneOTPRegisterNasabahView(editModeForCancel: .active, rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(registerData)){
                    Text(NSLocalizedString("Batalkan Permohonan", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Montserrat-SemiBold", size: 13))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .padding(.bottom, 20)
                .cornerRadius(12)
            } else {
                NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForCancel: .active).environmentObject(registerData)){
                    Text(NSLocalizedString("Batalkan Permohonan", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Montserrat-SemiBold", size: 13))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .padding(.bottom, 20)
                .cornerRadius(12)
            }
            
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
            
            Text(NSLocalizedString("PEMBUKAAN REKENING DISETUJUI", comment: ""))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Selamat pembukaan rekening baru Anda telah disetujui", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: back to home
            Button(action:{
                self.isShowModal = false
            }, label: {
                Text(NSLocalizedString("Kembali ke halaman utama", comment: ""))
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
            
            Text(NSLocalizedString("PEMBUKAAN REKENING TELAH DITOLAK", comment: ""))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Maaf, pembukaan rekening online Anda telah ditolak", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    UserDefaults.standard.set("reset", forKey: "reset_register")
                },
                label: {
                    Text(NSLocalizedString("Kembali ke halaman utama", comment: ""))
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
            
            Text(NSLocalizedString("Before Starting..!!", comment: ""))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text(NSLocalizedString("Are you a customer of Bank Mestika?", comment: ""))
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
                Text(NSLocalizedString("Tidak, saya bukan", comment: ""))
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
                Text(NSLocalizedString("Ya, saya nasabah Bank Mestika", comment: ""))
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
    
    // MARK: - POPUP CHECK CONNECTION INTERNET
    func PopupNoInternetConnection() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString("Please check your internet connection", comment: ""))
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
                    self.isLoginViewActive = true
                case "LOGGED_IN":
                    self.isFirstOTPLoginViewActive = true
                case "LOGGED_OUT":
                    print("self.userVM.phoneNumber \(self.userVM.phoneNumber)")
                    registerData.noTelepon = self.userVM.phoneNumber
                    self.isFirstOTPLoginViewActive = true
                default:
                    self.isFirstLoginViewActive = true
                }
            }
            
            if !success {
                self.isFirstLoginViewActive = true
            }
        }
    }
    
    /* Function Get From Code Data to Register Data */
    func getCoreDataRegister() {
        user.forEach { (data) in
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
            self.registerData.rtrw = data.rtrw!
            
            // Data Surat Menyurat
            self.registerData.alamatKeluarga = data.alamatKeluarga!
            self.registerData.kodePosKeluarga = data.kodePosKeluarga!
            self.registerData.kecamatanKeluarga = data.kecamatanKeluarga!
            self.registerData.kelurahanKeluarga =  data.kelurahanKeluarga!
            
            self.registerData.isNasabahmestika = data.isNasabahMestika
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(AppState())
    }
}
