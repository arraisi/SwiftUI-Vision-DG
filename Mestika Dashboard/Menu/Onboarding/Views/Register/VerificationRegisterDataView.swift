//
//  VerificationRegisterDataView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI
import Indicators

struct VerificationRegisterDataView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    var productATMData = AddProductATM()
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    
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
    @State private var shouldPresentCameraSelfie = false
    
    @State private var errorMessage: String = ""
    
    @State private var cameraFileName = ""
    
    @State private var imageTaken: Image?
    
    @State var isLoading = false
    
    @ObservedObject private var userRegisterVM = UserRegistrationViewModel()
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    @State private var showingAlert: Bool = false
    @State var isShowingAlert: Bool = false
    @State var showCancelAlert = false
    @State var showingNpwpModal = false
    
    @State private var npwp = ""
    
    var disableSaveNpwpBtn: Bool {
        self.npwp.count < 15
    }
    
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
                    self.isShowingAlert = true
                }
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                
                ScrollView {
                    VStack {
                        Text(NSLocalizedString("MAKE SURE YOUR INFORMATION IS CORRECT".localized(language), comment: ""))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .leading) {
                            Group {
                                LabelTextFieldWithIcon(value: $registerData.nik, label: NSLocalizedString("Identity Card/(KTP)".localized(language), comment: ""), placeHolder: NSLocalizedString("Identity Card/(KTP)".localized(language), comment: "")) {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 20)
                                .padding(.horizontal, 20)
                                .disabled(true)
                                
                                LabelTextFieldWithIcon(value: $registerData.noTelepon, label: NSLocalizedString("Phone Number".localized(language), comment: ""), placeHolder: NSLocalizedString("Phone Number".localized(language), comment: "")) {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 10)
                                .padding(.horizontal, 20)
                                .disabled(true)
                                
                                LabelTextFieldWithIcon(value: $registerData.email, label: "Email", placeHolder: "Email") {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 10)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .disabled(true)
                                
                                LabelTextFieldWithIcon(value: $registerData.npwp, label: "NPWP", placeHolder: "NPWP") {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 10)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .disabled(true)
                                
                            }
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                        VStack(alignment: .leading) {
                            Group {
                                // KTP ROW
                                VStack {
                                    
                                    Button(action: {
                                        self.cameraFileName = "ktp"
                                        self.shouldPresentCamera = true
                                    }) {
                                        HStack {
                                            Text(NSLocalizedString("Photo Identity Card/(KTP)".localized(language), comment: ""))
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
                                    .fullScreenCover(isPresented: $shouldPresentCamera) {
                                        scanner
                                    }
                                    
                                    Divider()
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                
                                // SELFIE ROW
                                VStack {
                                    
                                    Button(action: {
                                        self.cameraFileName = "selfie"
                                        // self.shouldPresentMaskSelfie = true
                                        self.shouldPresentCameraSelfie = true
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
                                    .fullScreenCover(isPresented: $shouldPresentCameraSelfie) {
                                        camera
                                    }
                                    Divider()
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                
                                // NPWP ROW
                                //                                if self.registerData.npwp != "" {
                                VStack {
                                    
                                    Button(action: {
                                        self.cameraFileName = "npwp"
                                        self.shouldPresentCamera = true
                                    }) {
                                        HStack {
                                            Text(self.registerData.fotoNPWP != Image("") ? NSLocalizedString("Your NPWP photo".localized(language), comment: "")  : NSLocalizedString("Add NPWP".localized(language), comment: ""))
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "#232175"))
                                                .fontWeight(.bold)
                                            Spacer()
                                            
                                            VStack {
                                                if self.registerData.fotoNPWP != Image("") {
                                                    self.registerData.fotoNPWP
                                                        .resizable()
                                                        .frame(maxWidth: 80, maxHeight: 50)
                                                        .cornerRadius(8)
                                                } else {
                                                    Image("ic_camera")
                                                        .resizable()
                                                        .frame(maxWidth: 50, maxHeight: 36)
                                                }
                                            }
                                            .frame(maxWidth: 80, minHeight: 50, maxHeight: 50)
                                        }
                                    }
                                    .fullScreenCover(isPresented: $shouldPresentCamera) {
                                        scanner
                                    }
                                    Divider()
                                }
                                .padding([.top, .bottom], 20)
                                .padding(.horizontal, 20)
                                //                                }
                            }
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                        VStack(alignment: .leading) {
                            Group {
                                Group {
                                    
                                    Text(NSLocalizedString("Types of Savings".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Types of Savings".localized(language), comment: ""), text: $registerData.jenisTabungan)
                                            .disabled(true)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: FormPilihJenisTabunganView(shouldPopToRootView: .constant(false), editMode: .active).environmentObject(registerData).environmentObject(productATMData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    Text(NSLocalizedString("Account Opening Purpose".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Account Opening Purpose".localized(language), comment: ""), text: $registerData.tujuanPembukaan)
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
                                    
                                    Text(NSLocalizedString("Source of funds".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Source of funds".localized(language), comment: ""), text: $registerData.sumberDana)
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
                                    
                                    
                                    Text(NSLocalizedString("Estimated Withdrawal".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Estimated Withdrawal".localized(language), comment: ""), text: $registerData.perkiraanPenarikan)
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
                                    Text(NSLocalizedString("Estimated Withdrawal Size".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Estimated Withdrawal Size".localized(language), comment: ""), text: $registerData.besarPerkiraanPenarikan)
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
                                    
                                    Text(NSLocalizedString("Estimated Deposit".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Estimated Deposit".localized(language), comment: ""), text: $registerData.perkiraanSetoran)
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
                                    
                                    Text(NSLocalizedString("Estimated Deposit Size".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Estimated Deposit Size".localized(language), comment: ""), text: $registerData.besarPerkiraanPenarikan)
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
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                        VStack(alignment: .leading) {
                            Group {
                                Group {
                                    
                                    Text(NSLocalizedString("Profession".localized(language), comment: ""))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                    
                                    HStack {
                                        TextField(NSLocalizedString("Profession".localized(language), comment: ""), text: $registerData.pekerjaan)
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
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                        VStack(alignment: .leading) {
                            Group {
                                // MARK : Pekerjaan Wiraswasta
                                if [10, 11, 12].contains(registerData.pekerjaanId) {
                                    informasiPenyandangDanaFields
                                } else {
                                    InformasiPerusahaanVerificationView()
                                        .padding(.bottom, 5)
                                }
                            }
                            Spacer()
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                        VStack(alignment: .leading) {
                            Group {
                                InformasiKeluargaVerificationView()
                                    .padding(.bottom, 20)
                            }
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 35)
                }
                
                VStack {
                    Button(action: {
                        
                        saveUserToDb()
                        
                    }, label: {
                        Text(NSLocalizedString("Submit Data".localized(language), comment: ""))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .background(Color(hex: self.isLoading ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 100)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .disabled(self.isLoading)
                    
                    NavigationLink(
                        destination: SuccessRegisterView(isAllowBack: false).environmentObject(registerData),
                        isActive: self.$nextRouteNonNasabah,
                        label: {}
                    )
                    
                    NavigationLink(
                        destination: FormPilihJenisATMView().environmentObject(registerData).environmentObject(productATMData),
                        isActive: self.$nextRouteNasabah,
                        label: {EmptyView()}
                    )
                }
                .background(Color.white)
            }
            
            if self.showingNpwpModal {
                ZStack {
                    ModalOverlay(tapAction: {})
                        .edgesIgnoringSafeArea(.all)
                    
                    popUpNpwp()
                }
                .transition(.asymmetric(insertion: .opacity, removal: .fade))
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.isShowingAlert = true
            }
        }))
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text(NSLocalizedString("MESSAGE".localized(language), comment: "")),
                message: Text("\(self.errorMessage)"),
                dismissButton: .default(Text("Oke")))
        }
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Do you want to cancel registration?".localized(language), comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YES".localized(language), comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("NO".localized(language), comment: ""))))
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
                        self.registerData.hasNoNpwp = true
                        self.registerData.npwp = ""
                        self.registerData.fotoNPWP = Image(uiImage: image)
                        self.showingNpwpModal = true
                    default:
                        print("retrieve image nil")
                    }
                }
            })
    }
    
    var camera: some View {
        ZStack {
            SUImagePickerView(sourceType: .camera, image: $imageTaken, isPresented: $shouldPresentCameraSelfie, frontCamera: .constant(true))
                .onDisappear {
                    if let image = imageTaken {
                        registerData.fotoSelfie = image
                    }
                }
            Image("pattern_selfie")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .offset(y: -(UIScreen.main.bounds.height * 0.12))
        }
    }
    
    var dynamicForm: some View {
        VStack(alignment: .leading) {
            
            // MARK : Pekerjaan BUMN
            if [6 ,9, 10, 11, 12].contains(registerData.pekerjaanId) {
                
                if registerData.pekerjaanId == 6 {
                    Text(NSLocalizedString("Position".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField(NSLocalizedString("Position".localized(language), comment: ""), text: $registerData.jabatanProfesi)
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
                
                // MARK : Pekerjaan Pensiunan, Pelajar, IRT
                if (registerData.pekerjaanId == 10 || registerData.pekerjaanId == 11 || registerData.pekerjaanId == 12) {
                    EmptyView()
                } else {
                    
                    // MARK : Pekerjaan Wiraswasta
                    if registerData.pekerjaanId == 9 {
                        Text(NSLocalizedString("Industry".localized(language), comment: ""))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            TextField(NSLocalizedString("Industry".localized(language), comment: ""), text: $registerData.industriTempatBekerja)
                                .disabled(true)
                            
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
                    
                    Text(NSLocalizedString("Gross Income".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField(NSLocalizedString("Gross Income".localized(language), comment: ""), text: $registerData.penghasilanKotor)
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
                
            }
            
            Text(NSLocalizedString("Other Sources of Income".localized(language), comment: ""))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            
            HStack {
                TextField(NSLocalizedString("Other Sources of Income".localized(language), comment: ""), text: $registerData.sumberPendapatanLainnya)
                    .disabled(true)
                
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
        }
    }
    
    var informasiPenyandangDanaFields: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(NSLocalizedString("Funder Information".localized(language), comment: ""))
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
                Text(NSLocalizedString("Name of Funder".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Name of Funder".localized(language), comment: ""), text: $registerData.namaPenyandangDana)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text(NSLocalizedString("Relationship With You".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Relationship With You".localized(language), comment: ""), text: $registerData.hubunganPenyandangDana)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text(NSLocalizedString("Profession Funders".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Profession Funders".localized(language), comment: ""), text: $registerData.profesiPenyandangDana)
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
    
    // MARK:- CREATE POPUP MESSAGE
    func popUpNpwp() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(NSLocalizedString("NPWP Number".localized(language), comment: ""))
                .multilineTextAlignment(.leading)
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
            
            //            TextFieldValidation(data: $registerData.npwp, title: "No. NPWP", disable: false, isValid: false, keyboardType: .numberPad) { (str: Array<Character>) in
            //                self.registerData.npwp = String(str.prefix(15))
            //            }
            
            TextField(NSLocalizedString("NPWP Number".localized(language), comment: ""), text: $npwp)
                .frame(height: 10)
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(.black)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .onReceive(npwp.publisher.collect()) {
                    self.npwp = String($0.prefix(15))
                }
            
            Button(action: {
                self.registerData.npwp = self.npwp
                print("REGISTER DATA NPWP : \(self.registerData.npwp)")
                self.showingNpwpModal.toggle()
            }) {
                Text(NSLocalizedString("Save".localized(language), comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: disableSaveNpwpBtn ? "#CBD1D9" : "#2334D0"))
            .cornerRadius(12)
            .disabled(disableSaveNpwpBtn)
        }
        .padding()
        .padding(.vertical, 25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
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
        print("------SAVE TO CORE DATA-------")
        
        let data = Registration(context: managedObjectContext)
        data.id = 1
        data.nik = self.registerData.nik
        data.noTelepon = self.registerData.noTelepon
        data.jenisTabungan = self.registerData.jenisTabungan
        data.email = self.registerData.email
        data.pekerjaanId = Int16(self.registerData.pekerjaanId)
        data.pekerjaan = self.registerData.pekerjaan
        
        // Data ATM
        data.atmOrRekening = self.registerData.atmOrRekening
        data.noAtm = self.registerData.noAtm
        data.noRekening = self.registerData.noRekening
        data.accNo = self.registerData.accNo
        
        // Data From NIK
        data.namaLengkapFromNik = self.registerData.namaLengkapFromNik
        data.addressInput = self.registerData.alamatKtpFromNik
        data.addressKecamatanInput = self.registerData.addressKecamatanInput
        data.addressKelurahanInput = self.registerData.addressKelurahanInput
        data.addressPostalCodeInput = self.registerData.addressPostalCodeInput
        data.rtFromNik = self.registerData.rtFromNik
        data.kabupatenKotaFromNik = self.registerData.kabupatenKotaFromNik
        data.provinsiFromNik = self.registerData.provinsiFromNik
        data.nomorKKFromNik = self.registerData.nomorKKFromNik
        data.jenisKelaminFromNik = self.registerData.jenisKelaminFromNik
        data.tempatLahirFromNik = self.registerData.tempatLahirFromNik
        data.tanggalLahirFromNik = self.registerData.tanggalLahirFromNik
        data.agamaFromNik = self.registerData.agamaFromNik
        data.statusPerkawinanFromNik = self.registerData.statusPerkawinanFromNik
        data.pendidikanFromNik = self.registerData.pendidikanFromNik
        data.jenisPekerjaanFromNik = self.registerData.jenisPekerjaanFromNik
        data.namaIbuFromNik = self.registerData.namaIbuFromNik
        data.statusHubunganFromNik = self.registerData.statusHubunganFromNik
        
        // Data Perusahaan
        data.namaPerusahaan = self.registerData.namaPerusahaan
        data.alamatPerusahaan = self.registerData.alamatPerusahaan
        data.kodePos = self.registerData.kodePos
        data.kecamatan = self.registerData.kecamatan
        data.kelurahan = self.registerData.kelurahan
        data.rtrw = self.registerData.rtrw
        
        // Data Surat Menyurat
        data.alamatKeluarga = self.registerData.alamatKeluarga
        data.kodePosKeluarga = self.registerData.kodePosKeluarga
        data.kecamatanKeluarga = self.registerData.kecamatanKeluarga
        data.kelurahanKeluarga = self.registerData.kelurahanKeluarga
        
        data.isNasabahMestika = self.appState.nasabahIsExisting ? true : false
        data.isAddressEqualToDukcapil = self.registerData.isAddressEqualToDukcapil
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    /* Save User To DB */
    func saveUserToDb() {
        self.isLoading = true
        self.userRegisterVM.userRegistration(registerData: registerData) { success in
            if success {
                saveUserToCoreData()
                if self.appState.nasabahIsExisting {
                    self.nextRouteNasabah = true
                } else {
                    self.nextRouteNasabah = true
//                    self.nextRouteNonNasabah = true
                }
            }
            
            if !success {
                self.isLoading = false
                self.errorMessage = self.userRegisterVM.message
                self.showingAlert = true
            }
        }
    }
}

struct VerificationRegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationRegisterDataView().environmentObject(RegistrasiModel())
    }
}
