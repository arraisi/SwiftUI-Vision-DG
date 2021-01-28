//
//  RescheduleRegisterView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/01/21.
//

import SwiftUI
import Indicators
import SystemConfiguration

struct RescheduleRegisterView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @ObservedObject var scheduleVM = ScheduleInterviewSummaryViewModel()
    @ObservedObject var regVM = UserRegistrationViewModel()
    @EnvironmentObject var atmData: AddProductATM
    var productATMData = AddProductATM()
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var schedule = [ScheduleInterviewViewModel]()
    @State var scheduleDates = [String]()
    @State var scheduleJamBasedOnDate = [String]()
    
    @State private var routing_schedule = UserDefaults.standard.string(forKey: "routingSchedule")
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    
    /* HUD Variable */
    @State private var dim = true
    
    /* Routing */
    @State private var backRoute: Bool = false
    @State private var nextRoute: Bool = false
    var isAllowBack: Bool = true
    
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    @State var showingModalJam = false
    @State var showingModalTanggal = false
    @State var showingModalInformation = false
    
    @State var isLoading = false
    @State var showingAlert = false
    @State var isShowingAlert: Bool = false
    
    @State var pilihJam: String = ""
    @State var tanggalWawancara: String = ""
    
    @State var showFormPilihJenisATM = false
    
    @State var date = Date()
    
    @State var isShowAlertInternetConnection = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    var disableForm: Bool {
        tanggalWawancara.isEmpty || pilihJam.isEmpty
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, showCancel: false) { }
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Image("ic_trophy")
                            .resizable()
                            .frame(width: 95, height: 95)
                            .padding(.top, 40)
                            .padding(.horizontal, 20)
                        
                        Text(NSLocalizedString("Pendaftaran Rekening Baru Telah Berhasil", comment: ""))
                            .font(.title)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(.bold)
                            .padding([.top], 20)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(NSLocalizedString("Silahkan pilih waktu untuk dihubungi.", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#707070"))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 25)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            TextField(NSLocalizedString("Pilih Tanggal Wawancara", comment: ""), text: $tanggalWawancara)
                                .font(.subheadline)
                                .frame(height: 36)
                                .padding(.leading, 20)
                                .disabled(true)
                            
                            Menu {
                                ForEach(self.scheduleDates, id: \.self) { data in
                                    Button(action: {
                                        tanggalWawancara = data
                                        getScheduleById(date: tanggalWawancara)
                                    }) {
                                        Text(data)
                                            .font(.custom("Montserrat-Regular", size: 12))
                                    }
                                }
                            } label: {
                                Image(systemName: "calendar").padding()
                            }
                            
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        
                        HStack {
                            
                            TextField(NSLocalizedString("Pilih Jam", comment: ""), text: $pilihJam)
                                .font(.subheadline)
                                .frame(height: 36)
                                .padding(.leading, 20)
                                .disabled(true)
                            
                            
                            Menu {
                                ForEach(self.scheduleJamBasedOnDate, id: \.self) { data in
                                    Button(action: {
                                        pilihJam = data
                                    }) {
                                        Text(data)
                                            .font(.custom("Montserrat-Regular", size: 12))
                                    }
                                }
                            } label: {
                                Image(systemName: "clock").padding()
                            }
                            
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        
                        Text(NSLocalizedString("Pastikan data Anda masih sama. Jika tidak maka silahkan mengisi kembali data pembuatan rekening baru", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#707070"))
                            .multilineTextAlignment(.leading)
                            .padding([.top, .bottom], 10)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Group {
                            Text(NSLocalizedString("KTP.", comment: ""))
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#707070"))
                                .multilineTextAlignment(.leading)
                                .padding(.top, 25)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            TextField(NSLocalizedString("No KTP", comment: ""), text: $registerData.nik)
                                .frame(height: 10)
                                .font(.subheadline)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .padding(.bottom, 5)
                                .padding(.horizontal, 20)
                                .disabled(true)
                            
                            Text(NSLocalizedString("No. HP.", comment: ""))
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#707070"))
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            TextField(NSLocalizedString("Nomor Handphone", comment: ""), text: $registerData.noTelepon)
                                .frame(height: 10)
                                .font(.subheadline)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .padding(.bottom, 5)
                                .padding(.horizontal, 20)
                                .disabled(true)
                            
                            Text("Email.")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#707070"))
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            TextField(NSLocalizedString("Alamat Email", comment: ""), text: $registerData.email)
                                .frame(height: 10)
                                .font(.subheadline)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .padding(.bottom, 5)
                                .padding(.horizontal, 20)
                                .disabled(true)
                        }
                        
                        Group {
                            
                            Button(action: {
                                if pilihJam != "" {
                                    if (self.user.last?.isNasabahMestika == true) {
                                        submitScheduleNasabahExisting()
                                    } else {
                                        submitSchedule()
                                    }
                                } else {
                                    self.isShowAlertInternetConnection = true
                                }
                            }, label: {
                                Text(NSLocalizedString("Buat Janji", comment: ""))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.system(size: 13))
                                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            })
                            .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 5)
                            .disabled(disableForm)
                            
                            NavigationLink(destination: FormPilihJenisATMView(isAllowBack: false).environmentObject(productATMData).environmentObject(registerData), isActive: self.$showFormPilihJenisATM) {EmptyView()}
                            
                            Button(
                                action: {
                                    self.showingModal = true
                                },
                                label: {
                                    Text(NSLocalizedString("Batalkan Permohonan", comment: ""))
                                        .foregroundColor(Color(hex: "#707070"))
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .font(.system(size: 13))
                                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                }
                            )
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            
                            
                            Spacer()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 30)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 25)
                }
            }
            
            NavigationLink(
                destination: WelcomeView(),
                isActive: self.$backRoute,
                label: {})
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
            
            if self.showingModalJam {
                ModalOverlay(tapAction: { withAnimation { self.showingModalJam = false } })
            }
            
            if self.showingModalTanggal {
                ModalOverlay(tapAction: { withAnimation { self.showingModalTanggal = false } })
            }
            
            if self.showingModalInformation {
                ZStack {
                    ModalOverlay(tapAction: { withAnimation { self.showingModalInformation = false } })
                    showModalInformation()
                }
                .transition(.asymmetric(insertion: .opacity, removal: .fade))
            }
            
            if self.isShowAlertInternetConnection {
                ModalOverlay(tapAction: { withAnimation {
                    self.isShowAlertInternetConnection = false
                } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            getAllSchedule()
        }
        .onAppear {
            self.registerData.nik = self.user.last?.nik! ?? "-"
            self.registerData.noTelepon = self.user.last?.noTelepon! ?? "-"
            self.registerData.email = self.user.last?.email! ?? "-"
            self.registerData.namaLengkapFromNik = self.user.last?.namaLengkapFromNik! ?? "-"
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Apakah ingin membatalkan registrasi ?", comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YA", comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("Tidak", comment: ""))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.isShowingAlert = true
            }
        }))
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageCancelRegister()
        }
//        .popup(isPresented: $showingModalInformation, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
//            showModalInformation()
//        }
        .popup(isPresented: $isShowAlertInternetConnection, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            PopupNoInternetConnection()
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Message"),
                message: Text("\(self.scheduleVM.message)"),
                dismissButton: .default(Text("Oke")))
        }
    }
    
    func removeUser() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("DELETE SUCCESS")
            self.appState.moveToWelcomeView = true
        }
    }
    
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
            
            Button(
                action: {
                    self.isShowAlertInternetConnection = false
                    appState.moveToWelcomeView = true
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
    
    // MARK:- POPUP CANCEL REGISTER
    func popupMessageCancelRegister() -> some View {
        VStack(alignment: .center) {
            
            Text(NSLocalizedString("Batalkan Permohonan", comment: ""))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 30)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(
                action: {},
                label: {
                    Text(NSLocalizedString("TIDAK", comment: ""))
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
            )
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 5)
            
            NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false), editModeForCancel: .active).environmentObject(registerData)){
                Text(NSLocalizedString("YA", comment: ""))
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .background(Color.gray)
            .cornerRadius(12)
            .padding(.bottom, 20)
            
            //            Button(
            //                action: {
            //                    cancelRegistration()
            //                },
            //                label: {
            //                    Text(NSLocalizedString("YA", comment: ""))
            //                        .foregroundColor(.white)
            //                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            //                        .font(.system(size: 13))
            //                        .frame(maxWidth: .infinity, maxHeight: 40)
            //                }
            //            )
            //            .background(Color.gray)
            //            .cornerRadius(12)
            //            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    /* Fuction for Create Bottom Floater (Modal) */
    func createBottomFloater() -> some View {
        VStack(alignment: .leading) {
            Image("Logo M")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text(NSLocalizedString("Terimakasih telah memilih Bank Mestika", comment: ""))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 30)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Permohonan Pembukaan Rekening Anda sedang dalam proses persetujuan. Pihak kami akan menghubungi Anda untuk memverifikasi data.", comment: ""))
                .font(.caption)
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            NavigationLink(destination: WelcomeView()) {
                Text(NSLocalizedString("Kembali ke Halaman Utama", comment: ""))
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
    
    func showModalInformation() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_cs")
                .resizable()
                .frame(width: 64, height: 90)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString("Informasi", comment: ""))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Jadwal wawancara telah kami terima, mohon tunggu CS kami untuk menghubungi anda pada :", comment: ""))
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
                    Text("\(tanggalWawancara)")
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
                    Text("\(pilihJam)")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
            }
            
            if (routing_schedule == "true" || self.user.last?.isNasabahMestika == true) {
                Button(
                    action: {
                        print("BACK")
                        self.appState.moveToWelcomeView = true
                    },
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
            } else {
                Button(
                    action: {
                        print(registerData.homeRoute)
                        self.showFormPilihJenisATM = true
                    },
                    label: {
                        Text("Selanjutnya")
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
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    // MARK:- GET ALL SCHEDULE
    func getAllSchedule() {
        self.isLoading = true
        
        self.scheduleVM.getAllSchedule() { success in
            
            if success {
                self.isLoading = self.scheduleVM.isLoading
                self.schedule = self.scheduleVM.schedule
                
                self.scheduleDates = Array(Set(schedule.map({ (resp: ScheduleInterviewViewModel) -> String in
                    return resp.date
                }))).sorted()
            }
            
            if !success {
                self.isLoading = false
            }
        }
    }
    
    // MARK:- GET SCHEDULE BY DATE
    func getScheduleById(date: String) {
        self.scheduleJamBasedOnDate = Array(Set(schedule.filter({ (data:ScheduleInterviewViewModel) -> Bool in
            return data.date == date
        }).map({ (data:ScheduleInterviewViewModel) -> String in
            return "\(data.timeStart)" + "-" + "\(data.timeEnd)"
        }))).sorted()
    }
    
    // MARK:- SUBMIT SCHEDULE FOR NASABAH EXISTING
    func submitScheduleNasabahExisting() {
        
        self.isLoading = true
        
        let timeArr = pilihJam.components(separatedBy: "-")
        print("time start \(timeArr[0])")
        print("time end \(timeArr[1])")
        
        let data = ScheduleInterview(context: managedObjectContext)
        data.jamInterview = self.pilihJam
        data.tanggalInterview = self.tanggalWawancara
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        atmData.nik = registerData.nik
        atmData.isNasabahMestika = true
        atmData.codeClass = ""
        
        scheduleVM.submitScheduleNasabahExisting(atmData: atmData, date: self.tanggalWawancara, nik: registerData.nik, endTime: timeArr[1], startTime: timeArr[0]) { (success) in
            
            let dataSchedule: [String: Any] = [
                "dateInterview": self.tanggalWawancara,
                "timeInterview": self.pilihJam
            ]
            
            NotificationCenter.default.post(name: NSNotification.Name("Schedule"), object: nil, userInfo: dataSchedule)
            
            if success {
                self.isLoading = false
                self.showingModalInformation = true
            }
            
            if !success {
                self.isLoading = false
                self.showingAlert.toggle()
            }
        }
    }
    
    // MARK:- SUBMIT SCHEDULE FOR NASABAH
    func submitSchedule() {
        self.isLoading = true
        
        let timeArr = pilihJam.components(separatedBy: "-")
        print("time start \(timeArr[0])")
        print("time end \(timeArr[1])")
        
        let data = ScheduleInterview(context: managedObjectContext)
        data.jamInterview = self.pilihJam
        data.tanggalInterview = self.tanggalWawancara
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        scheduleVM.reSubmitSchedule(date: self.tanggalWawancara, nik: registerData.nik, endTime: timeArr[1], startTime: timeArr[0]) { success in
            
            let dataSchedule: [String: Any] = [
                "dateInterview": self.tanggalWawancara,
                "timeInterview": self.pilihJam
            ]
            
            NotificationCenter.default.post(name: NSNotification.Name("Schedule"), object: nil, userInfo: dataSchedule)
            
            if success {
                self.isLoading = false
                self.showingModalInformation = true
            }
            
            if !success {
                self.isLoading = false
                self.showingAlert.toggle()
            }
        }
    }
    
    func cancelRegistration() {
        self.isLoading = true
        regVM.cancelRegistration(nik: registerData.nik ?? "", completion: { (success:Bool) in
            
            if success {
                self.isLoading = false
                removeUser()
            } else {
                self.isLoading = false
                
                self.scheduleVM.message = NSLocalizedString("Gagal membatalkan permohonan. Silakan coba beberapa saat lagi.", comment: "")
                self.showingAlert.toggle()
            }
        })
    }
}

struct RescheduleRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RescheduleRegisterView().environmentObject(RegistrasiModel())
    }
}