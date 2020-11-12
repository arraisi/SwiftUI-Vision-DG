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
    
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var shouldPresentMaskSelfieCamera = false
    
    @State private var formKTP: Bool = true
    @State private var confirmNik: Bool = false
    @State private var formSelfie: Bool = false
    @State private var formNPWP: Bool = false
    @State private var alreadyHaveNpwp: Bool = false
    @State private var npwp: String = ""
    
    @State private var imageKTP: Image?
    @State private var imageSelfie: Image?
    @State private var imageNPWP: Image?
    
    @State private var nextViewActive = false
    
    var body: some View {
        
        ScrollView {
            ZStack {
                VStack {
                    Color(hex: "#232175")
                        .frame(height: 200)
                    Color(hex: "#F6F8FB")
                }
                
                // content here
                VStack {
                    Text("Identitas Diri")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#F6F8FB"))
                        .padding([.top], 60)
                        .padding([.horizontal], 30)
                    
                    Text("Silihkan isi dan lengkapi data identitas Anda")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#F6F8FB"))
                        .padding(.top, 5)
                        .padding([.horizontal], 30)
                    
                    // Form KTP
                    VStack {
                        DisclosureGroup("Foto KTP dan No. Induk Penduduk", isExpanded: $formKTP) {
                            ScanKTPView(registerData: _registerData, imageKTP: $imageKTP, formShowed: $formKTP, nextFormShowed: $formSelfie, confirmNik: $confirmNik)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding([.horizontal, .top], 30)
                    .padding([.top], 30)
                    
                    // Form Selfie
                    VStack {
                        DisclosureGroup("Ambil Foto sendiri atau Selfie", isExpanded: $formSelfie) {
                            SelfieView(registerData: _registerData, imageSelfie: $imageSelfie, shouldPresentActionScheet: $shouldPresentActionScheet, showMaskingCamera: $shouldPresentMaskSelfieCamera, formShowed: $formSelfie, nextFormShowed: $formNPWP)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding([.horizontal, .top], 30)
                    
                    // Form NPWP
                    VStack {
                        DisclosureGroup("Masukkan NPWP Anda", isExpanded: $formNPWP) {
                            ScanNPWPView(registerData: _registerData, npwp: $npwp, alreadyHaveNpwp: $alreadyHaveNpwp, imageNPWP: $imageNPWP, shouldPresentActionScheet: $shouldPresentActionScheet, showMaskingCamera: $shouldPresentMaskSelfieCamera, formShowed: $formNPWP)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding([.horizontal, .top], 30)
                    
                    NavigationLink(
                        destination: EmailVerificationView().environmentObject(registerData),
                        isActive: $nextViewActive,
                        label: {
                            Button(action: {
                                
                                self.registerData.npwp = self.npwp
                                
                                if imageKTP != nil
                                    && registerData.nik != ""
                                    && confirmNik
                                    && (registerData.npwp != "" || imageNPWP != nil)
                                    && imageSelfie != nil {
                                    
                                    self.nextViewActive.toggle()
                                    
                                }
                                
                            }, label: {
                                Text("Lanjut Pembukaan Rekening Baru")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 16))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            })
                        })
                        .background(Color(hex: "#232175"))
                        .cornerRadius(12)
                        .padding(30)
                }
            }
            
        }
        .background(
            VStack {
                Color(hex: "#232175").edgesIgnoringSafeArea(.all)
                    .frame(height: UIScreen.main.bounds.height/3)
                Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all)
            }
        )
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .sheet(isPresented: $shouldPresentImagePicker) {
            ZStack {
                SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: formNPWP ? self.$imageNPWP : self.$imageSelfie, isPresented: self.$shouldPresentImagePicker)
                
                if self.shouldPresentMaskSelfieCamera {
                    Image("pattern_selfie_white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.5)
                }
            }
        }
        .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = true
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.shouldPresentMaskSelfieCamera = false
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
            }), ActionSheet.Button.cancel()])
        }
    }
}

struct FormIdentitasDiriView_Previews: PreviewProvider {
    static var previews: some View {
        FormIdentitasDiriView().environmentObject(RegistrasiModel())
    }
}
