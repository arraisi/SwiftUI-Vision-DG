//
//  FormInformasiPerusahaanView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 28/09/20.
//

import SwiftUI
import Indicators
import Combine

struct BidangUsaha {
    var nama: String
}

struct InformasiPerusahaanView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    // Routing variables
    @State var editMode: EditMode = .inactive
    
    @State var namaPerusahaan: String = ""
    @State var alamatPerusahaan: String = ""
    @State var provinsi: String = ""
    @State var kabKota: String = ""
    @State var kelurahan: String = ""
    @State var kodePos : String = ""
    @State var kecamatan : String = ""
    @State var location : String = ""
    @State var isEditFromSummary: Bool = false
    
    @State var noTlpPerusahaan: String = ""
    @State var nextViewActive: Bool = false
    @State var verificationViewActive: Bool = false
    
    @State var isLoading: Bool = false
    @State private var isShowAlert: Bool = false
    
    @State var messageResponse: String = ""
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    @State var allProvince = MasterProvinceResponse()
    @State var allRegency = MasterRegencyResponse()
    @State var allDistrict = MasterDistrictResponse()
    @State var allVillage = MasterVilageResponse()
    
    let bidangUsahaSwasta:[BidangUsaha] = [
        .init(nama: "Minimart, Swalayan, Js Parkir, SPBU"),
        .init(nama: "Ekspor Impor"),
        .init(nama: "Perdagangan Barang Antik/Mewah"),
        .init(nama: "Biro Perjalanan/Travel Agen"),
        .init(nama: "Perdagangan Logam Mulia/Emas/Permata"),
        .init(nama: "Properti/Real Estate/Pengembang/Jasa Survey"),
        .init(nama: "Pengelolaan Hsl Hutan/Kehutanan/Pemtgan Kayu"),
        .init(nama: "Koperasi dengan Aset >= 1 Milyar"),
        .init(nama: "Money Changer/Jasa Pengiriman Uang"),
        .init(nama: "MLM (Multi Level Marketing)"),
        .init(nama: "Yayasan/Non Profit Organization"),
        .init(nama: "Pdgg Kaki Lima/Keliling/Sayur/Tukang Becak"),
        .init(nama: "Lembaga Pemerintahan/Instansi Pemerintah"),
        .init(nama: "Perdagangan/Jual Beli/Distributor"),
        .init(nama: "Restoran/Rumah Makan"),
        .init(nama: "Jasa Pendidikan"),
        .init(nama: "Jasa Kesehatan"),
        .init(nama: "Pertanian, Peternakan, dan Perikanan"),
        .init(nama: "Industri/Pabrik"),
        .init(nama: "Konstruksi/Kontraktor"),
        .init(nama: "Perhotelan"),
        .init(nama: "Pengangkutan/Transportasi"),
        .init(nama: "Lembaga Keuangan (Bank, Asuransi, dll)"),
        .init(nama: "Usaha/Jasa Lainnya"),
        .init(nama: "Pertambangan"),
        .init(nama: "Listrik, Gas, dan Air"),
        .init(nama: "Notaris"),
        .init(nama: "Konsultan Keuangan/Perencana Keuangan"),
        .init(nama: "Advokat (Konsultan Hukum)"),
        .init(nama: "Kurator (Pengurus atau Pengawas Institusi Budaya atau Seni)"),
        .init(nama: "Konsultan Pajak"),
    ]
    
    let bidangUsahaWiraswasta:[BidangUsaha] = [
        .init(nama: "Minimart, Swalayan, Js Parkir, SPBU"),
        .init(nama: "Ekspor Impor"),
        .init(nama: "Perdagangan Barang Antik/Mewah"),
        .init(nama: "Biro Perjalanan/Travel Agen"),
        .init(nama: "Perdagangan Logam Mulia/Emas/Permata"),
        .init(nama: "Properti/Real Estate/Pengembang/Jasa Survey"),
        .init(nama: "Pengelolaan Hsl Hutan/Kehutanan/Pemtgan Kayu"),
        .init(nama: "Koperasi dengan Aset >= 1 Milyar"),
        .init(nama: "Money Changer/Jasa Pengiriman Uang"),
        .init(nama: "MLM (Multi Level Marketing)"),
        .init(nama: "Yayasan/Non Profit Organization"),
        .init(nama: "Pdgg Kaki Lima/Keliling/Sayur/Tukang Becak"),
        .init(nama: "Lembaga Pemerintahan/Instansi Pemerintah"),
        .init(nama: "Perdagangan/Jual Beli/Distributor"),
        .init(nama: "Restoran/Rumah Makan"),
        .init(nama: "Jasa Pendidikan"),
        .init(nama: "Jasa Kesehatan"),
        .init(nama: "Perkebunan"),
        .init(nama: "Pertanian, Peternakan, dan Perikanan"),
        .init(nama: "Industri/Pabrik"),
        .init(nama: "Konstruksi/Kontraktor"),
        .init(nama: "Perhotelan"),
        .init(nama: "Pengangkutan/Transportasi"),
        .init(nama: "Lembaga Keuangan (Bank, Asuransi, dll)"),
        .init(nama: "Usaha/Jasa Lainnya"),
        .init(nama: "Pertambangan"),
        .init(nama: "Listrik, Gas, dan Air"),
    ]
    
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    @State var showingModalBidang = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color(hex: "#232175")
            
            VStack {
                
                Spacer()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 45 / 100 * UIScreen.main.bounds.height)
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                ScrollView {
                    
                    // Title
                    Text("OPENING ACCOUNT DATA".localized(language))
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 40)
                    
                    // Content
                    ZStack {
                        
                        // Forms
                        ZStack {
                            
                            VStack{
                                LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                            }
                            .cornerRadius(25.0)
                            .padding(.horizontal, 70)
                            
                            VStack{
                                LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                            }
                            .cornerRadius(25.0)
                            .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 5, y: -2)
                            .padding(.horizontal, 50)
                            .padding(.top, 10)
                            
                            VStack {
                                
                                Spacer()
                                
                                // Sub title
                                Text("Enter Company Information".localized(language))
                                    .font(.custom("Montserrat-SemiBold", size: 18))
                                    .foregroundColor(Color(hex: "#232175"))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 30)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                // Forms input
                                ZStack {
                                    cardForm
                                        .padding(.vertical, 20)
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                
                                if (editMode == .inactive) {
                                    NavigationLink(
                                        destination: PenghasilanKotorView().environmentObject(registerData),
                                        isActive: $nextViewActive,
                                        label: {
                                            Button(action: {
                                                
                                                self.registerData.noTeleponPerusahaan = self.noTlpPerusahaan
                                                self.registerData.kodePos = self.kodePos
                                                
                                                self.nextViewActive = true
                                                
                                            }, label: {
                                                Text("Next".localized(language))
                                                    .foregroundColor(.white)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                            })
                                        })
                                        .disabled(isValid())
                                        .frame(height: 50)
                                        .background(isValid() ? Color(.lightGray) : Color(hex: "#2334D0"))
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 25)
                                } else {
                                    
                                    if isEditFromSummary {
                                        NavigationLink(
                                            destination: RegisterSummaryView(deviceModel: DeviceTraceModel()).environmentObject(registerData),
                                            isActive: $verificationViewActive,
                                            label: {
                                                Button(action: {
                                                    
                                                    self.registerData.noTeleponPerusahaan = self.noTlpPerusahaan
                                                    self.registerData.kodePos = self.kodePos
                                                    
                                                    self.verificationViewActive = true
                                                    
                                                }, label: {
                                                    Text("Save".localized(language))
                                                        .foregroundColor(.white)
                                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                                })
                                            })
                                            .disabled(isValid())
                                            .frame(height: 50)
                                            .background(isValid() ? Color(.lightGray) : Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 25)
                                    } else {
                                        NavigationLink(
                                            destination: PenghasilanKotorView(editMode: self.editMode).environmentObject(registerData),
                                            isActive: $verificationViewActive,
                                            label: {
                                                Button(action: {
                                                    
                                                    self.registerData.noTeleponPerusahaan = self.noTlpPerusahaan
                                                    self.registerData.kodePos = self.kodePos
                                                    
                                                    self.verificationViewActive = true
                                                    
                                                }, label: {
                                                    Text("Save".localized(language))
                                                        .foregroundColor(.white)
                                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                                })
                                            })
                                            .disabled(isValid())
                                            .frame(height: 50)
                                            .background(isValid() ? Color(.lightGray) : Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 25)
                                    }
                                    
                                    
                                }
                                
                            }
                            .background(LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(25.0)
                            .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 10, y: -2)
                            .padding(.horizontal, 30)
                            .padding(.top, 25)
                            
                        }
                        
                    }
                    .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .padding(.bottom, 25)
                    
                }
                .KeyboardAwarePadding()
                
            }
            
            // Background Color When Modal Showing
            if self.showingModal || self.showingModalBidang {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .navigationBarHidden(true)
        .popup(isPresented: $showingModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomFloater()
        }
        .onAppear() {
            self.getAllProvince()
            self.noTlpPerusahaan = self.registerData.noTeleponPerusahaan
            self.kodePos = self.registerData.kodePos
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("OK".localized(language)))
            )
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Do you want to cancel registration?".localized(language)),
                primaryButton: .default(Text("YES".localized(language)), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text("NO".localized(language))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.showingAlert = true
            }
        }))
    }
    
    // MARK : - Check form is fill
    func isValid() -> Bool {
        if registerData.namaPerusahaan == "" {
            return true
        }
        if registerData.alamatPerusahaan == "" {
            return true
        }
        if self.kodePos == "" {
            return true
        }
        if registerData.provinsiPerusahaan == "" {
            return true
        }
        if registerData.kotaPerusahaan == "" {
            return true
        }
        if registerData.kecamatan == "" {
            return true
        }
        if registerData.kelurahan == "" {
            return true
        }
        if noTlpPerusahaan.count < 10 {
            return true
        }
        return false
    }
    
    // MARK: - Form Group
    var cardForm: some View {
        
        VStack(alignment: .leading) {
            
            LabelTextField(value: $registerData.namaPerusahaan, label: "Company name".localized(language), placeHolder: "Company name".localized(language)){ (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .onReceive(Just(registerData.namaPerusahaan)) { newValue in
                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                if filtered != newValue {
                    self.registerData.namaPerusahaan = filtered
                }
            }
            .padding(.horizontal, 20)
            
            Group {
                Text("Business fields".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                if (registerData.pekerjaanId == 3) {
                    HStack {
                        if registerData.bidangUsaha == "" {
                            Text("Business fields".localized(language))
                                .font(Font.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 15)
                        }
                        else {
                            Text(registerData.bidangUsaha)
                                .font(Font.system(size: 14))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 15)
                            
                        }
                        
                        Spacer()
                        Menu {
                            ForEach(0..<bidangUsahaSwasta.count, id: \.self) { i in
                                Button(action: {
                                    registerData.bidangUsaha = bidangUsahaSwasta[i].nama
                                }) {
                                    Text(bidangUsahaSwasta[i].nama)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .font(Font.system(size: 12))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                } else if (registerData.pekerjaanId == 9) {
                    HStack {
                        if registerData.bidangUsaha == "" {
                            Text("Business fields".localized(language))
                                .font(Font.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 15)
                        }
                        else {
                            Text(registerData.bidangUsaha)
                                .font(Font.system(size: 14))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 15)
                            
                        }
                        
                        Spacer()
                        Menu {
                            ForEach(0..<bidangUsahaWiraswasta.count, id: \.self) { i in
                                Button(action: {
                                    registerData.bidangUsaha = bidangUsahaWiraswasta[i].nama
                                }) {
                                    Text(bidangUsahaWiraswasta[i].nama)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .font(Font.system(size: 12))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                } else {
                    EmptyView()
                }
                
            }
            .padding(.horizontal, 20)
            
            Group {
                
                Text("Company's address".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    MultilineTextField("Company's address".localized(language), text: $registerData.alamatPerusahaan, onCommit: {
                    })
                    .font(Font.system(size: 12))
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onReceive(Just(registerData.alamatPerusahaan)) { newValue in
                        let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                        if filtered != newValue {
                            self.registerData.alamatPerusahaan = filtered
                        }
                    }
                    
                    Button(action:{
                        searchAddress()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .font(Font.system(size: 20))
                            .foregroundColor(Color(hex: "#707070"))
                    })
                    
                }
                
            }
            .padding(.horizontal, 20)
            
            // Label Province
            VStack(alignment: .leading) {
                Text("Province".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Province".localized(language), text: $registerData.provinsiPerusahaan)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allProvince.count, id: \.self) { i in
                            Button(action: {
                                registerData.provinsiPerusahaan = self.allProvince[i].name
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
            .padding(.horizontal, 20)
            
            // Label City
            VStack(alignment: .leading) {
                Text("City".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("City".localized(language), text: $registerData.kotaPerusahaan)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allRegency.count, id: \.self) { i in
                            Button(action: {
                                registerData.kotaPerusahaan = self.allRegency[i].name
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
            .padding(.horizontal, 20)
            
            // Label District
            VStack(alignment: .leading) {
                Text("District".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("District".localized(language), text: $registerData.kelurahan)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allDistrict.count, id: \.self) { i in
                            Button(action: {
                                registerData.kelurahan = self.allDistrict[i].name
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
            .padding(.horizontal, 20)
            
            // Label Village
            VStack(alignment: .leading) {
                Text("Sub-district".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Sub-district".localized(language), text: $registerData.kecamatan)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allVillage.count, id: \.self) { i in
                            Button(action: {
                                registerData.kecamatan = self.allVillage[i].name
                                registerData.kodePos = self.allVillage[i].postalCode ?? ""
                                self.kodePos = self.allVillage[i].postalCode ?? ""
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
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                
                Text("Postal code".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Postal code".localized(language), text: $kodePos) { change in
                    } onCommit: {
                        self.registerData.kodePos = self.kodePos
                    }
                    .onReceive(Just(kodePos)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.kodePos = filtered
                        }
                    }
                    .onReceive(kodePos.publisher.collect()) {
                        self.kodePos = String($0.prefix(5))
                    }
                    .keyboardType(.numberPad)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            .padding(.horizontal, 20)
            
            Group {
                
                Text("Company Telephone Number".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    Text("+62 ")
                        .font(Font.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                    
                    Divider()
                        .frame(height: 30)
                    
                    TextField("Company Telephone Number".localized(language), text: $noTlpPerusahaan) {change in
                    } onCommit: {
                        self.registerData.noTeleponPerusahaan = self.noTlpPerusahaan
                    }
                    .onReceive(Just(noTlpPerusahaan)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.noTlpPerusahaan = filtered
                        }
                    }
                    .onReceive(noTlpPerusahaan.publisher.collect()) {
                        if String($0).hasPrefix("0") {
                            self.noTlpPerusahaan = String(String($0).substring(with: 1..<String($0).count).prefix(12))
                        } else {
                            self.noTlpPerusahaan = String($0.prefix(12))
                        }
                    }
                    .keyboardType(.numberPad)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            .padding(.horizontal, 20)
            
        }
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    func createBottomFloater() -> some View {
        VStack {
            HStack {
                Text("Company's address".localized(language))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                MultilineTextField("Company's address".localized(language), text: $location, onCommit: {
                })
                .font(Font.system(size: 14))
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Button(action:{
                    searchAddress()
                }, label: {
                    Image(systemName: "location")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            
            ScrollView {
                VStack {
                    ForEach(addressSugestionResult, id: \.formatted_address) {data in
                        Button(action: {
                            searchAddress(data: data.formatted_address)
                            self.showingModal.toggle()
                        }) {
                            VStack {
                                HStack{
                                    Text(data.formatted_address)
                                    Spacer()
                                }
                                Divider()
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 150)
            .padding(.vertical)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - SEARCH LOCATION
    @ObservedObject var addressVM = AddressSummaryViewModel()
    func searchAddress(keyword: String? = nil) {
        self.isLoading = true
        
        self.addressVM.getAddressSugestionResult(addressInput: keyword ?? registerData.alamatPerusahaan) { success in
            if success {
                self.isLoading = self.addressVM.isLoading
                self.addressSugestionResult = self.addressVM.addressResult
                self.showingModal = true
                print("Success")
                print("addressSugestionResult => \(self.addressSugestionResult[0])")
            }
            
            if !success {
                self.isLoading = self.addressVM.isLoading
                self.isShowAlert = true
                self.messageResponse = self.addressVM.message
                print("Not Found")
            }
        }
    }
    
    // MARK: - SEARCH LOCATION COMPLETION
    func searchAddress(data: String) {
        self.isLoading = true
        
        self.addressVM.getAddressSugestion(addressInput: data) { success in
            if success {
                self.isLoading = self.addressVM.isLoading
                self.addressSugestion = self.addressVM.address
                DispatchQueue.main.async {
                    registerData.alamatPerusahaan = self.addressSugestion[0].street
                    registerData.kotaPerusahaan = self.addressSugestion[0].city
                    registerData.provinsiPerusahaan = self.addressSugestion[0].province
                    registerData.kodePos = self.addressSugestion[0].postalCode
                    self.kodePos = self.addressSugestion[0].postalCode
                    registerData.kecamatan = self.addressSugestion[0].kelurahan
                    registerData.kelurahan = self.addressSugestion[0].kecamatan
                }
                self.getAllProvince()
                self.showingModal = false
                print("Success")
                print("self.addressSugestion[0].postalCode => \(self.addressSugestion[0].postalCode)")
            }
            
            if !success {
                self.isLoading = self.addressVM.isLoading
                self.isShowAlert = true
                self.messageResponse = self.addressVM.message
                print("Not Found")
            }
        }
    }
    
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
}

struct FormInformasiPerusahaanView_Previews: PreviewProvider {
    static var previews: some View {
        InformasiPerusahaanView().environmentObject(RegistrasiModel())
    }
}
