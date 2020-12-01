//
//  WelcomeView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 25/11/20.
//

import SwiftUI
import PopupView

struct WelcomeView: View {
    
    init() {
        getMobileVersion()
    }
    
    @EnvironmentObject var appState: AppState
    
    // Route Variables
    @State var isKetentuanViewActive: Bool = false
    @State var isLoginViewActive: Bool = false
    @State var isFirstLoginViewActive: Bool = false
    @State var isActiveRootLogin : Bool = false
    
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
//    @State var isShowModal = false
//    @State var modalSelection = ""
    
    @State var isShowModal = true
    @State var modalSelection = "RegisterApprovedModal"
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Color(hex: "#232175")
                
                VStack(spacing: 10) {
                    Spacer()
                    
                    Header
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    WelcomeViewCarousel(data: self.$images) { index in
                        print("carousel index: \(index)")
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        
                        Button(action : {
                            self.isShowModal.toggle()
                        }) {
                            Text("DAFTAR")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(15)
                        
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
                        self.modalSelection = ""
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
                    self.appState.moveToWelcomeView = false
                }
            }
            .onAppear() {
                print("APPEAR")
                getUserStatus(deviceId: deviceId!)
            }
            .popup(isPresented: $isShowModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                
                popupMenu()
                
            }
        }
    }
    
    var Header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome to")
                    .font(.custom("Montserrat-Regular", size: 15))
                    .foregroundColor(.white)
                
                Image("logo_mestika")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding(.top, -2)
                
            }
            Spacer()
        }
    }
    
    func popupMenu() -> some View {
        switch modalSelection {
        case "SuccsessRegisterModal":
            return AnyView(SuccsessRegisterModal())
        case "ScheduleVideoCallModal":
            return AnyView(ScheduleVideoCallModal())
        case "RegisterRejectedModal":
            return AnyView(RegisterRejectedModal())
        case "RegisterApprovedModal":
            return AnyView(RegisterApprovedModal())
        case "RegisterCreatedModal":
            return AnyView(RegisterCreatedModal())
        default:
            return AnyView(ScreeningNasabahModal())
        }
    }
    
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
            
            NavigationLink(destination: KetentuanRegisterNonNasabahView().environmentObject(registerData), isActive: self.$isKetentuanViewActive){
                Text("Tidak, saya bukan")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .isDetailLink(false)
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(destination: NoAtmOrRekeningVerificationView().environmentObject(registerData)){
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
            Image("ic_group")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("PEMBUKAAN REKENING DISETUJUI")
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Selamat pembukaan rekening baru anda telah disetujui.")
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 10)
            
            Text("Silakan pilih tombol \"Lanjutkan\" untuk ke tahap selanjutnya")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            NavigationLink(destination: FormPilihJenisATMView().environmentObject(productATMData)){
                Text("Lanjutkan")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 50)
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
            }
            
            if (self.userVM.code == "R01") {
                self.modalSelection = "RegisterCreatedModal"
                self.isShowModal = true
            }
            
            if (self.userVM.code == "R02") {
                
            }
            
            if (self.userVM.code == "R03") {
                
            }
            
            if (self.userVM.code == "R04") {
                
            }
            
            if (self.userVM.code == "R05") {
                self.modalSelection = "RegisterApprovedModal"
                self.isShowModal = true
            }
            
            if (self.userVM.code == "R06") {
                self.modalSelection = "RegisterRejectedModal"
                self.isShowModal = true
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
