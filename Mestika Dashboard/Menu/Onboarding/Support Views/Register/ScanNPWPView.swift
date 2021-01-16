//
//  ScanNPWPView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct ScanNPWPView: View {
    
    /*
     Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    
    @Binding var npwp: String
    @Binding var alreadyHaveNpwp: Bool
    @Binding var imageNPWP: Image?
    @Binding var preview: Bool
    
    let onChange: ()->()
    let onCommit: ()->()
    
    @State var isValidNPWP: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text(NSLocalizedString("Silahkan masukkan Foto kartu NPWP Anda", comment: ""))
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(.black)
                .padding([.vertical], 15)
                .padding(.horizontal, 20)
            
            ZStack {
                Image("ic_camera")
                VStack {
                    imageNPWP?
                        .resizable()
                        .scaledToFill()
                        .onTapGesture {
                            preview.toggle()
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
                self.onChange()
            }, label: {
                Text(imageNPWP == nil ? NSLocalizedString("Upload Gambar NPWP", comment: "") : NSLocalizedString("Ganti Foto Lain", comment: ""))
                    .foregroundColor(imageNPWP == nil && !alreadyHaveNpwp ? .white : Color(hex: "#2334D0"))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: imageNPWP == nil && !alreadyHaveNpwp ? "#2334D0" : "#FFFFFF"))
                            .shadow(color: .gray, radius: 2, x: 0, y: 1)
                    )
                    .padding(5)
            })
            .foregroundColor(.black)
            .cornerRadius(12)
            .padding([.top, .bottom], 15)
            .disabled(alreadyHaveNpwp)
            
            VStack(alignment: .leading) {
                
                Text(NSLocalizedString("Nomor NPWP", comment: ""))
                    .multilineTextAlignment(.leading)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.black)
                
                TextFieldValidation(data: $npwp, title: "No. NPWP", disable: alreadyHaveNpwp, isValid: isValidNPWP, keyboardType: .numberPad) { (str: Array<Character>) in
                    self.npwp = String(str.prefix(15))
                    self.isValidNPWP = str.count == 15
                }
                
                //                TextField("No. NPWP", text: $npwp)
                //                    .frame(height: 10)
                //                    .font(.custom("Montserrat-SemiBold", size: 12))
                //                    .foregroundColor(.black)
                //                    .padding()
                //                    .background(Color.gray.opacity(0.1))
                //                    .cornerRadius(10)
                //                    .keyboardType(.numberPad)
                //                    .onReceive(npwp.publisher.collect()) {
                //                        self.npwp = String($0.prefix(15))
                //                    }
                //                    .disabled(alreadyHaveNpwp)
                
                Button(action: toggleHasNpwp) {
                    HStack(alignment: .top) {
                        Image(systemName: alreadyHaveNpwp ? "checkmark.square": "square")
                        Text(NSLocalizedString("* Saya Menyatakan belum memiliki kartu NPWP.\n Lewati tahapan ini", comment: ""))
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#707070"))
                    }
                    .padding(.top, 5)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 15)
                
                Button(action: {
                    if self.alreadyHaveNpwp || (self.npwp != "" && self.imageNPWP != nil) {
                        self.onCommit()
                        if let npwp = self.imageNPWP {
                            self.registerData.fotoNPWP = npwp
                        }
                        self.registerData.npwp = npwp
                        self.registerData.hasNoNpwp = true
                        print("NPWP YES")
                    } else {
                        self.onCommit()
                        self.registerData.fotoNPWP = Image("")
                        self.registerData.hasNoNpwp = false
                        print("NPWP NO")
                    }
                    
                    print("REGISTER DATA NPWP : \(self.registerData.npwp)")
                }) {
                    Text(NSLocalizedString("Simpan", comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .background(Color(hex: isDisableButtonSimpan() ? "#CBD1D9" : "#2334D0"))
                .cornerRadius(12)
                .padding(.top, 15)
                .disabled(isDisableButtonSimpan())
            }.navigationBarHidden(true)
            
        }
        
    }
    
    /*
     Fungsi untuk Toggle Mempunyai NPWP
     */
    func toggleHasNpwp() {
        self.alreadyHaveNpwp.toggle()
        if self.alreadyHaveNpwp {
            self.npwp = ""
            self.imageNPWP = nil
            self.registerData.fotoNPWP = Image("")
        }
    }
    
    func validasiNPWP() -> Bool {
        if self.alreadyHaveNpwp {
            return false
        } else if self.npwp != "" && self.imageNPWP != nil {
            return false
        }
        
        return true
    }
    
    func isDisableButtonSimpan() -> Bool {
        if self.alreadyHaveNpwp || (self.npwp.count == 15 && self.imageNPWP != nil) {
            return false
        }
        
        return true
    }
}

struct ScanNPWPView_Previews: PreviewProvider {
    static var previews: some View {
        ScanNPWPView(npwp: Binding.constant(""), alreadyHaveNpwp: Binding.constant(false), imageNPWP: Binding.constant(nil), preview: .constant(false)) {
        } onCommit: {
            
        }
    }
}
