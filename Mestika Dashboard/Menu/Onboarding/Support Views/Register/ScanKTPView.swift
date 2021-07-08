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
    //    @Binding var confirmNik: Bool
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
            
            imageKTPScreen
            buttonTakeSelfie
            formProfile
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
    
    // MARK: IMAGE KTP
    var imageKTPScreen: some View {
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
    }
    
    // MARK: BUTTON TAKE SELFIE
    var buttonTakeSelfie: some View {
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
    }
    
    // MARK: FORM PROFILES
    var formProfile: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Group {
                VStack(alignment: .leading) {
                    Text("Identity Card Number".localized(language))
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.black)
                    
                    TextFieldValidation(data: $nik, title: "Identity Card/(KTP) Number".localized(language), disable: false, isValid: isValidKtp, keyboardType: .numberPad) { (str: Array<Character>) in
                        self.nik = String(str.prefix(16))
                        self.isValidKtp = str.count == 16
                        
                    }
                    
                    //                    Button(action: {self.confirmNik.toggle()}) {
                    //                        HStack(alignment: .top) {
                    //                            Image(systemName: confirmNik ? "checkmark.square": "square")
                    //                            Text("* Check again and make sure your Identity Card Number (KTP) is correct".localized(language))
                    //                                .font(.custom("Montserrat-Regular", size: 12))
                    //                                .foregroundColor(Color(hex: "#707070"))
                    //                        }
                    //                        //                    .padding(.horizontal, 30)
                    //                        .padding(.top, 5)
                    //                        .fixedSize(horizontal: false, vertical: true)
                    //                    }
                }
                
                LabelTextField(value:  $registerData.nama, label: "Name".localized(language), placeHolder: "Name".localized(language)) { onChange in
                    
                } onCommit: {
                    
                }
                
                LabelTextField(value:  $registerData.tempatLahir, label: "Place of birth".localized(language), placeHolder: "Place of birth".localized(language)) { onChange in
                    
                } onCommit: {
                    
                }
                
                VStack(alignment: .leading) {
                    Text("Date of birth".localized(language))
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.black)
                    
                    HStack{
                        DatePicker(selection: $registerData.tanggalLahir, displayedComponents: .date, label: {
                            EmptyView()
                        })
                        .labelsHidden()
                        .datePickerStyle(DefaultDatePickerStyle())
                        Spacer()
                    }
                }
                
                LabelTextFieldMenu(value: self.$registerData.jenisKelamin, label: "Gender".localized(language), data: ["Laki-laki", "Perempuan"], disabled: false, onEditingChanged: {_ in}, onCommit: {})
                
            }
            
            Group {
                VStack(alignment: .leading) {
                    Text("Address".localized(language))
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.black)
                    MultilineTextField("Address".localized(language), text: $registerData.alamat, onCommit: {
                    })
                    .font(Font.system(size: 14))
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                LabelTextField(value:  $registerData.rtRw, label: "RT/RW".localized(language), placeHolder: "RT/RW".localized(language)) { onChange in
                    
                } onCommit: {
                    
                }
                
                LabelTextField(value:  $registerData.kelurahan, label: "Village".localized(language), placeHolder: "Village".localized(language)) { onChange in
                    
                } onCommit: {
                    
                }
                
                LabelTextField(value:  $registerData.kecamatan, label: "Districts".localized(language), placeHolder: "Districts".localized(language)) { onChange in
                    
                } onCommit: {
                    
                }
            }
            
            Group {
                
                LabelTextFieldMenu(value: self.$registerData.statusPerkawinan, label: "Marital status".localized(language), data: ["Kawin", "Belum Kawin"], disabled: false, onEditingChanged: {_ in}, onCommit: {})
                
                LabelTextFieldMenu(value: self.$registerData.kewarganegaraan, label: "Citizenship".localized(language), data: ["WNI", "WNA"], disabled: false, onEditingChanged: {_ in}, onCommit: {})
                
                LabelTextField(value:  $registerData.namaIbuKandung, label: "Biological mother's name".localized(language), placeHolder: "Biological mother's name".localized(language)) { onChange in
                    
                } onCommit: {
                    
                }
            }
            
            if (imageKTP != nil) {
                
                Button(action: {
                    getCitizen(
                        nik: self.nik,
                        phone: registerData.noTelepon,
                        isNasabah: registerData.isNasabahmestika,
                        alamat: registerData.alamat,
                        jenisKelamin: registerData.jenisKelamin,
                        kecamatan: registerData.kecamatan,
                        kelurahan: registerData.kelurahan,
                        kewarganegaraan: registerData.kewarganegaraan,
                        nama: registerData.nama,
                        namaIbu: registerData.namaIbuKandung,
                        rt: registerData.rtrw,
                        rw: registerData.rtrw,
                        statusKawin: registerData.statusPerkawinan,
                        tanggalLahir: "27/12/1995",
                        tempatLahir: registerData.tempatLahir)
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
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "in_ID")
        return formatter
    }
    
    /* Function GET Citizen */
    @ObservedObject private var citizenVM = CitizenViewModel()
    func getCitizen(
        nik: String,
        phone: String,
        isNasabah: Bool,
        alamat: String,
        jenisKelamin: String,
        kecamatan: String,
        kelurahan: String,
        kewarganegaraan: String,
        nama: String,
        namaIbu: String,
        rt: String,
        rw: String,
        statusKawin: String,
        tanggalLahir: String,
        tempatLahir: String) {
        
        print("GET CITIZEN")
        self.citizenVM.getCitizen(
            nik: nik,
            phone: phone,
            isNasabah: isNasabah,
            alamat: alamat,
            jenisKelamin: jenisKelamin,
            kecamatan: kecamatan,
            kelurahan: kelurahan,
            kewarganegaraan: kewarganegaraan,
            nama: nama,
            namaIbu: namaIbu,
            rt: rt,
            rw: rw,
            statusKawin: statusKawin,
            tanggalLahir: tanggalLahir,
            tempatLahir: tempatLahir) { success in
            
            if success {
                print("isLoading \(self.citizenVM.isLoading)")
                print("nikValid \(self.citizenVM.nik)")
                print(self.citizenVM.alamatKtp)
                print(self.citizenVM.rt)
                
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
                self.registerData.kodePosFromNik = "40287"
                self.registerData.fotoKTP = self.imageKTP!
                
                print(self.registerData.nik)
                print(self.registerData.namaLengkapFromNik)
                
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
        if (nik.count == 16 || registerData.nama.isNotEmpty() || registerData.tempatLahir.isNotEmpty() || registerData.jenisKelamin.isNotEmpty() || registerData.alamat.isNotEmpty() || registerData.rtRw.isNotEmpty() || registerData.kelurahan.isNotEmpty() || registerData.kecamatan.isNotEmpty() || registerData.statusPerkawinan.isNotEmpty() || registerData.kewarganegaraan.isNotEmpty() || registerData.namaIbuKandung.isNotEmpty()) {
            return false
        }
        return true
    }
}

struct ScanKTPView_Previews: PreviewProvider {
    static var previews: some View {
        ScanKTPView(imageKTP: Binding.constant(nil), nik: Binding.constant(""), preview: .constant(false)) {
            
        } onCommit: {
            
        }.environmentObject(RegistrasiModel())
    }
}
