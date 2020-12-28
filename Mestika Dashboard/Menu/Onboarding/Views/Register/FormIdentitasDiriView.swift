//
//  FormIdentitasDiriView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI
import Combine

struct FormIdentitasDiriView: View {
    
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
    /*
     KTP
     */
    @State private var formKTP: Bool = true
    @State private var imageKTP: Image?
    @State private var nik: String = ""
    @State private var confirmNik: Bool = false
    @State private var shouldPresentKTP = true
    /*
     Selfie
     */
    @State private var formSelfie: Bool = false
    @State private var imageSelfie: Image?
    @State private var shouldPresentMaskSelfieCamera = false
    /*
     NPWP
     */
    @State private var formNPWP: Bool = false
    @State private var imageNPWP: Image?
    @State private var npwp: String = ""
    @State private var alreadyHaveNpwp: Bool = false
    /*
     Views Variables
     */
    @State private var shouldPresentScanner = true
    @State private var shouldPresentCamera = false
    @State private var cameraFileName = ""
    
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
                            
                            VStack(spacing: 10) {
                                
                                Button(action: {
                                    self.nextViewActive = true
                                }, label: {
                                    Text("Identitas Diri")
                                        .font(.custom("Montserrat-SemiBold", size: 18))
                                        .foregroundColor(Color(hex: "#F6F8FB"))
                                })
                                
                                Text("Silihkan isi dan lengkapi data identitas Anda")
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(hex: "#F6F8FB"))
                            }
                            .padding(.bottom, 30)
                            
                            // Form KTP
                            VStack {
                                DisclosureGroup("Foto KTP dan No. Induk Penduduk", isExpanded: self.$formKTP) {
                                    ScanKTPView(registerData: _registerData, imageKTP: $imageKTP, nik: $nik, confirmNik: $confirmNik,
                                                onChange: {
                                                    self.actionSelection("ktp")
                                                    self.shouldPresentScanner = true
                                                    self.shouldPresentCamera = true
                                                },
                                                onCommit: {
                                                    self.shouldPresentScanner = false
                                                    self.shouldPresentCamera = false
                                                    self.actionSelection("selfie")
                                                })
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 25)
                                .padding(.vertical)
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            
                            // Form Selfie
                            VStack {
                                DisclosureGroup("Ambil Foto sendiri atau Selfie", isExpanded: self.$formSelfie) {
                                    SelfieView(registerData: _registerData, imageSelfie: $imageSelfie,
                                               onChange: {
                                                self.actionSelection("selfie")
                                                self.shouldPresentScanner = false
                                                self.shouldPresentCamera = true
                                               },
                                               onCommit: {
                                                self.shouldPresentCamera = false
                                                self.actionSelection("npwp")
                                               })
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 25)
                                .padding(.vertical)
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            
                            // Form NPWP
                            VStack {
                                DisclosureGroup("Masukkan NPWP Anda", isExpanded: self.$formNPWP) {
                                    ScanNPWPView(registerData: _registerData, npwp: $npwp, alreadyHaveNpwp: $alreadyHaveNpwp, imageNPWP: $imageNPWP,
                                                 onChange: {
                                                    self.actionSelection("npwp")
                                                    self.shouldPresentScanner = true
                                                    self.shouldPresentCamera = true
                                                 },
                                                 onCommit: {
                                                    self.shouldPresentCamera = false
                                                    self.actionSelection("")
                                                 })
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 25)
                                .padding(.vertical)
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
                                
                                if isValidForm() {
                                    if editMode == .inactive {
                                        self.nextViewActive = true
                                    } else {
                                        self.backToSummary = true
                                    }
                                }
                                
                            }, label: {
                                Text("Lanjut Pembukaan Rekening Baru")
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
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .fullScreenCover(isPresented: $shouldPresentCamera) {
            
            if self.shouldPresentScanner {
                ZStack {
                    ScanningView(recognizedText: $recognizedText.value, cameraFileName: $cameraFileName)
                        .onDisappear(perform: {
                            if (recognizedText.value != "-") {
                                if self.cameraFileName == "ktp" {
                                    let matched = matches(for: "(\\d{13,16})", in: recognizedText.value)
                                    
                                    if matched.count != 0 {
                                        self.nik = matched[0]
                                    }
                                    
                                    print("self.cameraFileName \(self.cameraFileName)")
                                }
                                
                                let scanResult = retrieveImage(forKey: self.cameraFileName)
                                if let image = scanResult {
                                    switch self.cameraFileName {
                                    case "ktp":
                                        self.imageKTP = Image(uiImage: image)
                                        self.registerData.fotoKTP = imageKTP!
                                    case "npwp":
                                        self.imageNPWP = Image(uiImage: image)
                                        self.registerData.fotoNPWP = imageNPWP!
                                    default:
                                        print("retrieve image nil")
                                    }
                                }
                                
                            }
                        })
                    
                    if self.shouldPresentKTP {
                        VStack(alignment: .center){
                            Spacer()
                            HStack{
                                Text("\(Image(systemName: "checkmark")) Pastikan e-KTP anda asli dan bukan versi scan, unggah dan fotokopi")
                            }
                            HStack{
                                Text("\(Image(systemName: "checkmark")) Pastikan e-KTP tidak terpotong , data dan foto terlihat jelas")
                            }
                        }
                        .foregroundColor(.white)
                        .padding([.horizontal], 20)
                        .padding([.bottom], 140)
                    }
                       
                }
                
            }
            else {
                ZStack {
                    SUImagePickerView(sourceType: .camera, image: formNPWP ? self.$imageNPWP : self.$imageSelfie, isPresented: self.$shouldPresentCamera, frontCamera: self.$formSelfie)
                    
                    if self.shouldPresentMaskSelfieCamera {
                        Image("pattern_selfie")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.5)
                            .offset(y: -(UIScreen.main.bounds.height * 0.12))
                    }
                }
            }
        }
    }
    
    /*
     Fungsi untuk ambil Gambar dari Local Storage
     */
    private func actionSelection(_ selection: String) {
        self.cameraFileName = selection
        switch selection {
        case "ktp":
            self.formSelfie = false
            self.formNPWP = false
            self.formKTP = true
            self.shouldPresentKTP = true
            self.shouldPresentMaskSelfieCamera = false
        case "selfie":
            self.formKTP = false
            self.formNPWP = false
            self.formSelfie = true
            self.shouldPresentKTP = false
            self.shouldPresentMaskSelfieCamera = true
        case "npwp":
            self.formKTP = false
            self.formSelfie = false
            self.formNPWP = true
            self.shouldPresentKTP = false
            self.shouldPresentMaskSelfieCamera = false
        default:
            self.formKTP = false
            self.formSelfie = false
            self.formNPWP = false
            self.shouldPresentKTP = true
            self.shouldPresentScanner = true
            self.shouldPresentMaskSelfieCamera = false
            self.shouldPresentCamera = false
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
