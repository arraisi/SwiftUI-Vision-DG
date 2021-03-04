//
//  FormIdentitasDiriView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI
import Combine

struct FormIdentitasDiriView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /*
     Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    // Routing variables
    @State var editMode: EditMode = .inactive
    @State private var nextViewActive = false
    @State private var backToSummary = false
    /*
     Recognized Nomor Induk Ktp
     */
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    
    /* KTP */
    @State private var formKTP: Bool = true
    @State private var imageKTP: Image?
    @State private var nik: String = ""
    @State private var confirmNik: Bool = false
    @State private var showKTPPreview: Bool = false
    
    /* Selfie */
    @State private var formSelfie: Bool = false
    @State private var imageSelfie: Image?
    @State private var showSelfiePreview: Bool = false
    
    /* NPWP */
    @State private var formNPWP: Bool = false
    @State private var imageNPWP: Image?
    @State private var npwp: String = ""
    @State private var alreadyHaveNpwp: Bool = false
    @State private var showNPWPPreview: Bool = false
    
    /* Views Variables */
    @State private var shouldPresentScannerKtp = false
    @State private var shouldPresentScannerNpwp = false
    @State private var shouldPresentCamera = false
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                
                AppBarLogo(light: false, showCancel: false) {
                    self.appState.moveToWelcomeView = true
                }
                
                ScrollView(showsIndicators: false) {
                    
                    ZStack(alignment: .top) {
                        
                        VStack {
                            Color(hex: "#232175")
                                .frame(height: 170)
                            Color(hex: "#F6F8FB")
                        }
                        
                        // content here
                        VStack(spacing: 25) {
                            
                            VStack(spacing: 5) {
                                
                                Button(action: {
                                    //                                    self.nextViewActive = true
                                }, label: {
                                    Text("PERSONAL IDENTITY".localized(language))
                                        .font(.custom("Montserrat-ExtraBold", size: 24))
                                        .foregroundColor(.white)
                                })
                                
                                Text("Please fill in and complete your identity data".localized(language))
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(hex: "#F6F8FB"))
                            }
                            .padding(.bottom, 30)
                            
                            // Form KTP
                            VStack {
                                DisclosureGroup("Photo of KTP and ID Number of Population".localized(language), isExpanded: self.$formKTP) {
                                    ScanKTPView(registerData: _registerData, imageKTP: $imageKTP, nik: $nik, confirmNik: $confirmNik, preview: $showKTPPreview,
                                                onChange: {
                                                    self.actionSelection("ktp")
                                                    self.shouldPresentScannerKtp = true
                                                },
                                                onCommit: {
                                                    self.actionSelection("selfie")
                                                })
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 25)
                                .padding(.vertical)
                                .fullScreenCover(isPresented: $shouldPresentScannerKtp) {
                                    scannerKtp
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            
                            // Form Selfie
                            VStack {
                                DisclosureGroup("Take Self Photo or Selfie".localized(language), isExpanded: self.$formSelfie) {
                                    SelfieView(registerData: _registerData, imageSelfie: $imageSelfie, preview: $showSelfiePreview,
                                               onChange: {
                                                self.actionSelection("selfie")
                                                self.shouldPresentCamera = true
                                               },
                                               onCommit: {
                                                self.actionSelection("npwp")
                                               })
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 25)
                                .padding(.vertical)
                                .fullScreenCover(isPresented: $shouldPresentCamera) {
                                    camera
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            
                            // Form NPWP
                            VStack {
                                DisclosureGroup("Enter your NPWP".localized(language), isExpanded: self.$formNPWP) {
                                    ScanNPWPView(registerData: _registerData, npwp: $npwp, alreadyHaveNpwp: $alreadyHaveNpwp, imageNPWP: $imageNPWP, preview: $showNPWPPreview,
                                                 onChange: {
                                                    self.actionSelection("npwp")
                                                    self.shouldPresentScannerNpwp = true
                                                 },
                                                 onCommit: {
                                                    self.actionSelection("")
                                                 })
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 25)
                                .padding(.vertical)
                                .fullScreenCover(isPresented: $shouldPresentScannerNpwp) {
                                    scannerNpwp
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            
                            NavigationLink(
                                destination: TujuanPembukaanRekeningView().environmentObject(registerData),
                                isActive: self.$nextViewActive,
                                label: {EmptyView()})
                            
                            NavigationLink(
                                destination: VerificationRegisterDataView().environmentObject(registerData),
                                isActive: self.$backToSummary,
                                label: {EmptyView()})
                            
                            Button(action: {
                                
                                self.registerData.npwp = self.npwp
                                print("NIK \(self.registerData.nik)")
                                UserDefaults.standard.set(self.registerData.nik, forKey: "nik_local_storage")
                                UserDefaults.standard.set(self.registerData.namaLengkapFromNik, forKey: "nama_local")
                                
                                if isValidForm() {
                                    if editMode == .inactive {
                                        self.nextViewActive = true
                                    } else {
                                        self.backToSummary = true
                                    }
                                }
                                
                            }, label: {
                                Text("Continue to Open New Account".localized(language))
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 16))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            })
                            .background(Color(hex: !isValidForm() ? "#CBD1D9" : "#232175"))
                            .cornerRadius(12)
                            .disabled(!isValidForm())
                        }
                        .padding(20)
                        .padding(.vertical, 25)
                    }
                    
                    EmptyView()
                        .sheet(isPresented: $showKTPPreview){
                            
                            ZoomableScrollView {
                                imageKTP?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }
                    
                    EmptyView()
                        .sheet(isPresented: $showSelfiePreview){
                            
                            ZoomableScrollView {
                                imageSelfie?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }
                    
                    EmptyView()
                        .sheet(isPresented: $showNPWPPreview){
                            
                            ZoomableScrollView {
                                imageNPWP?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }
                }
                .background(
                    VStack {
                        Color(hex: "#232175").edgesIgnoringSafeArea(.all)
                            .frame(height: UIScreen.main.bounds.height/3)
                        Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all)
                    })
                .KeyboardAwarePadding()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
//        .alert(isPresented: $showingAlert) {
//            return Alert(
//                title: Text("Apakah ingin membatalkan registrasi ?"),
//                primaryButton: .default(Text("YA"), action: {
//                    self.appState.moveToWelcomeView = true
//                }),
//                secondaryButton: .cancel(Text("Tidak")))
//        }
//        .gesture(DragGesture().onEnded({ value in
//            if(value.startLocation.x < 20 &&
//                value.translation.width > 50) {
//                self.showingAlert = true
//            }
//        }))
    }
    
    var camera: some View {
        ZStack {
            SUImagePickerView(sourceType: .camera, image: self.$imageSelfie, isPresented: self.$shouldPresentCamera, frontCamera: self.$formSelfie)
            
            Image("pattern_selfie")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .offset(y: -(UIScreen.main.bounds.height * 0.12))
            
        }
    }
    
    var scannerKtp: some View {
        ZStack {
            ScanningView(recognizedText: $recognizedText.value, cameraFileName: .constant("ktp"))
                .onDisappear(perform: {
                    if (recognizedText.value != "-") {
                        let matched = matches(for: "(\\d{13,16})", in: recognizedText.value)
                        
                        if matched.count != 0 {
                            self.nik = matched[0]
                        }
                    }
                    
                    print("recognizedText.value \(recognizedText.value)")
                    
                    let scanResult = retrieveImage(forKey: "ktp")
                    if let image = scanResult {
                        self.imageKTP = Image(uiImage: image)
                        self.registerData.fotoKTP = imageKTP!
                    }
                })
            
            VStack(alignment: .center){
                Spacer()
                HStack {
                    Image(systemName: "checkmark")
                    Text("Make sure your e-KTP is genuine and not a scanned, uploaded or photocopy version".localized(language))
                }
                HStack{
                    Image(systemName: "checkmark")
                    Text("Make sure the e-KTP is not cut off, data and photos are clearly visible".localized(language))
                }
            }
            .foregroundColor(.white)
            .padding([.horizontal], 20)
            .padding([.bottom], 140)
            
        }
    }
    
    
    var scannerNpwp: some View {
        ZStack {
            ScanningView(recognizedText: $recognizedText.value, cameraFileName: .constant("npwp"))
                .onDisappear(perform: {
                    let scanResult = retrieveImage(forKey: "npwp")
                    if let image = scanResult {
                        self.imageNPWP = Image(uiImage: image)
                        self.registerData.fotoNPWP = imageNPWP!
                    }
                    
                        
                })
        }
    }
    
    /*
     Fungsi untuk ambil Gambar dari Local Storage
     */
    private func actionSelection(_ selection: String) {
        switch selection {
        case "ktp":
            self.formSelfie = false
            self.formNPWP = false
            self.formKTP = true
        case "selfie":
            self.formKTP = false
            self.formNPWP = false
            self.formSelfie = true
        case "npwp":
            self.formKTP = false
            self.formSelfie = false
            self.formNPWP = true
        default:
            self.formKTP = false
            self.formSelfie = false
            self.formNPWP = false
            self.shouldPresentScannerKtp = false
            self.shouldPresentCamera = false
            self.shouldPresentScannerNpwp = false
        }
    }
    
    /*
     Fungsi untuk cek form sudah terisi valid semua atau belum
     */
    private func isValidForm() -> Bool {
        return imageKTP != nil
            && registerData.nik != ""
            && confirmNik
            && ((registerData.npwp != "" || imageNPWP != nil || alreadyHaveNpwp) && !self.formNPWP)
            && imageSelfie != nil
    }
    
    /*
     Fungsi untuk ambil Gambar dari Local Storage
     */
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
           let image = UIImage(data: imageData) {
            print(image)
            return image
        }
        
        return nil
    }
    
    /*
     Fungsi Regex NIK
     */
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

struct FormIdentitasDiriView_Previews: PreviewProvider {
    static var previews: some View {
        FormIdentitasDiriView().environmentObject(RegistrasiModel())
    }
}
