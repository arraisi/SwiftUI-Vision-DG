//
//  SuccessRegisterView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 04/10/20.
//

import SwiftUI

struct JamWawancara {
    var jam: String
}

struct TanggalWawancara {
    var tanggal: String
}

struct SuccessRegisterView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @ObservedObject var scheduleVM = ScheduleInterviewSummaryViewModel()
    var productATMData = AddProductATM()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    
    /* HUD Variable */
    @State private var dim = true
    
    /* Routing */
    @State private var backRoute: Bool = false
    
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    @State var showingModalJam = false
    @State var showingModalTanggal = false
    @State var showingModalInformation = false
    
    @State var pilihJam: String = ""
    @State var tanggalWawancara: String = ""
    
    @State var showFormPilihJenisATM = false
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    @State var date = Date()
    
    var disableForm: Bool {
        tanggalWawancara.isEmpty || pilihJam.isEmpty
    }
    
    init() {
        getAllSchedule()
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        LoadingView(isShowing: $scheduleVM.isLoading) {
            
            ZStack(alignment: .top) {
                Image("bg_blue")
                    .resizable()
                
                VStack {
                    
                    AppBarLogo(light: false, showCancel: false) { }
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Image("ic_trophy")
                                .resizable()
                                .frame(width: 95, height: 95)
                                .padding(.top, 40)
                                .padding(.horizontal, 20)
                            
                            Text("Pendaftaran Rekening Baru Telah Berhasil")
                                .font(.title)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .padding([.top], 20)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("Silahkan pilih waktu untuk dihubungi.")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#707070"))
                                .multilineTextAlignment(.leading)
                                .padding(.top, 25)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            HStack {
                                TextField("Pilih Tanggal Wawancara", text: $tanggalWawancara)
                                    .font(.subheadline)
                                    .frame(height: 36)
                                    .padding(.leading, 20)
                                    .disabled(true)
                                
                                Menu {
                                    ForEach(self.scheduleVM.scheduleDates, id: \.self) { data in
                                        Button(action: {
                                            tanggalWawancara = data
                                            scheduleVM.getScheduleById(date: tanggalWawancara)
                                        }) {
                                            Text(data)
                                                .font(.custom("Montserrat-Regular", size: 10))
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
                                
                                TextField("Pilih Jam", text: $pilihJam)
                                    .font(.subheadline)
                                    .frame(height: 36)
                                    .padding(.leading, 20)
                                    .disabled(true)
                                
                                
                                Menu {
                                    ForEach(self.scheduleVM.scheduleJamBasedOnDate, id: \.self) { data in
                                        Button(action: {
                                            pilihJam = data
                                        }) {
                                            Text(data)
                                                .font(.custom("Montserrat-Regular", size: 10))
                                        }
                                    }
                                } label: {
                                    Image(systemName: "clock").padding()
                                }
                                
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            
                            Text("Pastikan data Anda masih sama. Jika tidak maka silahkan mengisi kembali data pembuatan rekening baru")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#707070"))
                                .multilineTextAlignment(.leading)
                                .padding([.top, .bottom], 10)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Group {
                                Text("KTP.")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#707070"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 25)
                                    .padding(.horizontal, 20)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                TextField("No KTP", text: $registerData.nik)
                                    .frame(height: 10)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 20)
                                    .disabled(true)
                                
                                Text("No. HP.")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#707070"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 5)
                                    .padding(.horizontal, 20)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                TextField("Nomor Handphone", text: $registerData.noTelepon)
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
                                
                                TextField("Alamat Email", text: $registerData.email)
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
                                        // submitSchedule()
                                        // self.showFormPilihJenisATM = true
                                        self.showingModalInformation = true
                                    }
                                }, label: {
                                    Text("Buat Janji")
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
                                
                                NavigationLink(destination: FormPilihJenisATMView().environmentObject(productATMData).environmentObject(registerData), isActive: self.$showFormPilihJenisATM) {EmptyView()}
                                
                                Button(
                                    action: {
                                        self.showingModal.toggle()
                                    },
                                    label: {
                                        Text("Batalkan Permohonan")
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
                    ModalOverlay(tapAction: { withAnimation { self.showingModalInformation = false } })
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear {}
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageCancelRegister()
        }
        .popup(isPresented: $showingModalTanggal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomFloaterTanggal()
        }
        .popup(isPresented: $showingModalJam, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomFloaterJam()
        }
        .popup(isPresented: $showingModalInformation, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            showModalInformation()
        }
        
    }
    
    func removeUser() {
        
        //        let data = user.last
        //        managedObjectContext.delete(data!)
        //
        //        do {
        //            try managedObjectContext.save()
        //        } catch {
        //            // handle the Core Data error
        //        }
        //
        //        UserDefaults.standard.set("false", forKey: "isFirstLogin")
        //        UserDefaults.standard.set("false", forKey: "isSchedule")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("DELETE SUCCESS")
            self.appState.moveToWelcomeView = true
        }
    }
    
    func submitSchedule() {
        let timeArr = pilihJam.components(separatedBy: " - ")
        scheduleVM.submitSchedule(date: self.tanggalWawancara, nik: registerData.nik, endTime: timeArr[1], startTime: timeArr[1])
    }
    
    // MARK:- POPUP CANCEL REGISTER
    func popupMessageCancelRegister() -> some View {
        VStack(alignment: .center) {
            
            Text("Batalkan Permohonan")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 30)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(
                action: {},
                label: {
                    Text("TIDAK")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
            )
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 5)
            
            Button(
                action: {
                    removeUser()
                },
                label: {
                    Text("YA")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
            )
            .background(Color.gray)
            .cornerRadius(12)
            .padding(.bottom, 20)
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
            
            Text("Terimakasih telah memilih Bank Mestika")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 30)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Permohonan Pembukaan Rekening Anda sedang dalam proses persetujuan. Pihak kami akan menghubungi Anda untuk memverifikasi data.")
                .font(.caption)
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            NavigationLink(destination: WelcomeView()) {
                Text("Kembali ke Halaman Utama")
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
    
    // MARK: -Fuction for Create Bottom Floater (Modal
    func createBottomFloaterTanggal() -> some View {
        VStack {
            HStack {
                Text("Tanggal")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField("Tanggal Wawancara", text: $tanggalWawancara)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                
                Button(action:{
                    print("cari tanggal")
                }, label: {
                    Image(systemName: "calendar")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            List(self.scheduleVM.scheduleDates, id: \.self) { data in
                
                HStack {
                    Text(data)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(data)
                    tanggalWawancara = data
                    scheduleVM.getScheduleById(date: tanggalWawancara)
                    self.showingModalTanggal.toggle()
                })
                
            }
            .background(Color.white)
            .padding(.bottom)
            .frame(height: 200)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal
    func createBottomFloaterJam() -> some View {
        VStack {
            HStack {
                Text("Jam")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField("Jam Wawancara", text: $tanggalWawancara)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                
                Button(action:{
                    print("cari jam")
                }, label: {
                    Image(systemName: "clock")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            List(self.scheduleVM.scheduleJamBasedOnDate, id: \.self) { data in
                
                HStack {
                    Text(data)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(data)
                    pilihJam = data
                    self.showingModalJam.toggle()
                })
                
            }
            .background(Color.white)
            .padding(.vertical)
            .frame(height: 150)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func showModalInformation() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_cs")
                .resizable()
                .frame(width: 64, height: 90)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Informasi")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Jadwal wawancara telah kami terima, mohon tunggu CS kami untuk menghubungi anda pada :")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Text("Tanggal : \(tanggalWawancara)")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Jam : \(pilihJam)")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#2334D0"))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(
                action: {
                    self.showFormPilihJenisATM = true
                },
                label: {
                    Text("OK")
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
    
    func getAllSchedule() {
        self.scheduleVM.getAllSchedule() { success in }
    }
}

struct SuccessRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessRegisterView().environmentObject(RegistrasiModel())
    }
}
