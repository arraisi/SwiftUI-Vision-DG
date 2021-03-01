//
//  SelfieView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct SelfieView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /*
     Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    
    @Binding var imageSelfie: Image?
    @Binding var preview: Bool
    
    let onChange: ()->()
    let onCommit: ()->()
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text(NSLocalizedString("Please Do a Selfie".localized(language), comment: ""))
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(.black)
                .padding(.vertical, 15)
            
            ZStack {
                Image("ic_camera")
                VStack {
                    imageSelfie?
                        .resizable()
                        .scaledToFill()
                        .onTapGesture {
                            if imageSelfie != nil {
                                self.registerData.fotoSelfie = self.imageSelfie!
                                preview.toggle()
                            }
                        }
                }
                .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 200, maxHeight: 221)
            }
            .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 200, maxHeight: 221)
            .background(Color(hex: "#F5F5F5"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color(.gray).opacity(0.2))
            )
            
            Button(action: {
                print("ON TAP SELFIE")
                self.onChange()
            }, label: {
                Text(imageSelfie == nil ? NSLocalizedString("Take a Selfie".localized(language), comment: "") : NSLocalizedString("Change Another Photo".localized(language), comment: ""))
                    .foregroundColor(imageSelfie == nil ? .white : Color(hex: "#2334D0"))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: imageSelfie == nil ? "#2334D0" : "#FFFFFF"))
                            .shadow(color: .gray, radius: 2, x: 0, y: 1)
                    )
                    .padding(5)
            })
            .foregroundColor(.black)
            .cornerRadius(12)
            .padding(.vertical, 10)
            
            if (imageSelfie != nil) {
                Button(action: {
                    if imageSelfie != nil {
                        self.onCommit()
                        self.registerData.fotoSelfie = self.imageSelfie!
                    }
                }) {
                    Text(NSLocalizedString("Save".localized(language), comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.vertical, 15)
            } else { EmptyView() }
        }
        
    }
    
    /*
     Fungsi untuk Simpan Gambar ke Local Storage
     */
    private func store(imgStore: Image, forKey key: String) {
        let image: UIImage = imgStore.asUIImage()
        
        if let pngRepresentation = image.pngData() {
            UserDefaults.standard.set(pngRepresentation, forKey: key)
        }
    }
}

struct SelfieView_Previews: PreviewProvider {
    static var previews: some View {
        SelfieView(imageSelfie: Binding.constant(Image("card_bg")), preview: .constant(false)) {
            
        } onCommit: {
            
        }
    }
}
