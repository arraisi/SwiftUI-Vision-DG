//
//  ScanKTPView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI
import Combine

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
    
    @State private var tanggalLahir = Date()
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    @State var allProvince = MasterProvinceResponse()
    @State var allRegency = MasterRegencyResponse()
    @State var allDistrict = MasterDistrictResponse()
    @State var allVillage = MasterVilageResponse()
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        return min...max
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
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
        .onAppear() {
            self.getAllProvince()
        }
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
                    
                    TextFieldValidation(data: $nik, title: "Identity Card/(KTP) Number".localized(language), disable: false, isValid: isValidKtp, keyboardType: .numberPad){ (str: Array<Character>) in
                        self.nik = String(str.prefix(16))
                        self.isValidKtp = str.count == 16
                        
                    }
                    .onReceive(Just(nik)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.nik = filtered
                        }
                    }
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
                        DatePicker(selection: $tanggalLahir, in: dateClosedRange, displayedComponents: .date, label: {
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
                    .onReceive(Just(registerData.alamat)) { newValue in
                        let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                        if filtered != newValue {
                            self.registerData.alamat = filtered
                        }
                    }
                }
                
                // Label Province
                VStack(alignment: .leading) {
                    Text("Province".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("Province".localized(language), text: $registerData.provinsiFromNik)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allProvince.count, id: \.self) { i in
                                Button(action: {
                                    registerData.provinsiFromNik = self.allProvince[i].name
                                    self.getRegencyByIdProvince(idProvince: self.allProvince[i].id)
                                }) {
                                    Text(self.allProvince[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                // Label City
                VStack(alignment: .leading) {
                    Text("City".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("City".localized(language), text: $registerData.kabupatenKotaFromNik)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allRegency.count, id: \.self) { i in
                                Button(action: {
                                    registerData.kabupatenKotaFromNik = self.allRegency[i].name
                                    self.getDistrictByIdRegency(idRegency: self.allRegency[i].id)
                                }) {
                                    Text(self.allRegency[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                // Label District
                VStack(alignment: .leading) {
                    Text("District".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("District".localized(language), text: $registerData.kelurahanFromNik)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allDistrict.count, id: \.self) { i in
                                Button(action: {
                                    registerData.kelurahanFromNik = self.allDistrict[i].name
                                    self.getVilageByIdDistrict(idDistrict: self.allDistrict[i].id)
                                }) {
                                    Text(self.allDistrict[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                // Label Village
                VStack(alignment: .leading) {
                    Text("Sub-district".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("Sub-district".localized(language), text: $registerData.kecamatanFromNik)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allVillage.count, id: \.self) { i in
                                Button(action: {
                                    registerData.kecamatanFromNik = self.allVillage[i].name
//                                    registerData.kodePosFromNik = self.allVillage[i].postalCode ?? ""
                                }) {
                                    Text(self.allVillage[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
            }
            
            Group {
                
                LabelTextFieldMenu(value: self.$registerData.statusPerkawinan, label: "Marital status".localized(language), data: ["Kawin", "Belum Kawin", "Duda", "Janda"], disabled: false, onEditingChanged: {_ in}, onCommit: {})
                
                LabelTextFieldMenu(value: self.$registerData.kewarganegaraan, label: "Citizenship".localized(language), data: ["WNI", "WNA"], disabled: false, onEditingChanged: {_ in}, onCommit: {})
                
                LabelTextField(value:  $registerData.namaIbuKandung, label: "Biological mother's name".localized(language), placeHolder: "Biological mother's name".localized(language)) { onChange in
                    
                } onCommit: {
                    
                }
            }
            
            if (imageKTP != nil) {
                
                Button(action: {
                    
                    self.registerData.tanggalLahir = dateFormatter.string(from: tanggalLahir)
                    
                    getCitizen(
                        nik: self.nik,
                        phone: registerData.noTelepon,
                        isNasabah: registerData.isNasabahmestika,
                        alamat: registerData.alamat,
                        jenisKelamin: registerData.jenisKelamin,
                        kecamatan: registerData.kecamatanFromNik,
                        kelurahan: registerData.kelurahanFromNik,
                        kewarganegaraan: registerData.kewarganegaraan,
                        nama: registerData.nama,
                        namaIbu: registerData.namaIbuKandung,
                        rt: "00",
                        rw: "00",
                        statusKawin: registerData.statusPerkawinan,
                        tanggalLahir: registerData.tanggalLahir,
                        tempatLahir: registerData.tempatLahir,
                        provinsi: registerData.provinsiFromNik,
                        kota: registerData.kabupatenKotaFromNik)
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
        tempatLahir: String,
        provinsi: String,
        kota: String) {
        
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
            tempatLahir: tempatLahir,
            provinsi: provinsi,
            kota: kota) { success in
            
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
                self.registerData.kodePosFromNik = "00000"
                self.registerData.rwFromNik = self.citizenVM.rw
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
    
    @ObservedObject var addressVM = AddressSummaryViewModel()
    func getAllProvince() {
        self.addressVM.getAllProvince { success in
            
            if success {
                self.allProvince = self.addressVM.provinceResult
            }
            
            if !success {
                
            }
        }
    }
    
    func getRegencyByIdProvince(idProvince: String) {
        self.addressVM.getRegencyByIdProvince(idProvince: idProvince) { success in
            
            if success {
                self.allRegency = self.addressVM.regencyResult
            }
            
            if !success {
                
            }
        }
    }
    
    func getDistrictByIdRegency(idRegency: String) {
        self.addressVM.getDistrictByIdRegency(idRegency: idRegency) { success in
            
            if success {
                self.allDistrict = self.addressVM.districtResult
            }
            
            if !success {
                
            }
        }
    }
    
    func getVilageByIdDistrict(idDistrict: String) {
        self.addressVM.getVilageByIdDistrict(idDistrict: idDistrict) { success in
            
            if success {
                self.allVillage = self.addressVM.vilageResult
            }
            
            if !success {
                
            }
        }
    }
    
    private func isDisableButtonSimpan() -> Bool {
        if (nik.count == 16 && registerData.nama != "" && registerData.tempatLahir != "" && registerData.jenisKelamin != "" && registerData.alamat != "" && registerData.kelurahanFromNik != "" && registerData.kecamatanFromNik != "" && registerData.provinsiFromNik != "" && registerData.kabupatenKotaFromNik != "" && registerData.statusPerkawinan != "" && registerData.kewarganegaraan != "" && registerData.namaIbuKandung != "") {
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
