//
//  RegisterSummaryView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 27/04/21.
//

import SwiftUI
import Indicators

struct RegisterSummaryView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    var productATMData = AddProductATM()
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject private var userRegisterVM = UserRegistrationViewModel()
    
    // view variables
    @State private var isLoading = false
    @State private var showingAlert: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var showCancelAlert = false
    @State private var showingNpwpModal = false
    @State private var nextRouteNasabah: Bool = false
    @State private var nextRouteNonNasabah: Bool = false
    @State private var errorMessage: String = ""
    @State private var npwp = ""
    var disableSaveNpwpBtn: Bool {
        self.npwp.count < 15
    }
    
    // route variables
    @State var pilihJenisTabunganActive = false
    @State var tujuanPembukaanRekeningActive = false
    @State var sumberDanaActive = false
    @State var perkiraanPenarikanActive = false
    @State var besarPerkiraanPenarikanActive = false
    @State var perkiraanSetoranActive = false
    @State var besarPerkiraanSetoranActive = false
    @State var pekerjaanActive = false
    @State var jabatanProfesiActive = false
    @State var industriTempatBekerjaActive = false
    @State var sumberPendapatanLainnyaActive = false
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color(hex: "#232175")
            
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white)
                    .frame(height: UIScreen.main.bounds.height / 2.2)
                
            }
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 380)
                Color(hex: "#F6F8FB")
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                
                AppBarLogo(light: false, showCancel: true) {
                    self.isShowingAlert = true
                }
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                ScrollView {
                    VStack {
                        Text("MAKE SURE YOUR INFORMATION IS CORRECT".localized(language))
                            .font(.custom("Montserrat-Bold", size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 20)
                        
                        IdentityView()
                        
                        IdentityPictureView()
                        
                        VStack(spacing: 15) {
                            
                            ZStack{
                                FieldSummaryView(value: $registerData.jenisTabungan, label: "Types of Savings", onEdit: {
                                    self.pilihJenisTabunganActive = true
                                })
                                
                                NavigationLink(destination: FormPilihJenisTabunganView(editMode: .active).environmentObject(registerData).environmentObject(productATMData), isActive: $pilihJenisTabunganActive) {EmptyView()}
                            }
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.tujuanPembukaan, label: "Account Opening Purpose", onEdit: {
                                    self.tujuanPembukaanRekeningActive = true
                                })
                                NavigationLink(destination: TujuanPembukaanRekeningView(editMode: .active).environmentObject(registerData), isActive: $tujuanPembukaanRekeningActive) {EmptyView()}
                            }
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.sumberDana, label: "Source of funds", onEdit: {
                                    sumberDanaActive = true
                                })
                                NavigationLink(destination: SumberDanaView(editMode: .active).environmentObject(registerData), isActive: $sumberDanaActive) {EmptyView()}
                            }
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.perkiraanPenarikan, label: "Estimated Withdrawal", onEdit: {
                                    perkiraanPenarikanActive = true
                                })
                                NavigationLink(destination: FormPenarikanView(editMode: .active).environmentObject(registerData), isActive: $perkiraanPenarikanActive) {EmptyView()}
                            }
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.besarPerkiraanPenarikan, label: "Estimated Withdrawal Size", onEdit: {
                                    besarPerkiraanPenarikanActive = true
                                })
                                NavigationLink(destination: FormPenarikanView(editMode: .active).environmentObject(registerData), isActive: $besarPerkiraanPenarikanActive) {EmptyView()}
                            }
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.perkiraanSetoran, label: "Estimated Deposit", onEdit: {
                                    perkiraanSetoranActive = true
                                })
                                NavigationLink(destination: FormSetoranView(editMode: .active).environmentObject(registerData), isActive: $perkiraanSetoranActive) {EmptyView()}
                            }
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.besarPerkiraanSetoran, label: "Estimated Deposit Size", onEdit: {
                                    besarPerkiraanSetoranActive = true
                                })
                                NavigationLink(destination: FormSetoranView(editMode: .active).environmentObject(registerData), isActive: $besarPerkiraanSetoranActive) {EmptyView()}
                            }
                            
                        }
                        .padding(.vertical, 20)
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                        // Profession
                        VStack(spacing: 15) {
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.pekerjaan, label: "Profession", onEdit: {
                                    self.pekerjaanActive = true
                                })
                                NavigationLink(destination: PerkerjaanView(editMode: .active).environmentObject(registerData), isActive: $pekerjaanActive) {EmptyView()}
                            }
                            
                            if [3, 6].contains(registerData.pekerjaanId) {
                                
                                ZStack {
                                    FieldSummaryView(value: $registerData.jabatanProfesi, label: "Position", onEdit: {
                                        self.jabatanProfesiActive = true
                                    })
                                    NavigationLink(destination: FormJabatanProfesiView(editMode: .active).environmentObject(registerData), isActive: $jabatanProfesiActive) {EmptyView()}
                                }
                                
                            }
                            
//                            if [9].contains(registerData.pekerjaanId) {
//
//                                ZStack {
//                                    FieldSummaryView(value: $registerData.industriTempatBekerja, label: "Industry", onEdit: {
//                                        self.industriTempatBekerjaActive = true
//                                    })
//                                    NavigationLink(destination: FormIndustriTempatBekerjaView(editMode: .active).environmentObject(registerData), isActive: $industriTempatBekerjaActive) {EmptyView()}
//                                }
//
//                            }
                            
                            if appState.nasabahIsExisting || (!appState.nasabahIsExisting && ![10, 11, 12].contains(registerData.pekerjaanId))  {

                                HStack {
                                    Text("Gross Income".localized(language))
//                                        .font(.caption)
                                        .font(.custom("Montserrat-SemiBold", size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    
                                    MultilineTextField("Gross Income".localized(language), text: $registerData.penghasilanKotor) {
                                        
                                    }
                                    .disabled(true)
                                    
                                    Divider()
                                        .frame(height: 30)
                                    
                                    NavigationLink(destination: PenghasilanKotorView(editMode: .active).environmentObject(registerData)) {
                                        Text("Edit").foregroundColor(.blue)
                                    }
                                }
                                .frame(height: 20)
                                .font(.subheadline)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .padding(.horizontal, 20)
                            }
                            
                            ZStack {
                                FieldSummaryView(value: $registerData.sumberPendapatanLainnya, label: "Other Sources of Income", onEdit: {
                                    self.sumberPendapatanLainnyaActive = true
                                })
                                NavigationLink(destination: SumberPendapatanLainnyaView(editMode: .active).environmentObject(registerData), isActive: $sumberPendapatanLainnyaActive) {EmptyView()}
                            }
                        }
                        .padding(.vertical, 20)
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                        
                        
                        VStack(alignment: .leading) {
                            Group {
                                // MARK : Pekerjaan Wiraswasta
                                if [10, 11, 12].contains(registerData.pekerjaanId) {
                                    SourceOfFundView()
                                } else {
                                    InformasiPerusahaanVerificationView()
                                        .padding(.bottom, 5)
                                }
                            }
                            Spacer()
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 35)
                }
                
                VStack {
                    Button(action: {
                        
                        saveUserToDb()
                        
                    }, label: {
                        Text("Submit Data".localized(language))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .background(Color(hex: self.isLoading ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 100)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .disabled(self.isLoading)
                    
                    NavigationLink(
                        destination: SuccessRegisterView(isAllowBack: false).environmentObject(registerData),
                        isActive: self.$nextRouteNonNasabah,
                        label: {}
                    )
                    
                    NavigationLink(
                        destination: FormPilihJenisATMView().environmentObject(registerData).environmentObject(productATMData),
                        isActive: self.$nextRouteNasabah,
                        label: {EmptyView()}
                    )
                }
                .background(Color.white)

            }
            
            if self.registerData.showPopupNpwp {
                ZStack {
                    ModalOverlay(tapAction: {})
                        .edgesIgnoringSafeArea(.all)
                    
                    popUpNpwp()
                }
                .transition(.asymmetric(insertion: .opacity, removal: .fade))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    // MARK:- CREATE POPUP MESSAGE
    func popUpNpwp() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Tax Identification Number".localized(language))
                .multilineTextAlignment(.leading)
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
            
            //            TextFieldValidation(data: $registerData.npwp, title: "No. NPWP", disable: false, isValid: false, keyboardType: .numberPad) { (str: Array<Character>) in
            //                self.registerData.npwp = String(str.prefix(15))
            //            }
            
            TextField("Tax Identification Number".localized(language), text: $npwp)
                .frame(height: 10)
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(.black)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .onReceive(npwp.publisher.collect()) {
                    self.npwp = String($0.prefix(15))
                }
            
            Button(action: {
                self.registerData.npwp = self.npwp
                print("REGISTER DATA NPWP : \(self.registerData.npwp)")
                self.registerData.showPopupNpwp = false
                self.showingNpwpModal = false
            }) {
                Text("Save".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: disableSaveNpwpBtn ? "#CBD1D9" : "#2334D0"))
            .cornerRadius(12)
            .disabled(disableSaveNpwpBtn)
        }
        .padding()
        .padding(.vertical, 25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func saveUserToCoreData()  {
        print("------SAVE TO CORE DATA-------")
        
        let data = Registration(context: managedObjectContext)
        data.id = 1
        data.nik = self.registerData.nik
        data.noTelepon = self.registerData.noTelepon
        data.jenisTabungan = self.registerData.jenisTabungan
        data.email = self.registerData.email
        data.pekerjaanId = Int16(self.registerData.pekerjaanId)
        data.pekerjaan = self.registerData.pekerjaan
        
        // Data ATM
        data.atmOrRekening = self.registerData.atmOrRekening
        data.noAtm = self.registerData.noAtm
        data.noRekening = self.registerData.noRekening
        data.accNo = self.registerData.accNo
        data.atmNumberReferral = self.registerData.atmNumberReferral
        
        // Data Surat Menyurat
        data.addressInput = self.registerData.addressInput
        data.addressKecamatanInput = self.registerData.addressKecamatanInput
        data.addressKelurahanInput = self.registerData.addressKelurahanInput
        data.addressPostalCodeInput = self.registerData.addressPostalCodeInput
//        data.addressRtRwInput = self.registerData.addressRtRwInput
        data.addressProvinsiInput = self.registerData.addressProvinsiInput
        data.addressKotaInput = self.registerData.addressKotaInput
//        data.addressRtInput = self.registerData.addressRtInput
//        data.addressRwInput = self.registerData.addressRwInput
        
        // Data From NIK
        data.namaLengkapFromNik = self.registerData.namaLengkapFromNik
        data.alamatKtpFromNik = self.registerData.alamatKtpFromNik
        data.kecamatanFromNik = self.registerData.kecamatanFromNik
        data.kelurahanFromNik = self.registerData.kelurahanFromNik
        data.kabupatenKotaFromNik = self.registerData.kabupatenKotaFromNik
        data.provinsiFromNik = self.registerData.provinsiFromNik
        data.rwFromNik = self.registerData.rwFromNik
        data.rtFromNik = self.registerData.rtFromNik
        data.kodePosFromNik = self.registerData.kodePosFromNik
        
        data.nomorKKFromNik = self.registerData.nomorKKFromNik
        data.jenisKelaminFromNik = self.registerData.jenisKelaminFromNik
        data.tempatLahirFromNik = self.registerData.tempatLahirFromNik
        data.tanggalLahirFromNik = self.registerData.tanggalLahirFromNik
        data.agamaFromNik = self.registerData.agamaFromNik
        data.statusPerkawinanFromNik = self.registerData.statusPerkawinanFromNik
        data.pendidikanFromNik = self.registerData.pendidikanFromNik
        data.jenisPekerjaanFromNik = self.registerData.jenisPekerjaanFromNik
        data.namaIbuFromNik = self.registerData.namaIbuFromNik
        data.statusHubunganFromNik = self.registerData.statusHubunganFromNik
        
        // Data Perusahaan
        data.namaPerusahaan = self.registerData.namaPerusahaan
        data.alamatPerusahaan = self.registerData.alamatPerusahaan
        data.kodePos = self.registerData.kodePos
        data.kecamatan = self.registerData.kecamatan
        data.kelurahan = self.registerData.kelurahan
//        data.rtrw = self.registerData.rtrw
//        data.rtPerusahaan = self.registerData.rtPerusahaan
//        data.rwPerusahaan = self.registerData.rwPerusahaan
        data.kotaPerusahaan = self.registerData.kotaPerusahaan
        data.provinsiPerusahaan = self.registerData.provinsiPerusahaan
        data.kabKota = self.registerData.kabKota
        
        // Data Keluarga
        data.alamatKeluarga = self.registerData.alamatKeluarga
        data.kodePosKeluarga = self.registerData.kodePosKeluarga
        data.kecamatanKeluarga = self.registerData.kecamatanKeluarga
        data.kelurahanKeluarga = self.registerData.kelurahanKeluarga
        
        data.isNasabahMestika = self.appState.nasabahIsExisting ? true : false
        data.isAddressEqualToDukcapil = self.registerData.isAddressEqualToDukcapil
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    /* Save User To DB */
    func saveUserToDb() {
        self.isLoading = true
        self.userRegisterVM.userRegistration(registerData: registerData) { success in
            if success {
                saveUserToCoreData()
                if self.appState.nasabahIsExisting {
                    self.nextRouteNasabah = true
                } else {
                    self.nextRouteNasabah = true
                    //                    self.nextRouteNonNasabah = true
                }
            }
            
            if !success {
                self.isLoading = false
                self.errorMessage = self.userRegisterVM.message
                self.showingAlert = true
            }
        }
    }
}

struct RegisterSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSummaryView().environmentObject(RegistrasiModel())
    }
}
