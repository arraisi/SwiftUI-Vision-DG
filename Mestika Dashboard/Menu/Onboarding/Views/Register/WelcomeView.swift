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
    
    // Route Variables
    @State var isKetentuanViewActive: Bool = false
    @State var isLoginViewActive: Bool = false
    @State var isFirstLoginViewActive: Bool = false
    @State var isActiveRootLogin: Bool = false
    @State var isNoAtmOrRekViewActive: Bool = false
    @State var isFormPilihJenisAtm: Bool = false
    @State var isFormPilihJenisAtmNasabah: Bool = false
    @State var isRescheduleInterview: Bool = false
    @State var isFormPilihSchedule: Bool = false
    @State var isIncomingVideoCall: Bool = false
    @State var isFormPilihScheduleAndATM: Bool = false
    
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
                                self.isLoginViewActive = true
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
                        
                        NavigationLink(destination: FirstLoginView().environmentObject(loginData), isActive: self.$isLoginViewActive, label: {})
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
//                self.appState.moveToWelcomeView = true
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
                    title: Text("Message"),
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
            
            Text("INFORMASI SUBMIT JADWAL VIDEOCALL")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Anda belum melakukan submit jadwal Videocall")
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
                        Text("Halaman Submit Jadwal Videocall")
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
                        Text("Halaman Submit Jadwal Videocall")
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
            
            Text("INFORMASI SUBMIT PRODUK ATM")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Anda belum melakukan submit produk dan desain ATM")
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
                    Text("Halaman Submit Produk ATM")
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
            
            Text("Mohon Tunggu")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Data Anda telah kami terima, mohon tunggu CS kami untuk menghubungi Anda pada :")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Tanggal")
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
                    Text("\(self.schedule.last?.tanggalInterview ?? "")")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                HStack {
                    Text("Jam")
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
                    Text("\(self.schedule.last?.jamInterview ?? "")")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
            }
            
            NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForReschedule: .active).environmentObject(registerData)){
                Text("Reschedule Jadwal")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 5)
            
            NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForCancel: .active).environmentObject(registerData)){
                Text("Batalkan Permohonan")
                    .foregroundColor(Color(hex: "#2334D0"))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.bottom, 20)
            
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
            
            Text("Persetujuan sedang dalam proses")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Persetujuan sedang dalam proses. Hasil akan dikirimkan melalui SMS atau email")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: change destination
            Button(action:{
                self.isShowModal = false
            }, label: {
                Text("Saya Tunggu")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            })
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 5)
            
            NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForCancel: .active).environmentObject(registerData)){
                Text("Batalkan Permohonan")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 20)
            .cornerRadius(12)
            
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
            
            Text("PEMBUKAAN REKENING DISETUJUI")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Selamat pembukaan rekening baru Anda telah disetujui")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: back to home
            Button(action:{
                self.isShowModal = false
            }, label: {
                Text("Kembali ke halaman utama")
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
            
            Text("PEMBUKAAN REKENING TELAH DITOLAK")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Maaf, pembukaan rekening online Anda telah ditolak")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    UserDefaults.standard.set("reset", forKey: "reset_register")
                },
                label: {
                    Text("Kembali ke halaman utama")
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
                Text("Tidak, saya bukan")
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
                Text("Ya, saya nasabah Bank Mestika")
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
            
            Text("Please check your internet connection")
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
        self.isNoAtmOrRekViewActive = false
        self.isFormPilihJenisAtm = false
        self.isFormPilihJenisAtmNasabah = false
        self.isRescheduleInterview = false
        self.isFormPilihSchedule = false
        self.isIncomingVideoCall = false
        self.isFormPilihScheduleAndATM = false
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
