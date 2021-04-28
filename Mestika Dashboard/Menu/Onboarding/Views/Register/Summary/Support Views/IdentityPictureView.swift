//
//  IdentityPictureView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 27/04/21.
//

import SwiftUI

struct IdentityPictureView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    var productATMData = AddProductATM()
    @EnvironmentObject var appState: AppState
    
    @State private var shouldPresentCamera = false
    @State private var shouldPresentCameraSelfie = false
    
    @State private var imageTaken: Image?
    @State private var cameraFileName = ""
    @State var showingNpwpModal = false
    
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    
    var body: some View {
        VStack(alignment: .leading) {
            // KTP ROW
            VStack {
                
                Button(action: {
                    self.cameraFileName = "ktp"
                    self.shouldPresentCamera = true
                }) {
                    HStack {
                        Text("Photo Identity Card/(KTP)".localized(language))
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
            // if self.registerData.npwp != "" {
            VStack {
                
                Button(action: {
                    self.cameraFileName = "npwp"
                    self.shouldPresentCamera = true
                }) {
                    HStack {
                        Text(self.registerData.fotoNPWP != Image("") ? "Your NPWP photo".localized(language)  : "Add NPWP".localized(language))
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
        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        .padding(.bottom, 10)
        .shadow(radius: 2)
        
    }
    
    var scanner: some View {
        ScanningView(recognizedText: $recognizedText.value, cameraFileName: $cameraFileName)
            .onDisappear(perform: {
                let scanResult = retrieveImage(forKey: self.cameraFileName)
                
                if let image = scanResult {
                    switch self.cameraFileName {
                    case "ktp":
                        self.registerData.fotoKTP = Image(uiImage: image)
                        print("\nretrieve image ktp")
                    case "npwp":
                        self.registerData.hasNoNpwp = true
                        self.registerData.npwp = ""
                        self.registerData.fotoNPWP = Image(uiImage: image)
                        self.showingNpwpModal = true
                        print("\nretrieve image npwp")
                    default:
                        print("\nretrieve image nil")
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
    
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
           let image = UIImage(data: imageData) {
            return image
        }
        
        return nil
    }
}

struct IdentityPictureView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityPictureView().environmentObject(RegistrasiModel())
    }
}
