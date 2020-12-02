//
//  SuccessRegisterNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI
import JGProgressHUD_SwiftUI

struct SuccessRegisterNasabahScreen: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var scheduleVM = ScheduleInterviewSummaryViewModel()
    var productATMData = AddProductATM()
    
    /* HUD Variable */
    @State private var dim = true
    
    /* Routing */
    @State private var backRoute: Bool = false
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showingModalJam = false
    @State var showingModalTanggal = false
    
    @State var pilihJam: String = ""
    @State var tanggalWawancara: String = ""
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    @State var date = Date()
    
    let jam:[JamWawancara] = [
        .init(jam: "09.00 - 10.00"),
        .init(jam: "10.00 - 11.00"),
    ]
    
    let tanggal:[TanggalWawancara] = [
        .init(tanggal: "2020-10-27"),
        .init(tanggal: "2020-10-27")
    ]
    
    var disableForm: Bool {
        tanggalWawancara.isEmpty || pilihJam.isEmpty
    }
    
    init() {
        getAllSchedule()
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
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
                        
                        Button(action:{
                            showingModalTanggal.toggle()
                        }, label: {
                            Image(systemName: "calendar")
                                .font(Font.system(size: 20))
                                .foregroundColor(Color(hex: "#707070"))
                        })
                        .padding(.trailing, 20)
                        
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
                        
                        Button(action:{
                            showingModalJam.toggle()
                        }, label: {
                            Image(systemName: "clock")
                                .font(Font.system(size: 20))
                                .foregroundColor(Color(hex: "#707070"))
                        })
                        .padding(.trailing, 20)
                        
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
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        
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
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        
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
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                    
                    Group {
                        
                        NavigationLink(
                            destination: FormPilihJenisATMView().environmentObject(productATMData).environmentObject(registerData),
                            label: {
                                Text("Buat Janji")
                                    .foregroundColor(.white)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .font(.system(size: 13))
                                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            })
                            .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 5)
                            .disabled(disableForm)
                        
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
                .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
                .padding(.horizontal, 30)
                .padding(.top, 120)
                .padding(.bottom, 35)
            }
            
            NavigationLink(
                destination: WelcomeView(),
                isActive: self.$backRoute,
                label: {}
            )
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
            
            if self.showingModalJam {
                ModalOverlay(tapAction: { withAnimation { self.showingModalJam = false } })
            }
            
            if self.showingModalTanggal {
                ModalOverlay(tapAction: { withAnimation { self.showingModalTanggal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            showIndeterminate()
        }
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
    }
    
    func removeUser() {
        
        showIndeterminate()
        
//        let data = user.last
//        managedObjectContext.delete(data!)
//        
//        do {
//            try managedObjectContext.save()
//        } catch {
//            // handle the Core Data error
//        }
        
        UserDefaults.standard.set("false", forKey: "isFirstLogin")
        UserDefaults.standard.set("false", forKey: "isSchedule")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("DELETE SUCCESS")
            self.appState.moveToWelcomeView = true
        }
    }
    
    private func showIndeterminate() {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            if dim {
                hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            }
            
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.3)
            hud.vibrancyEnabled = false
            hud.textLabel.text = "Loading"
            
            hud.dismiss(afterDelay: 2)
            return hud
        }
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
    
    // MARK: - POPUP PROSES REGISTER
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
            
            List(self.scheduleVM.schedule, id: \.date) { data in
                
                HStack {
                    Text(data.date)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(data)
                    tanggalWawancara = data.date
                    self.showingModalTanggal.toggle()
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

            List(self.scheduleVM.schedule, id: \.timeStart) { data in

                HStack {
                    Text("\(data.timeStart)" + "-" + "\(data.timeEnd)")
                            .font(Font.system(size: 14))

                    Spacer()
                }
                        .contentShape(Rectangle())
                        .onTapGesture(perform: {
                            print(data)
                            pilihJam = "\(data.timeStart)" + "-" + "\(data.timeEnd)"
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
    
    func getAllSchedule() {
        self.scheduleVM.getAllSchedule() { success in }
    }
}

struct SuccessRegisterNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        SuccessRegisterNasabahScreen().environmentObject(RegistrasiModel())
    }
}
