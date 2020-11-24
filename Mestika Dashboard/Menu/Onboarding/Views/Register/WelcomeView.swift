//
//  RegisterView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 23/09/20.
//

import SwiftUI
import PopupView
import SystemConfiguration
import SwiftUIX
import Introspect

struct WelcomeView: View {
    
    @EnvironmentObject var appState: AppState
    @State var isWelcomeViewActive: Bool = false
    
    /* For Check Internet Connection */
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    
    @State var showLogin = false
    @State var showRegisterNasabah = false
    @State var showRegisterNonNasabah = false
    
    /* Routing Variable */
    @State var routeToLogin: Bool = false
    @State var routeToPilihDesainKartuATM: Bool = false
    @State var isActiveForNonNasabahPage : Bool = false
    @State var isActiveForNasabahPage : Bool = false
    @State var isActiveRoot : Bool = false
    @State var isActiveRootLogin : Bool = false
    
    var registerData = RegistrasiModel()
    var loginData = LoginBindingModel()
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    @State private var isFirstLogin = UserDefaults.standard.string(forKey: "isFirstLogin")
    @State private var isSchedule = UserDefaults.standard.string(forKey: "isSchedule")
    
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    @State var isViewActivity: Bool = false
    
    /* Boolean for Show Modal & Alert */
    @State var showingModalMenu = false
    @State var showingModalCreatedNew = false
    @State var showingModalVideoCallSchedule = false
    @State var showingModalDebitCreated = false
    @State var showingModalVideoCallFinish = false
    @State var showingModalApprove = false
    @State var showingModalRejected = false
    @State var showingModalMissedSchedule = false
    
    /* Boolean for Core Data Status */
    @State var showingModalRegistered = false
    @State var showingModalSchedule = false
    
    init() {
        getMobileVersion()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#232175")
                
                VStack(alignment: .leading) {
                    
                    header
                        .padding(.top, 30)
                        .padding(.horizontal, 30)
                    
                    PaginationView(axis: .horizontal) {
                        imageSliderOne.eraseToAnyView()
                        imageSliderTwo.eraseToAnyView()
                        imageSliderThree.eraseToAnyView()
                    }
                    
                    footerBtn
                        .padding(.top, 20)
                        .padding([.bottom, .horizontal], 30)
                }
                
                if self.showingModalMenu || self.showingModalRejected || self.showingModalApprove || self.showingModalRegistered || self.showingModalSchedule {
                    ModalOverlay(tapAction: { withAnimation { self.showingModalMenu = false } })
                }
            }
            .navigationBarItems(trailing: EmptyView())
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .onReceive(self.appState.$moveToWelcomeView) { moveToWelcomeView in
                if moveToWelcomeView {
                    print("Move to Welcome: \(moveToWelcomeView)")
                    self.isWelcomeViewActive = false
                    self.appState.moveToWelcomeView = false
                }
            }
            .onAppear() {
                print("APPEAR")
                getUserStatus(deviceId: deviceId!)
            }
            .popup(isPresented: $showingModalMenu, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageMenu()
            }
            .popup(isPresented: $showingModalApprove, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageApprove()
            }
            .popup(isPresented: $showingModalRejected, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageRejected()
            }
            .popup(isPresented: $showingModalRegistered, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageSuccess()
            }
            .popup(isPresented: $showingModalSchedule, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageScheduleVideoCall()
            }
        }
        
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("Welcome to")
                .font(.custom("Montserrat-Regular", size: 15))
                .foregroundColor(.white)
            
            HStack(alignment: .center, spacing: .none) {
                Image("logo_m_mestika")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("BANK MESTIKA")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                
            }.padding(.top, -5)
        }.padding(.top, 30)
    }
    
    var imageSliderOne: some View {
        Image("slider_pic_1")
            .resizable()
            .frame(height: UIScreen.main.bounds.height * 0.55)
            .padding(.horizontal, 30)
    }
    
    var imageSliderTwo: some View {
        Image("slider_pic_2")
            .resizable()
            .frame(height: UIScreen.main.bounds.height * 0.55)
            .padding(.horizontal, 30)
    }
    
    var imageSliderThree: some View {
        Image("slider_pic_3")
            .resizable()
            .frame(height: UIScreen.main.bounds.height * 0.55)
            .padding(.horizontal, 30)
    }
    
    var footerBtn: some View {
        VStack {
            
            Button(action : {
                showingModalMenu.toggle()
            }) {
                Text("DAFTAR")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(destination: LoginScreen()){
                Text("LOGIN")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .cornerRadius(12)
        }
    }
    
    // MARK: -Popup Message Create New (Modal)
    func popupMessageCreatedNew() -> some View {
        VStack(alignment: .leading) {
            Image("ic_group")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("PERSETUJUAN SEDANG DALAM PROSES")
                .fontWeight(.heavy)
                .font(.system(size: 22))
                .foregroundColor(.yellow)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Persetujuan sedang dalam proses. Hasil akan dikirim melalui SMS atau email.")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Button(
                action: {},
                label: {
                    Text("Saya Tunggu")
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
    
    // MARK: -Popup Message Approve (Modal)
    func popupMessageApprove() -> some View {
        VStack(alignment: .leading) {
            Image("ic_group")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("PEMBUKAAN REKENING DISETUJUI")
                .fontWeight(.heavy)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Selamat pembukaan rekening baru anda telah disetujui.")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Text("Silakan pilih tombol \"Lanjutkan\" untuk ke tahap selanjutnya")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            NavigationLink(destination: FormPilihDesainATMView()){
                Text("Lanjutkan")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
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
    
    // MARK: -Popup Message Rejected (Modal)
    func popupMessageRejected() -> some View {
        VStack(alignment: .leading) {
            Image("ic_group")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("Pembukaan Rekening ditolak")
                .fontWeight(.heavy)
                .font(.system(size: 22))
                .foregroundColor(.red)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Maaf, pembukaan rekening online Anda telah ditolak.")
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
    
    // MARK: -Popup Message Missed Schedule (Modal)
    func popupMessageMissedSchedule() -> some View {
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
    
    // MARK: -Popup Message Schedule Video Call (Modal)
    func popupMessageScheduleVideoCall() -> some View {
        VStack(alignment: .leading) {
            Image("ic_highfive")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("Jadwal Wawancara sudah diterima")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Customer Service kami akan menghubungi anda untuk melakukan konfirmasi dan aktivasi, pastikan anda available pada jam yang telah anda tentukan.")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            Button(
                action: {},
                label: {
                    Text("Kembali")
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
    
    // MARK: -Popup Message Success (Modal)
    func popupMessageSuccess() -> some View {
        VStack(alignment: .leading) {
            Image("ic_highfive")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("REGISTRASI BERHASIL")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Permohonan Pembukaan Rekening Anda telah disetujui. Silahkan login untuk pertama kali.")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            NavigationLink(destination: FirstLoginView(rootIsActive: self.$isActiveRootLogin).environmentObject(loginData)){
                Text("Login")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
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
    
    // MARK: -Popup Message Menu (Modal)
    func popupMessageMenu() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Sebelum Memulai..!!")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text("Apakah Anda telah memiliki rekening di Bank Mestika")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            NavigationLink(destination: KetentuanRegisterNasabahView().environmentObject(registerData), isActive: self.$isWelcomeViewActive){
                Text("Tidak, Saya Tidak Memiliki")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .isDetailLink(false)
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(destination: RegisterRekeningCardView(rootIsActive: self.$isActiveForNasabahPage).environmentObject(registerData)){
                Text("Ya, Saya Memiliki")
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
    
    /* Funtion GET User Details Core Data */
    func getUserDetails() {
        //        let data = User(context: managedObjectContext)
        //        data.deviceId = UIDevice.current.identifierForVendor?.uuidString
        //        data.nik = "3277102102890001"
        //        data.email = "andri.ferinata@gmail.com"
        //        data.phone = "08562006488"
        //        data.pin = "111111"
        //        data.password = "ferinata21"
        //        data.firstName = "Andri"
        //        data.lastName = "Ferinata"
        //
        //        do {
        //            try self.managedObjectContext.save()
        //        } catch {
        //            print("Error saving managed object context: \(error)")
        //        }
        
        if (user.last?.deviceId == deviceId && isFirstLogin == "true") {
            showingModalRegistered.toggle()
        }
        
        if (user.last?.deviceId == deviceId && isSchedule == "true") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingModalSchedule.toggle()
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
            }
            
            if (self.userVM.code == "R01") {
                self.showingModalCreatedNew = true
            }
            
            if (self.userVM.code == "R02") {
                
            }
            
            if (self.userVM.code == "R03") {
                
            }
            
            if (self.userVM.code == "R04") {
                
            }
            
            if (self.userVM.code == "R05") {
                self.showingModalApprove = true
            }
            
            if (self.userVM.code == "R06") {
                self.showingModalRejected = true
            }
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
