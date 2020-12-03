//
//  ScanKTPView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct ScanKTPView: View {
    
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
    @Binding var showAction : Bool
    @Binding var confirmNik: Bool
    
    let onChange: ()->()
    let onCommit: ()->()
    
    @State var isValidKtp: Bool = false
    @State var showingAlert: Bool = false
    @State var messageResponse: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Mohon siapkan terlebih dahulu \nKartu Tanda Penduduk (KTP) Anda")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(.black)
                .padding(.vertical, 15)
            
            ZStack {
                Image("ic_camera")
                VStack {
                    imageKTP?
                        .resizable()
                        .frame(maxWidth: 350, maxHeight: 200)
                        .cornerRadius(10)
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
                self.showAction.toggle()
            }, label: {
                Text(imageKTP == nil ? "Ambil Foto KTP" : "Ganti Foto Lain")
                    .foregroundColor(imageKTP == nil ? .white : Color(hex: "#2334D0"))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: imageKTP == nil ? "#2334D0" : "#FFFFFF"))
                            .shadow(color: .gray, radius: 2, x: 0, y: 1)
                    )
                    .padding(.vertical, 5)
            })
            .foregroundColor(.black)
            .cornerRadius(12)
            .padding([.top, .bottom], 15)
            
            VStack(alignment: .leading) {
                
                Text("Nomor Kartu Tanda Penduduk")
                    .multilineTextAlignment(.leading)
                    .font(.custom("Montserrat-SemiBold", size: 10))
                    .foregroundColor(.black)
                
                TextFieldValidation(data: $nik, title: "No. KTP (Otomatis terisi)", disable: confirmNik, isValid: isValidKtp, keyboardType: .numberPad) { (str: Array<Character>) in
                    self.nik = String(str.prefix(16))
                    self.isValidKtp = str.count == 16
                    
                }
                
//                TextField("No. KTP (Otomatis terisi)", text: $nik)
//                    .frame(height: 10)
//                    .font(.custom("Montserrat-SemiBold", size: 12))
//                    .foregroundColor(.black)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//                    .keyboardType(.numberPad)
//                    .onReceive(nik.publisher.collect()) {
//                        self.nik = String($0.prefix(16))
//                    }
//                    .disabled(!confirmNik)
                
                Button(action: {self.confirmNik.toggle()}) {
                    HStack(alignment: .top) {
                        Image(systemName: confirmNik ? "checkmark.square": "square")
                        Text("* Periksa kembali dan pastikan Nomor Kartu Tanda Penduduk (KTP) Anda telah sesuai")
                            .font(.custom("Montserrat-Regular", size: 8))
                            .foregroundColor(Color(hex: "#707070"))
                    }
                    //                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 15)
                
                if (imageKTP != nil) {

                    Button(action: {
                        if confirmNik && nik.count == 16 {
                            getCitizen(nik: self.nik)
                        }
                    }) {
                        Text("Simpan")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 15)

                } else { EmptyView() }
                
            }
        }
        .padding(.bottom, 15)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("Oke"))
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
                self.messageResponse = self.citizenVM.errorMessage
                
                self.showingAlert = true
                
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
                self.onCommit()
            }
            
            if !success {
                self.messageResponse = self.citizenVM.errorMessage
                self.showingAlert = true
            }
        }
    }
}

struct ScanKTPView_Previews: PreviewProvider {
    static var previews: some View {
        ScanKTPView(imageKTP: Binding.constant(nil), nik: Binding.constant(""), showAction: Binding.constant(false), confirmNik: Binding.constant(false)) {
            
        } onCommit: {
            
        }
    }
}
