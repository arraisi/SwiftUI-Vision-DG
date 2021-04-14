//
//  ScanKTPView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct ScanKTPView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /*
     Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    
    /*
     Recognized Nomor Induk Ktp
     */
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    
    @Binding var imageKTP: Image?
    @Binding var nik: String
    @Binding var confirmNik: Bool
    @Binding var preview: Bool
    
    let onChange: ()->()
    let onCommit: ()->()
    
    @State var isValidKtp: Bool = false
    @State var showingAlert: Bool = false
    @State var messageResponse: String = ""
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Please prepare your \nIdentity Card (KTP) in advance".localized(language))
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(.black)
                .padding(.vertical, 15)
            
            ZStack {
                Image("ic_camera")
                VStack {
                    imageKTP?
                        .resizable()
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
                Text(imageKTP == nil ? "Take Photo Identity Card (KTP)".localized(language) : "Change Another Photo".localized(language))
                    .foregroundColor(imageKTP == nil ? .white : Color(hex: "#2334D0"))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: imageKTP == nil ? "#2334D0" : "#FFFFFF"))
                            .shadow(color: .gray, radius: 2, x: 0, y: 1)
                    )
                    .padding(5)
            })
            .foregroundColor(.black)
            .cornerRadius(12)
            .padding([.top, .bottom], 15)
            
            VStack(alignment: .leading) {
                
                Text("Identity Card Number".localized(language))
                    .multilineTextAlignment(.leading)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.black)
                
                TextFieldValidation(data: $nik, title: "Identity Card/(KTP) Number".localized(language), disable: confirmNik, isValid: isValidKtp, keyboardType: .numberPad) { (str: Array<Character>) in
                    self.nik = String(str.prefix(16))
                    self.isValidKtp = str.count == 16
                    
                }
                
                Button(action: {self.confirmNik.toggle()}) {
                    HStack(alignment: .top) {
                        Image(systemName: confirmNik ? "checkmark.square": "square")
                        Text("* Check again and make sure your Identity Card Number (KTP) is correct".localized(language))
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#707070"))
                    }
                    //                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 15)
                
                if (imageKTP != nil) {
                    
                    Button(action: {
                        getCitizen(nik: self.nik)
                    }) {
                        Text("Save".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .background(Color(hex: isDisableButtonSimpan() ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 15)
                    .disabled(isDisableButtonSimpan())
                    
                } else { EmptyView() }
                
            }
        }
        .padding(.bottom, 15)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.errorMessage.localized(language)),
                dismissButton: .default(Text("OK".localized(language)))
            )
        }
    }
    
    /* Function GET Citizen */
    @ObservedObject private var citizenVM = CitizenViewModel()
    func getCitizen(nik: String) {
        print("GET CITIZEN")
        self.citizenVM.getCitizen(nik: nik) { success in
            if success {
                print("isLoading \(self.citizenVM.isLoading)")
                print("nikValid \(self.citizenVM.nik)")
                print(self.citizenVM.alamatKtp)
                print(self.citizenVM.rt)
//                self.messageResponse = self.citizenVM.errorMessage
//                self.showingAlert = true
                self.registerData.nik = nik
                self.registerData.namaLengkapFromNik = self.citizenVM.namaLengkap
                self.registerData.tempatLahirFromNik = self.citizenVM.tempatLahir
                self.registerData.alamatKtpFromNik = self.citizenVM.alamatKtp
                self.registerData.rtFromNik = self.citizenVM.rt
                self.registerData.rwFromNik = self.citizenVM.rw
                self.registerData.kelurahanFromNik = self.citizenVM.kelurahan
                self.registerData.kecamatanFromNik = self.citizenVM.kecamatan
                self.registerData.kabupatenKotaFromNik = self.citizenVM.kabupatenKota
                self.registerData.provinsiFromNik = self.citizenVM.provinsi
                self.registerData.fotoKTP = self.imageKTP!
                
                print(self.registerData.nik)
                print(self.registerData.namaLengkapFromNik)
                
//                UserDefaults.standard.set(self.citizenVM.nik, forKey: "nik_local")
//                UserDefaults.standard.set(self.citizenVM.namaLengkap, forKey: "nama_local")
                
                self.onCommit()
            }
            
            if !success {
                print("ERROR")
                self.errorMessage = self.citizenVM.errorMessage
                self.showingAlert = true
            }
        }
    }
    
    private func isDisableButtonSimpan() -> Bool {
        if self.confirmNik && nik.count == 16 {
            return false
        }
        return true
    }
}

struct ScanKTPView_Previews: PreviewProvider {
    static var previews: some View {
        ScanKTPView(imageKTP: Binding.constant(nil), nik: Binding.constant(""), confirmNik: Binding.constant(false), preview: .constant(false)) {
            
        } onCommit: {
            
        }
    }
}
