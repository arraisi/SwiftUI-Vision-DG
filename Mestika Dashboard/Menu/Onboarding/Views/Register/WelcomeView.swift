//
//  RegisterView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 23/09/20.
//

import SwiftUI
import PopupView
import SystemConfiguration
import NavigationStack
import SwiftUIX

struct WelcomeView: View {
    
    /* For Check Internet Connection */
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.aple.com")
    
    @State var isActiveForNonNasabahPage : Bool = false
    @State var isActiveForNasabahPage : Bool = false
    @State var isActiveRoot : Bool = false
    @State var isActiveRootLogin : Bool = false
    @ObservedObject var assetsSliderVM = SliderAssetsSummaryViewModel()
    
    var registerData = RegistrasiModel()
    var loginData = LoginBindingModel()
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
//    @State private var isFirstLogin = UserDefaults.standard.string(forKey: "isFirstLogin")
//    @State private var isSchedule = UserDefaults.standard.string(forKey: "isSchedule")
    
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    @State var isViewActivity: Bool = false
    
    /* Boolean for Show Modal & Alert */
    @State var showingModal = false
    @State var showingModalRegistered = false
    @State var showingModalSchedule = false
    @State var showAlert = false
    
    /* Variable for Image Carousel */
    @State var menu = 0
    @State var page = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#232175")
            
            VStack(alignment: .leading) {
                header
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                
                PaginationView(axis: .horizontal) {
                    imageSliderOne.eraseToAnyView()
                    imageSliderTwo.eraseToAnyView()
                    imageSliderThree.eraseToAnyView()
                }
                
                footerBtn
                    .padding(.top, 20)
                    .padding(.bottom, 35)
                    .padding(.horizontal, 30)
            }
            
            if self.showingModal || self.showingModalRegistered || self.showingModalSchedule {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            print("APPEAR")
//            getUserDetails()
        }
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Message"),
                message: Text("New User Success Registered"),
                dismissButton: .default(Text("Oke")))
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
        .popup(isPresented: $showingModalRegistered, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageSuccess()
        }
        .popup(isPresented: $showingModalSchedule, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageScheduleVideoCall()
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("Welcome to")
                .fontWeight(.semibold)
                .font(.system(size: 15))
                .foregroundColor(.white)
            
            HStack(alignment: .center, spacing: .none) {
                Image("logo_m_mestika")
                    .resizable()
                    .frame(width: 25, height: 25)
                
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
            .padding()
    }
    
    var imageSliderTwo: some View {
        Image("slider_pic_2")
            .resizable()
            .padding()
    }
    
    var imageSliderThree: some View {
        Image("slider_pic_3")
            .resizable()
            .padding()
    }
    
    var footerBtn: some View {
        VStack {
            
            Button(action : {
                showingModal.toggle()
            }) {
                Text("DAFTAR")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            PushView(destination: LoginScreen()) {
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .cornerRadius(12)
        }
    }
    
    // MARK: -Popup Message Success (Modal)
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
                action: {
//                    UserDefaults.standard.set("true", forKey: "isFirstLogin")
//                    UserDefaults.standard.set("false", forKey: "isSchedule")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showingModalRegistered.toggle()
                    }
                },
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
            
            NavigationLink(
                destination: FirstLoginView(rootIsActive: self.$isActiveRootLogin).environmentObject(loginData),
                isActive: self.$isActiveRootLogin,
                label: {
                    Text("Login")
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
    
    // MARK: -Create Bottom Floater (Modal)
    func createBottomFloater() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Sebelum Memulai..!!")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text("Apakah Anda telah memiliki rekening di Bank Mestika")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            NavigationLink(destination: KetentuanRegisterNasabahView(rootIsActive: self.$isActiveForNonNasabahPage).environmentObject(registerData)) {
                Text("Tidak, Saya Tidak Memiliki")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(
                destination: RegisterRekeningCardView(rootIsActive: self.$isActiveForNasabahPage).environmentObject(registerData),
                label: {
                    Text("Ya, Saya Memiliki")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                })
                .padding(.bottom, 30)
                .cornerRadius(12)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
//    @Environment(\.managedObjectContext) var managedObjectContext
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
        
//        if (user.last?.deviceId == deviceId && isFirstLogin == "true") {
//            showingModalRegistered.toggle()
//        }
//
//        if (user.last?.deviceId == deviceId && isSchedule == "true") {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                showingModalSchedule.toggle()
//            }
//        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
