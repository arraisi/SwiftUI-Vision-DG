//
//  DataVerificationRegisterNasabahView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/12/20.
//

import SwiftUI
import Indicators

struct DataVerificationRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    var productATMData = AddProductATM()
    @EnvironmentObject var appState: AppState
    
    @State var image: Image? = nil
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var nextRoute: Bool = false
    @State private var editImageSelection: String = ""
    @State private var shouldPresentCamera: Bool = false
    @State private var shouldPresentMaskSelfie: Bool = false
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
                        
                        VStack(alignment: .leading) {
                            
                            Image("ic_highfive")
                                .resizable()
                                .frame(width: 95, height: 95)
                                .padding(.top, 40)
                                .padding(.horizontal, 20)
                            
                            HStack {
                                Text("Hi, ")
                                    .font(.custom("Montserrat-Bold", size: 24))
                                    .foregroundColor(Color(hex: "#232175"))
                                    .padding([.top, .bottom], 20)
                                    .padding(.leading, 20)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text("\(registerData.email)")
                                    .font(.custom("Montserrat-Bold", size: 24))
                                    .foregroundColor(Color(hex: "#2334D0"))
                                    .padding([.top, .bottom], 20)
                                    .padding(.trailing, 20)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Anda telah memilih mendaftar jenis tabungan")
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .foregroundColor(Color(hex: "#707070"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 5)
                                    .padding(.horizontal, 20)
                                
                                Text("Deposit Tabungan.")
                                    .font(.custom("Montserrat-SemiBold", size: 12))
                                    .foregroundColor(Color(hex: "#2334D0"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20)
                            }
                            
                            Text("Sebelum melanjutkan proses pendaftaran, silahkan terlebih dahulu memverifikasi data yang telah Anda Isi.")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#707070"))
                                .multilineTextAlignment(.leading)
                                .padding(.top, 15)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                            
                            Group {
                                LabelTextFieldWithIcon(value: $registerData.nik, label: "KTP", placeHolder: "KTP") {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 20)
                                .padding(.horizontal, 20)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                
                                LabelTextFieldWithIcon(value: $registerData.noTelepon, label: "No. Telepon", placeHolder: "No. Telepon") {
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
                                
                                VStack {
                                    
                                    Button(action: {
                                        self.editImageSelection = "ktp"
                                        self.shouldPresentMaskSelfie = false
                                        self.shouldPresentCamera = true
                                    }) {
                                        HStack {
                                            Text("Foto KTP")
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
                                
                                VStack {
                                    
                                    Button(action: {
                                        self.editImageSelection = "selfie"
                                        self.shouldPresentMaskSelfie = true
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
                                
                                if self.registerData.npwp != "" {
                                    VStack {
                                        
                                        Button(action: {
                                            self.editImageSelection = "npwp"
                                            self.shouldPresentMaskSelfie = false
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
                                    
                                    Text("Tujuan Pembukaan Rekening")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField("Tujuan Pembukaan Rekening", text: $registerData.tujuanPembukaan)
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
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
                                    
                                    Text("Sumber Dana")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField("Sumber Dana", text: $registerData.sumberDana)
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
                                    
                                    
                                    Text("Perkiraan Penarikan")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField("Perkiraan Penarikan", text: $registerData.perkiraanPenarikan)
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
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
                                    Text("Besar Perkiraan Penarikan")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField("Besar Perkiraan Penarikan", text: $registerData.besarPerkiraanPenarikan)
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
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
                                    
                                    Text("Perkiraan Setoran")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField("Perkiraan Setoran", text: $registerData.perkiraanSetoran)
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
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
                                    
                                    Text("Besar Perkiraan Setoran")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField("Besar Perkiraan Setoran", text: $registerData.besarPerkiraanPenarikan)
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
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
                                    
                                    Text("Pekerjaan")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField("Pekerjaan", text: $registerData.pekerjaan)
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
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
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 30)
                    //                    .padding(.top, 90)
                    .padding(.bottom, 35)
                }
                
                VStack {
                    Button(action: {
                        
                        //                        saveUserToCoreData()
                        saveUserToDb()
                        
                    }, label: {
                        Text("Submit Data")
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
                        destination: VerificationPINView().environmentObject(registerData).environmentObject(productATMData),
                        isActive: self.$nextRoute,
                        label: {EmptyView()}
                    )
                    
//                    NavigationLink(
//                        destination: SuccessRegisterView().environmentObject(registerData),
//                        isActive: self.$nextRoute,
//                        label: {}
//                    )
                }
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        //        .navigationBarItems(
        //            trailing: LoadingIndicator(style: .medium, animate: .constant(self.userRegisterVM.isLoading))
        //                .configure {
        //                    $0.color = .white
        //                })
        //        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $shouldPresentCamera, onDismiss: {
            print("Hello on DISMISS SHEET")
            switch self.editImageSelection {
            case "ktp":
                self.registerData.fotoKTP = self.imageTaken ?? Image("")
            case "selfie":
                self.registerData.fotoSelfie = self.imageTaken ?? Image("")
            case "npwp":
                self.registerData.fotoNPWP = self.imageTaken ?? Image("")
            default:
                self.registerData.fotoKTP = self.imageTaken ?? Image("")
            }
            
        }) {
            
            ZStack {
                SUImagePickerView(sourceType: .camera, image: self.$imageTaken, isPresented: self.$shouldPresentCamera, frontCamera: self.$shouldPresentMaskSelfie)
                
                if self.shouldPresentMaskSelfie {
                    Image("pattern_selfie")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.5)
                        .offset(y: -(UIScreen.main.bounds.height * 0.1))
                }
            }
            
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Message"),
                message: Text("\(self.userRegisterVM.message)"),
                dismissButton: .default(Text("Oke")))
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
                    Text("Penghasilan Kotor")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Penghasilan Kotor", text: $registerData.penghasilanKotor)
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
                    Text("Jabatan")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Jabatan", text: $registerData.jabatanProfesi)
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
                    Text("Industri")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Industri", text: $registerData.industriTempatBekerja)
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
            
            Text("Sumber Pendapatan Lainnya")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            
            HStack {
                TextField("Sumber Pendapatan Lainnya", text: $registerData.sumberPendapatanLainnya)
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
                Text("Informasi Penyandang Dana")
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
                Text("Nama Penyandang Dana")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nama Penyandang Dana", text: $registerData.namaPenyandangDana)
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
                Text("Hubungan Dengan Anda")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Hubungan Dengan Anda", text: $registerData.hubunganPenyandangDana)
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
                Text("Profesi Penyandang Dana")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Profesi Penyandang Dana", text: $registerData.profesiPenyandangDana)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
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
            
            nextRoute = true
            
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
        
//        self.registerData.noTelepon = "85875074351"
//        self.registerData.email = "primajatnika271995@gmail.com"
//        self.registerData.nik = "5106040309800927"
//        self.registerData.namaLengkapFromNik = "DATA TEST T 03"
//        self.registerData.tempatLahirFromNik = "LAHIR"
//        self.registerData.alamatKtpFromNik = "JL PROF DR LATUMETEN I GG.5/6"
//        self.registerData.rtFromNik = "02"
//        self.registerData.rwFromNik = "03"
//        self.registerData.kelurahanFromNik = "ANDIR"
//        self.registerData.kecamatanFromNik = "ANDIR"
//        self.registerData.kabupatenKotaFromNik = "ANDIR"
//        self.registerData.provinsiFromNik = "JAWA BARAT"
        
        self.userRegisterVM.userRegistration(registerData: registerData) { success in
            if success {
                self.isLoading = false
                nextRoute = true
            }
            
            if !success {
                self.isLoading = false
                self.showingAlert = true
            }
        }
    }
}

struct DataVerificationNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        DataVerificationRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
