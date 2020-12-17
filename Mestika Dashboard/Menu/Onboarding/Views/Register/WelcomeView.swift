//
//  WelcomeView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 25/11/20.
//

import SwiftUI
import PopupView
import JitsiMeet

struct WelcomeView: View {
    
    init() {
        getMobileVersion()
    }
    
    fileprivate var jitsiMeetView: JitsiMeetView?
    @State var isShowJitsi: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    // Route Variables
    @State var isKetentuanViewActive: Bool = false
    @State var isLoginViewActive: Bool = false
    @State var isFirstLoginViewActive: Bool = false
    @State var isActiveRootLogin: Bool = false
    @State var isNoAtmOrRekViewActive: Bool = false
    @State var isFormPilihJenisAtm: Bool = false
    @State var isRescheduleInterview: Bool = false
    
    // View Variables
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    var registerData = RegistrasiModel()
    var loginData = LoginBindingModel()
    var productATMData = AddProductATM()
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    @State var images = ["slider_pic_1", "slider_pic_2", "slider_pic_3"]
    @State private var isFirstLogin = UserDefaults.standard.string(forKey: "isFirstLogin")
    @State private var isSchedule = UserDefaults.standard.string(forKey: "isSchedule")
    
    // Modal Variables
    @State var isShowModal = false
    @State var modalSelection = ""
    
    //    CREATED
    //    KYC_SCHEDULED
    //    KYC_WAITING
    //    WAITING
    //    ACTIVE
    //    NOT_APPROVED
//    @State var modalSelection = "KYC_WAITING"
//    @State var isShowModal = true
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Color(hex: "#232175")
                
                VStack(spacing: 10) {
                    Spacer()
                    
                    Header
                        .padding([.horizontal, .top], 20)
                    
                    Spacer()
                    
                    WelcomeViewCarousel(data: self.$images) { index in
                        print("carousel index: \(index)")
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        
                        Button(action : {
                            self.isShowModal.toggle()
//                            self.isShowJitsi = true
                        }) {
                            Text("DAFTAR")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(15)
                        .sheet(isPresented: $isShowJitsi) {
                            JitsiView()
                        }
                        
                        NavigationLink(destination: FirstLoginView().environmentObject(loginData), isActive: self.$isLoginViewActive){
                            Text("LOGIN")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                        }
                        .isDetailLink(false)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
//                .padding(.vertical, 20)
                
                
                if self.isShowModal {
                    ModalOverlay(tapAction: { withAnimation {
                        self.isShowModal = false
                    } })
                }
            }
            .navigationBarItems(trailing: EmptyView())
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .onReceive(self.appState.$moveToWelcomeView) { moveToWelcomeView in
                if moveToWelcomeView {
                    print("Move to Welcome: \(moveToWelcomeView)")
                    self.isKetentuanViewActive = false
                    self.isLoginViewActive = false
                    self.isFirstLoginViewActive = false
                    self.isNoAtmOrRekViewActive = false
                    self.isFormPilihJenisAtm = false
                    self.isRescheduleInterview = false
                    self.appState.moveToWelcomeView = false
                }
            }
            .onAppear() {
                print("APPEAR")
//                registerData.load()
                getUserStatus(deviceId: deviceId!)
            }
            .onAppear(perform: {
                let defaultOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
                    builder.serverURL = URL(string: "https://meet.jit.si")
                    builder.welcomePageEnabled = false
                }
                
                JitsiMeet.sharedInstance().defaultConferenceOptions = defaultOptions
            })
            .popup(isPresented: $isShowModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMenu()
            }
        }
    }
    
    var Header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome to")
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
    
    func popupMenu() -> some View {
        switch modalSelection {
        case "CREATED" :
            return AnyView(PopupCreated())
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
        default:
            return AnyView(ScreeningNasabahModal())
        }
    }
    
    // MARK: # Status : CREATED
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
            
            // MARK: change destination
            NavigationLink(destination: SuccessRegisterView().environmentObject(registerData)){
                Text("Halaman Submit Jadwal Videocall")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .isDetailLink(false)
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
    
    // MARK: # Status : KYC_SCHEDULED
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
                    self.isFormPilihJenisAtm = true
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
            
            NavigationLink(destination: FormPilihJenisATMView().environmentObject(productATMData).environmentObject(registerData), isActive: self.$isFormPilihJenisAtm, label: {EmptyView()})
                .isDetailLink(false)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: # Status : KYC_WAITING
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
            
            // MARK: change date from API
            Text("Tanggal : \(self.userVM.user?.scheduledDate ?? "-")")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            // MARK: change time from API
            Text("Jam : \(self.userVM.user?.scheduledHours ?? "-")")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            // MARK: change destination
            NavigationLink(destination: SuccessRegisterView().environmentObject(registerData)){
                Text("Reschedule Jadwal")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
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
    
    // MARK: # Status : WAITING
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
            
            // MARK: change destination
            Button(action:{
                self.isShowModal = false
                self.modalSelection = ""
//                self.registerData.clear()
            }, label: {
                Text("Batalkan Permohonan")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            })
            .padding(.bottom, 20)
            .cornerRadius(12)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK: # Status : ACTIVE
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
            
            // MARK: change destination
            NavigationLink(destination: FirstLoginView().environmentObject(loginData), isActive: self.$isFirstLoginViewActive){
                Text("Kembali ke halaman utama")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .isDetailLink(false)
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
    
    // MARK: # Status : NOT_APPROVED
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
            
            // MARK: change destination
            NavigationLink(destination: FirstLoginView().environmentObject(loginData), isActive: self.$isFirstLoginViewActive){
                Text("Kembali ke halaman utama")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .isDetailLink(false)
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
    
    // MARK: #OLD POPUP
    // MARK: #ScreeningNasabahModal - Popup Message Menu (Modal)
    func ScreeningNasabahModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Sebelum Memulai..!!")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text("Apakah Anda Merupakan Nasabah Bank Mestika?")
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
                self.appState.nasabahIsExisting = false
                self.isKetentuanViewActive = true
            }) {
                Text("Tidak, saya bukan")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(destination: NoAtmOrRekeningVerificationView(rootIsActive: .constant(false)).environmentObject(registerData), isActive: self.$isNoAtmOrRekViewActive) {
               EmptyView()
            }
            .isDetailLink(false)
            
            Button(action: {
                self.appState.nasabahIsExisting = true
                self.isNoAtmOrRekViewActive = true
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
    
    // MARK: #SuccsessRegisterModal - Popup Message Success (Modal)
    func SuccsessRegisterModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_highfive")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("REGISTRASI BERHASIL")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Permohonan Pembukaan Rekening Anda telah disetujui. Silahkan login untuk pertama kali.")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            NavigationLink(destination: FirstLoginView().environmentObject(loginData), isActive: self.$isFirstLoginViewActive){
                Text("Login")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .isDetailLink(false)
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
    
    // MARK: #ScheduleVideoCallModal - Popup Message Schedule Video Call (Modal)
    func ScheduleVideoCallModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_highfive")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("Jadwal Wawancara sudah diterima")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Customer Service kami akan menghubungi anda untuk melakukan konfirmasi dan aktivasi, pastikan anda available pada jam yang telah anda tentukan.")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Button(
                action: {},
                label: {
                    Text("Kembali")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
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
    
    // MARK: #ScheduleVideoCallMissedModal - Popup Message Missed Schedule (Modal)
    func ScheduleVideoCallMissedModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_group")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("REGISTRASI GAGAL")
                .fontWeight(.heavy)
                .font(.system(size: 22))
                .foregroundColor(.red)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Anda telah melewati waktu wawancara pendaftaran (Jumat 11 September 2020).")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Text("Silahkan lakukan registrasi kembali untuk mendaftar.")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Button(
                action: {},
                label: {
                    Text("Kembali ke Halaman Utama")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
            )
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
    
    // MARK: #RegisterRejectedModal - Popup Message Rejected (Modal)
    func RegisterRejectedModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_group")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("Pembukaan Rekening ditolak")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(.red)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Maaf, pembukaan rekening online Anda telah ditolak.")
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Button(
                action: {},
                label: {
                    Text("Kembali ke Halaman Utama")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
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
    
    // MARK: #RegisterApprovedModal - Popup Message Approve (Modal)
    func RegisterApprovedModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_bell")
                .resizable()
                .frame(width: 75, height: 90)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("PEMBUKAAN REKENING DISETUJUI")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Selamat pembukaan rekening baru Anda telah disetujui.")
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 10)
            
            Text("Silakan pilih tombol \"Lanjutkan\" untuk ke tahap selanjutnya")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Button(
                action: {},
                label: {
                    Text("Lanjutkan")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
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
    
    // MARK: #RegisterCreatedModal - Popup Message Create New (Modal)
    func RegisterCreatedModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_group")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("PERSETUJUAN SEDANG DALAM PROSES")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(.yellow)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Persetujuan sedang dalam proses. Hasil akan dikirim melalui SMS atau email.")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Button(
                action: {},
                label: {
                    Text("Saya Tunggu")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
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
    
    /* Funtion GET User Details Core Data */
    func getUserDetails() {
        if (user.last?.deviceId == deviceId && isFirstLogin == "true") {
            modalSelection = "SuccsessRegisterModal"
            self.isShowModal = true
        }
        
        if (user.last?.deviceId == deviceId && isSchedule == "true") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                modalSelection = "ScheduleVideoCallModal"
                self.isShowModal = true
            }
        }
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
                
                self.modalSelection = self.userVM.message
                self.isShowModal = false
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(AppState())
    }
}
