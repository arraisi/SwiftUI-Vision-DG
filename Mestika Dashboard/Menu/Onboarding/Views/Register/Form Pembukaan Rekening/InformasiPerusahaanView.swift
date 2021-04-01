//
//  FormInformasiPerusahaanView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 28/09/20.
//

import SwiftUI
import Indicators

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
    
    let bidangUsaha:[BidangUsaha] = [
        .init(nama: "Minimarket/ Jasa Parkir/ SPBU"),
        .init(nama: "Ekspor/ Impor"),
        .init(nama: "Perdagangan Barang Antik"),
        .init(nama: "Biro Perjalanan/ Travel"),
        .init(nama: "Perdagangan Emas/ Permata/ Logam Mulia"),
        .init(nama: "Properti/ Real Estate/ Kontraktor"),
        .init(nama: "Money Changer"),
        .init(nama: "MLM (Multi Level Marketing)"),
        .init(nama: "Pedagang Sayur"),
        .init(nama: "Perdagangan/ Jual Beli"),
        .init(nama: "Restoran/ Rumah Makan"),
        .init(nama: "Jasa Pendidikan"),
        .init(nama: "Jasa Kesehatan"),
        .init(nama: "Perkebunan"),
        .init(nama: "Pertanian dan Perikanan"),
        .init(nama: "Peternakan"),
        .init(nama: "Industri/ Pabrik"),
        .init(nama: "Perhotelan"),
        .init(nama: "Pengangkutan/ Transportasi"),
        .init(nama: "Lembaga Keuangan"),
        .init(nama: "Yayasan Sosial"),
        .init(nama: "Konstruksi/ Kontraktor"),
        .init(nama: "Notaris"),
        .init(nama: "Konsultan Keuangan/ Perencana Keuangan"),
        .init(nama: "Advokat"),
        .init(nama: "Konsultan Pajak"),
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
                                            destination: VerificationRegisterDataView().environmentObject(registerData),
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
        .popup(isPresented: $showingModalBidang, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomFloaterBidangUsaha()
        }
        .onAppear() {
            self.noTlpPerusahaan = self.registerData.noTeleponPerusahaan
            self.kodePos = self.registerData.kodePos
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("Oke"))
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
            .padding(.horizontal, 20)
            
            
            Group {
                Text("Business fields".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                //                HStack {
                //
                //                    TextField("Bidang Usaha", text: $registerData.bidangUsaha) { changed in
                //                    } onCommit: {
                //                    }
                //                    .font(Font.system(size: 14))
                //                    .frame(height: 36)
                //                    .disabled(true)
                //
                //                    Button(action:{
                //                        showingModalBidang.toggle()
                //                    }, label: {
                //                        Image(systemName: "chevron.right")
                //                    })
                //
                //                }
                //                .padding(.horizontal)
                //                .background(Color.gray.opacity(0.1))
                //                .cornerRadius(10)
                
                HStack {
                    TextField("Business fields".localized(language), text: $registerData.bidangUsaha)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<bidangUsaha.count, id: \.self) { i in
                            Button(action: {
                                registerData.bidangUsaha = bidangUsaha[i].nama
                            }) {
                                Text(bidangUsaha[i].nama)
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .fixedSize(horizontal: false, vertical: true)
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
                    .font(Font.system(size: 11))
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button(action:{
                        //                        showingModal.toggle()
                        searchAddress()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .font(Font.system(size: 20))
                            .foregroundColor(Color(hex: "#707070"))
                    })
                    
                }
                
            }
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
            
            LabelTextField(value: $registerData.kecamatan, label: "Sub-district".localized(language), placeHolder: "Sub-district".localized(language)) { (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .padding(.horizontal, 20)
            
            LabelTextField(value: $registerData.kelurahan, label: "District".localized(language), placeHolder: "District".localized(language)) { (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
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
            
//            HStack {
//
//                TextField("Company's address".localized(language), text: $location)
//                    .font(Font.system(size: 14))
//                    .frame(height: 36)
//
//                Button(action:{
//                    searchAddress(keyword: location)
//                }, label: {
//                    Image(systemName: "location")
//                        .font(Font.system(size: 20))
//                        .foregroundColor(Color(hex: "#707070"))
//                })
//
//            }
//            .padding(.horizontal)
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(10)
            
            HStack {
                
                MultilineTextField("Company's address".localized(language), text: $location, onCommit: {
                })
                .font(Font.system(size: 14))
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Button(action:{
                    //                        showingModal.toggle()
                    searchAddress()
                }, label: {
                    Image(systemName: "location")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            
            //            List(addressSugestionResult, id: \.formatted_address) { data in
            //
            //                AddressSuggestionRow(address: data.formatted_address)
            //                .onTapGesture(perform: {
            //                    searchAddress(data: data.formatted_address)
            //                    self.showingModal.toggle()
            //                })
            //
            //            }
            ////            .background(Color.white)
            //            .padding(.vertical)
            //            .frame(height: 150)
            
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
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    func createBottomFloaterBidangUsaha() -> some View {
        VStack {
            HStack {
                Text("Business fields".localized(language))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            //            HStack {
            //
            //                TextField("Cari Bidang Usaha", text: $registerData.bidangUsaha)
            //                    .font(Font.system(size: 14))
            //                    .frame(height: 36)
            //
            //                Button(action:{
            //                    print("cari bidang usaha")
            //                }, label: {
            //                    Image(systemName: "magnifyingglass")
            //                        .font(Font.system(size: 20))
            //                        .foregroundColor(Color(hex: "#707070"))
            //                })
            //
            //            }
            //            .padding(.horizontal)
            //            .background(Color.gray.opacity(0.1))
            //            .cornerRadius(10)
            
            ScrollView {
                VStack {
                    ForEach(0...bidangUsaha.count-1, id: \.self) {index in
                        Button(action: {
                            registerData.bidangUsaha = bidangUsaha[index].nama
                            self.showingModalBidang.toggle()
                        }) {
                            VStack(alignment: .center) {
                                HStack {
                                    Text(bidangUsaha[index].nama)
                                        .font(Font.system(size: 14))
                                    
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
                    registerData.alamatPerusahaan = self.addressSugestion[0].formatted_address
                    registerData.kotaPerusahaan = self.addressSugestion[0].city
                    registerData.provinsiPerusahaan = self.addressSugestion[0].province
                    registerData.kodePos = self.addressSugestion[0].postalCode
                    self.kodePos = self.addressSugestion[0].postalCode
                    registerData.kecamatan = self.addressSugestion[0].kecamatan
                    registerData.kelurahan = self.addressSugestion[0].kelurahan
                    registerData.rtrw = "\(self.addressSugestion[0].rt) / \(self.addressSugestion[0].rw)"
                }
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
}

struct FormInformasiPerusahaanView_Previews: PreviewProvider {
    static var previews: some View {
        InformasiPerusahaanView().environmentObject(RegistrasiModel())
    }
}
