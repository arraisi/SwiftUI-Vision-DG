//
//  VerificationRegisterDataView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI
import Indicators

struct VerificationRegisterDataView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    var productATMData = AddProductATM()
    @EnvironmentObject var appState: AppState
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    /*
     Recognized Nomor Induk Ktp
     */
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    /*
     Views Variables
     */
    @State private var nextRouteNasabah: Bool = false
    @State private var nextRouteNonNasabah: Bool = false
    @State private var shouldPresentCamera = false
    @State private var cameraFileName = ""
    
    @State private var imageTaken: Image?
    
    @State var isLoading = false
    
    @ObservedObject private var userRegisterVM = UserRegistrationViewModel()
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    @State private var showingAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#232175")
            
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white)
                    .frame(height: UIScreen.main.bounds.height / 2.2)
                
            }
            
            VStack {
                
                AppBarLogo(light: false, showCancel: true) {
                    self.appState.moveToWelcomeView = true
                }
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                
                ScrollView {
                    VStack {
                        Text(NSLocalizedString("PASTIKAN INFORMASI ANDA BENAR", comment: ""))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .leading) {
                            Group {
                                LabelTextFieldWithIcon(value: $registerData.nik, label: NSLocalizedString("KTP", comment: ""), placeHolder: NSLocalizedString("KTP", comment: "")) {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 20)
                                .padding(.horizontal, 20)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                
                                LabelTextFieldWithIcon(value: $registerData.noTelepon, label: NSLocalizedString("No. Telepon", comment: ""), placeHolder: NSLocalizedString("No. Telepon", comment: "")) {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 10)
                                .padding(.horizontal, 20)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                
                                LabelTextFieldWithIcon(value: $registerData.email, label: "Email", placeHolder: "Email") {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 10)
                                .padding(.horizontal, 20)
                                .disabled(true)
                                
                                // KTP ROW
                                VStack {
                                    
                                    Button(action: {
                                        self.cameraFileName = "ktp"
                                        self.shouldPresentCamera = true
                                    }) {
                                        HStack {
                                            Text(NSLocalizedString("Foto KTP", comment: ""))
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "#232175"))
                                                .fontWeight(.bold)
                                            Spacer()
                                            
                                            VStack {
                                                self.registerData.fotoKTP
                                                    .resizable()
                                                    .frame(maxWidth: 80, maxHeight: 50)
                                                    .cornerRadius(8)
                                            }
                                            .frame(maxWidth: 80, minHeight: 50, maxHeight: 50)
                                        }
                                        
                                    }
                                    
                                    Divider()
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                
                                // SELFIE ROW
                                VStack {
                                    
                                    Button(action: {
                                        self.cameraFileName = "selfie"
                                        //                                        self.shouldPresentMaskSelfie = true
                                        self.shouldPresentCamera = true
                                    }) {
                                        HStack {
                                            Text("Selfie")
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "#232175"))
                                                .fontWeight(.bold)
                                            Spacer()
                                            
                                            VStack {
                                                self.registerData.fotoSelfie
                                                    .resizable()
                                                    .frame(maxWidth: 80, maxHeight: 50)
                                                    .cornerRadius(8)
                                            }
                                            .frame(maxWidth: 80, minHeight: 50, maxHeight: 50)
                                        }
                                    }
                                    Divider()
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                
                                // NPWP ROW
                                if self.registerData.npwp != "" {
                                    VStack {
                                        
                                        Button(action: {
                                            self.cameraFileName = "npwp"
                                            self.shouldPresentCamera = true
                                        }) {
                                            HStack {
                                                Text("NPWP")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color(hex: "#232175"))
                                                    .fontWeight(.bold)
                                                Spacer()
                                                
                                                VStack {
                                                    self.registerData.fotoNPWP
                                                        .resizable()
                                                        .frame(maxWidth: 80, maxHeight: 50)
                                                        .cornerRadius(8)
                                                }
                                                .frame(maxWidth: 80, minHeight: 50, maxHeight: 50)
                                            }
                                        }
                                        Divider()
                                    }
                                    .padding([.top, .bottom], 20)
                                    .padding(.horizontal, 20)
                                }
                                
                                Group {
                                    
                                    Text(NSLocalizedString("Jenis Tabungan", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Jenis Tabungan", comment: ""), text: $registerData.jenisTabungan)
                                            .disabled(true)
                                        
//                                        Divider()
//                                            .frame(height: 30)
//
//                                        NavigationLink(destination: TujuanPembukaanRekeningView(editMode: .active).environmentObject(registerData)) {
//                                            Text("Edit").foregroundColor(.blue)
//                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    Text(NSLocalizedString("Tujuan Pembukaan Rekening", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Tujuan Pembukaan Rekening", comment: ""), text: $registerData.tujuanPembukaan)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: TujuanPembukaanRekeningView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    Text(NSLocalizedString("Sumber Dana", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Sumber Dana", comment: ""), text: $registerData.sumberDana)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: SumberDanaView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    
                                    Text(NSLocalizedString("Perkiraan Penarikan", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Perkiraan Penarikan", comment: ""), text: $registerData.perkiraanPenarikan)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: PerkiraanPenarikanView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                }
                                
                                Group {
                                    Text(NSLocalizedString("Besar Perkiraan Penarikan", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Besar Perkiraan Penarikan", comment: ""), text: $registerData.besarPerkiraanPenarikan)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: BesarPerkiraanPenarikanView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    Text(NSLocalizedString("Perkiraan Setoran", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Perkiraan Setoran", comment: ""), text: $registerData.perkiraanSetoran)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: PerkiraanSetoranView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    Text(NSLocalizedString("Besar Perkiraan Setoran", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Besar Perkiraan Setoran", comment: ""), text: $registerData.besarPerkiraanPenarikan)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: BesarPerkiraanSetoranView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    Text(NSLocalizedString("Pekerjaan", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Pekerjaan", comment: ""), text: $registerData.pekerjaan)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: PerkerjaanView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    dynamicForm
                                    
                                }
                            }
                            Spacer()
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 35)
                }
                
                VStack {
                    Button(action: {
                        
                        saveUserToDb()
                        
                    }, label: {
                        Text(NSLocalizedString("Submit Data", comment: ""))
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 100)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .disabled(self.userRegisterVM.isLoading)
                    
                    NavigationLink(
                        destination: SuccessRegisterView(isAllowBack: false).environmentObject(registerData),
                        isActive: self.$nextRouteNonNasabah,
                        label: {}
                    )
                    
                    NavigationLink(
                        destination: VerificationPINView().environmentObject(registerData).environmentObject(productATMData),
                        isActive: self.$nextRouteNasabah,
                        label: {EmptyView()}
                    )
                }
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $shouldPresentCamera) {
            if self.cameraFileName == "selfie" {
                camera
            } else {
                scanner
            }
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Message"),
                message: Text("\(self.userRegisterVM.message)"),
                dismissButton: .default(Text("Oke")))
        }
        
    }
    
    var scanner: some View {
        ScanningView(recognizedText: $recognizedText.value, cameraFileName: $cameraFileName)
            .onDisappear(perform: {
                let scanResult = retrieveImage(forKey: self.cameraFileName)
                
                if let image = scanResult {
                    switch self.cameraFileName {
                    case "ktp":
                        self.registerData.fotoKTP = Image(uiImage: image)
                    case "npwp":
                        self.registerData.fotoNPWP = Image(uiImage: image)
                    default:
                        print("retrieve image nil")
                    }
                }
            })
    }
    
    var camera: some View {
        ZStack {
            SUImagePickerView(sourceType: .camera, image: $imageTaken, isPresented: $shouldPresentCamera, frontCamera: .constant(true))
                .onDisappear {
                    if let image = imageTaken {
                        registerData.fotoSelfie = image
                    }
                    //                    self.shouldPresentMaskSelfie = false
                }
            
            //            if shouldPresentMaskSelfie {
            Image("pattern_selfie")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .offset(y: -(UIScreen.main.bounds.height * 0.12))
            //            }
            
        }
    }
    
    var dynamicForm: some View {
        VStack(alignment: .leading) {
            
            // MARK : Pekerjaan BUMN
            if [6 ,9, 10, 11, 12].contains(registerData.pekerjaanId) {
                
                // MARK : Pekerjaan Pensiunan, Pelajar, IRT
                if (registerData.pekerjaanId == 10 || registerData.pekerjaanId == 11 || registerData.pekerjaanId == 12) {
                    EmptyView()
                } else {
                    Text(NSLocalizedString("Penghasilan Kotor", comment: ""))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField(NSLocalizedString("Penghasilan Kotor", comment: ""), text: $registerData.penghasilanKotor)
                            .disabled(true)
                        
                        Divider()
                            .frame(height: 30)
                        
                        NavigationLink(destination: PenghasilanKotorView(editMode: .active).environmentObject(registerData)) {
                            Text("Edit").foregroundColor(.blue)
                        }
                    }
                    .frame(height: 20)
                    .font(.subheadline)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                if registerData.pekerjaanId == 6 {
                    Text(NSLocalizedString("Jabatan", comment: ""))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField(NSLocalizedString("Jabatan", comment: ""), text: $registerData.jabatanProfesi)
                            .disabled(true)
                        
                        Divider()
                            .frame(height: 30)
                        
                        NavigationLink(destination: FormJabatanProfesiView(editMode: .active).environmentObject(registerData)) {
                            Text("Edit").foregroundColor(.blue)
                        }
                    }
                    .frame(height: 20)
                    .font(.subheadline)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                // MARK : Pekerjaan Wiraswasta
                if registerData.pekerjaanId == 9 {
                    Text(NSLocalizedString("Industri", comment: ""))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField(NSLocalizedString("Industri", comment: ""), text: $registerData.industriTempatBekerja)
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        
                        Divider()
                            .frame(height: 30)
                        
                        NavigationLink(destination: FormIndustriTempatBekerjaView(editMode: .active).environmentObject(registerData)) {
                            Text("Edit").foregroundColor(.blue)
                        }
                    }
                    .frame(height: 20)
                    .font(.subheadline)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
            }
            
            Text(NSLocalizedString("Sumber Pendapatan Lainnya", comment: ""))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            
            HStack {
                TextField(NSLocalizedString("Sumber Pendapatan Lainnya", comment: ""), text: $registerData.sumberPendapatanLainnya)
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: SumberPendapatanLainnyaView(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // MARK : Pekerjaan Wiraswasta
            if [10, 11, 12].contains(registerData.pekerjaanId) {
                informasiPenyandangDanaFields
            } else {
                InformasiPerusahaanVerificationView()
                    .padding(.bottom, 5)
            }
            
            InformasiKeluargaVerificationView()
                .padding(.bottom, 20)
        }
    }
    
    var informasiPenyandangDanaFields: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(NSLocalizedString("Informasi Penyandang Dana", comment: ""))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: FormSumberPenyandandDana2View(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .cornerRadius(15)
            
            Group {
                Text(NSLocalizedString("Nama Penyandang Dana", comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Nama Penyandang Dana", comment: ""), text: $registerData.namaPenyandangDana)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text(NSLocalizedString("Hubungan Dengan Anda", comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Hubungan Dengan Anda", comment: ""), text: $registerData.hubunganPenyandangDana)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text(NSLocalizedString("Profesi Penyandang Dana", comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Profesi Penyandang Dana", comment: ""), text: $registerData.profesiPenyandangDana)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
        }
        .padding(.bottom, 5)
    }
    
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
           let image = UIImage(data: imageData) {
            return image
        }
        
        return nil
    }
    
    /* Save User To Core Data */
    func saveUserToCoreData()  {
        
        if (user.isEmpty) {
            print("------SAVE TO CORE DATA-------")
            //
            //            let data = User(context: managedObjectContext)
            //            data.deviceId = UIDevice.current.identifierForVendor?.uuidString
            //            data.nik = self.registerData.nik
            //            data.email = self.registerData.email
            //            data.phone = self.registerData.noTelepon
            //            data.pin = self.registerData.pin
            //            data.password = self.registerData.password
            //            data.firstName = "Stevia"
            //            data.lastName = "R"
            //            data.email = self.registerData.email
            //
            //            UserDefaults.standard.set("true", forKey: "isFirstLogin")
            
            //            nextRoute = true
            
            if self.appState.nasabahIsExisting {
                self.nextRouteNasabah = true
            } else {
                self.nextRouteNonNasabah = true
            }
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Error saving managed object context: \(error)")
            }
        } else {
            
            print("GAGAL MENDAFTAR")
            showingAlert = true
        }
    }
    
    /* Save User To DB */
    func saveUserToDb() {
        
        self.isLoading = true
        
        self.userRegisterVM.userRegistration(registerData: registerData) { success in
            if success {
                if self.appState.nasabahIsExisting {
                    UserDefaults.standard.set("true", forKey: "register_nasabah")
                    UserDefaults.standard.set("false", forKey: "register_non_nasabah")
                    self.nextRouteNasabah = true
                } else {
                    UserDefaults.standard.set("false", forKey: "register_nasabah")
                    UserDefaults.standard.set("true", forKey: "register_non_nasabah")
                    self.nextRouteNonNasabah = true
                }
            }
            
            if !success {
                self.isLoading = false
                self.showingAlert = true
            }
        }
    }
    
    func clearData() {
        self.registerData.noTelepon = ""
        self.registerData.jenisTabungan = ""
        self.registerData.email = ""
        self.registerData.tujuanPembukaanId = 0
        self.registerData.tujuanPembukaan = ""
        self.registerData.sumberDanaId = 0
        self.registerData.sumberDana = ""
        self.registerData.perkiraanPenarikanId = 0
        self.registerData.perkiraanPenarikan = ""
        self.registerData.besarPerkiraanPenarikanId = 0
        self.registerData.besarPerkiraanPenarikan = ""
        self.registerData.perkiraanSetoranId = 0
        self.registerData.perkiraanSetoran = ""
        self.registerData.pekerjaanId = 0
        self.registerData.pekerjaan = ""
        self.registerData.besarPerkiraanSetoranId = 0
        self.registerData.besarPerkiraanSetoran = ""
        self.registerData.jabatanProfesiId = 0
        self.registerData.jabatanProfesi = ""
        self.registerData.namaPenyandangDana = ""
        self.registerData.hubunganPenyandangDana = ""
        self.registerData.profesiPenyandangDana = ""
        self.registerData.industriTempatBekerjaId = 0
        self.registerData.industriTempatBekerja = ""
        self.registerData.sumberPenyandangDanaId = 0
        self.registerData.sumberPenyandangDana = ""
        self.registerData.sumberPendapatanLainnyaId = 0
        self.registerData.sumberPendapatanLainnya = ""
        self.registerData.sumberPendapatanLain = ""
        self.registerData.namaPerusahaan = ""
        self.registerData.alamatPerusahaan = ""
        self.registerData.alamatKeluarga = ""
        self.registerData.kodePosKeluarga = ""
        self.registerData.kecamatanKeluarga = ""
        self.registerData.kelurahanKeluarga = ""
        self.registerData.noTlpKeluarga = ""
        self.registerData.kodePos = ""
        self.registerData.kecamatan = ""
        self.registerData.kelurahan = ""
        self.registerData.rtrw = ""
        self.registerData.noTeleponPerusahaan = ""
        self.registerData.penghasilanKotorId = 0
        self.registerData.penghasilanKotor = ""
        self.registerData.namaKeluarga = ""
        self.registerData.hubunganKekerabatanKeluarga = ""
        self.registerData.hubunganKekerabatan = ""
        self.registerData.password = ""
        self.registerData.pin = ""
        self.registerData.verificationAddressId = 1
        self.registerData.confirmationPin = ""
        self.registerData.npwp = ""
        self.registerData.hasNoNpwp = false
        self.registerData.namaLengkapFromNik = ""
        self.registerData.nomorKKFromNik = ""
        self.registerData.jenisKelaminFromNik = ""
        self.registerData.tempatLahirFromNik = ""
        self.registerData.tanggalLahirFromNik = ""
        self.registerData.agamaFromNik = ""
        self.registerData.statusPerkawinanFromNik = ""
        self.registerData.pendidikanFromNik = ""
        self.registerData.jenisPekerjaanFromNik = ""
        self.registerData.namaIbuFromNik = ""
        self.registerData.statusHubunganFromNik = ""
        self.registerData.alamatKtpFromNik = ""
        self.registerData.rtFromNik = ""
        self.registerData.rwFromNik = ""
        self.registerData.kelurahanFromNik = ""
        self.registerData.kecamatanFromNik = ""
        self.registerData.kabupatenKotaFromNik = ""
        self.registerData.provinsiFromNik = ""
        self.registerData.bidangUsaha = ""
    }
}

struct VerificationRegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationRegisterDataView().environmentObject(RegistrasiModel())
    }
}
