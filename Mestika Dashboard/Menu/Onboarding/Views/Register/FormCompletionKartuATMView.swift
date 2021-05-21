//
//  CompletionDataView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 23/11/20.
//

import SwiftUI
import SystemConfiguration

struct FormCompletionKartuATMView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var appState: AppState
    
    /* Environtment Object */
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    @ObservedObject private var productVM = ATMProductViewModel()
    
    @State var location : String = ""
    @State var kodePos : String = ""
    @State var showingAddressModal = false
    @State var showingSuggestionNameModal = false
    @State var goToSuccessPage = false
    @State var isLoading = false
    
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var addressOptionId = 1
    
    @State private var isShowAlert: Bool = false
    
    @State var messageResponse: String = ""
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    @State var isShowingAlert: Bool = false
    @State var isShowAlertInternetConnection = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    //Dummy data
    
    @State var addressOptions: [MasterModel] = [
        MasterModel(id: 1, name: "Address according to Identity Card/(KTP)".localized(LocalizationService.shared.language)),
        MasterModel(id: 2, name: "Mailing address".localized(LocalizationService.shared.language)),
        MasterModel(id: 3, name: "Company's address".localized(LocalizationService.shared.language)),
//        MasterModel(id: 4, name: "Other Address".localized(LocalizationService.shared.language)),
    ]
    
    @State var addressOptionsNonPekerja: [MasterModel] = [
        MasterModel(id: 1, name: "Address according to Identity Card/(KTP)".localized(LocalizationService.shared.language)),
        MasterModel(id: 2, name: "Mailing address".localized(LocalizationService.shared.language)),
//        MasterModel(id: 4, name: "Other Address".localized(LocalizationService.shared.language)),
    ]
    
    @State var suggestions:[String] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color(hex: "#232175")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                AppBarLogo(light: false, onCancel:{})
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text("COMPLETE DATA".localized(language))
                            .multilineTextAlignment(.center)
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 30, leading: 15, bottom: 0, trailing: 15))
                        
                        nameCard
                        addressCard
                        
                        Button(action: {
                            self.atmData.atmAddressPostalCodeInput = self.kodePos
                            //                            if (self.user.last?.isNasabahMestika == true) {
                            //                                self.goToSuccessPage = true
                            //                            } else {
                            //                                self.postData()
                            //                            }
                            self.goToSuccessPage = true
                        }, label: {
                            Text("Submit Data".localized(language))
                                .foregroundColor(Color(hex: !isValid() ? "#FFFFFF" : "#2334D0"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                        .background(Color(hex: !isValid() ? "#CBD1D9" : "#FFFFFF"))
                        .disabled(!isValid())
                        .cornerRadius(15)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                    .padding(.bottom, 35)
                }
            }
            
            NavigationLink(destination: FormDetailKartuATMView(isAllowBack: false).environmentObject(atmData).environmentObject(registerData), isActive: $goToSuccessPage){
                EmptyView()
            }
            
            if self.showingAddressModal || self.showingSuggestionNameModal || self.isShowAlertInternetConnection {
                ModalOverlay(tapAction: { withAnimation {
                    self.showingAddressModal = false
                    self.isShowAlertInternetConnection = false
                } })
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingAddressModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomAddressFloater()
        }
        .popup(isPresented: $showingSuggestionNameModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomSuggestionNameFloater()
        }
        .popup(isPresented: $isShowAlertInternetConnection, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            PopupNoInternetConnection()
        }
        .onAppear {
            user.forEach { (data) in
                atmData.atmName = data.namaLengkapFromNik!
                registerData.namaLengkapFromNik = data.namaLengkapFromNik!
                registerData.provinsiFromNik = data.provinsiFromNik!
                registerData.alamatKtpFromNik = data.alamatKtpFromNik!
                registerData.kecamatanFromNik = data.kecamatanFromNik!
                registerData.kelurahanFromNik = data.kelurahanFromNik!
                registerData.kodePosFromNik = data.kodePosFromNik!
                registerData.kabupatenKotaFromNik = data.kabupatenKotaFromNik!
                registerData.rtFromNik = data.rtFromNik ?? ""
                registerData.rwFromNik = data.rwFromNik ?? ""
                registerData.nik = data.nik!
                
                registerData.alamatSuratMenyurat = data.addressInput!
                registerData.kecamatanSuratMenyurat = data.addressKecamatanInput!
                registerData.kelurahanSuratMenyurat = data.addressKelurahanInput!
                registerData.kodePosSuratMenyurat = data.addressPostalCodeInput!
                registerData.kotaSuratMenyurat = data.addressKotaInput!
                registerData.provinsiSuratMenyurat = data.addressProvinsiInput!
                registerData.rtSuratMenyurat = data.addressRtInput ?? ""
                registerData.rwSuratMenyurat = data.addressRwInput ?? ""
                
                registerData.kabKota = data.kabKota!
                registerData.kecamatan = data.kecamatan!
                registerData.kelurahan = data.kelurahan!
                registerData.alamatPerusahaan = data.alamatPerusahaan!
                registerData.kodePos = data.kodePos!
//                registerData.rtrw = data.rtrw ?? ""
//                registerData.rtPerusahaan = data.rtPerusahaan!
//                registerData.rwPerusahaan = data.rwPerusahaan!
                registerData.kotaPerusahaan = data.kotaPerusahaan!
                registerData.provinsiPerusahaan = data.provinsiPerusahaan!
                
                registerData.isAddressEqualToDukcapil = data.isAddressEqualToDukcapil
            }
        }
        .onAppear(){
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
            if self.isNetworkReachability(with: flags) {
                fetchAddressOption()
            } else {
                self.isShowAlertInternetConnection = true
            }
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE".localized(language)),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("OK".localized(language)))
            )
        }
    }
    
    var nameCard: some View {
        ZStack {
            VStack {
                Text("Name on ATM Card".localized(language))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text("This name will be printed on your new ATM card".localized(language))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat", size: 12))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
                
                HStack {
                    Button(action:{
                        showingSuggestionNameModal.toggle()
                    }, label: {
                        if atmData.atmName != "" {
                            Text(atmData.atmName)
                                .font(Font.system(size: 14))
                                .foregroundColor(.black)
                                .frame(height: 36)
                        } else {
                            Text("Enter Name".localized(language))
                                .font(Font.system(size: 14))
                                .foregroundColor(Color.gray.opacity(0.5))
                                .frame(height: 36)
                        }
                        Spacer()
                    })
                }
                .padding(.horizontal, 15)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.top, 20)
    }
    
    var addressCard: some View {
        VStack {
            Text("Shipping address".localized(language))
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color("DarkStaleBlue"))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            if registerData.pekerjaanId == 10 || registerData.pekerjaanId == 11 || registerData.pekerjaanId == 12 {
                RadioButtonGroup(
                    items: addressOptionsNonPekerja,
                    selectedId: $addressOptionId) { selected in
                    fetchAddressOption()
                }
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            } else {
                RadioButtonGroup(
                    items: addressOptions,
                    selectedId: $addressOptionId) { selected in
                    fetchAddressOption()
                }
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            }
            
            VStack { Divider() }.padding(.horizontal, 20)
            
            if addressOptionId == 4 {
                formAddress
            }
            
            if addressOptionId == 3 {
                formPerusahaan
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.top, 20)
    }
    
    var formAddress: some View {
        VStack(alignment: .leading) {
            
            Group {
                
                Text("")
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    //                    TextField("Address".localized(language), text: $atmData.atmAddressInput) { changed in
                    //                    } onCommit: {
                    //                    }
                    //                    .font(Font.system(size: 14))
                    //                    .frame(height: 36)
                    //                    .disabled(addressOptionId != 4)
                    //                    .padding(.horizontal)
                    //                    .background(Color.gray.opacity(0.1))
                    //                    .cornerRadius(10)
                    
                    
                    MultilineTextField("Address".localized(language), text: $atmData.atmAddressInput, onCommit: {
                    })
                    .font(Font.system(size: 11))
                    .disabled(addressOptionId != 4)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    if addressOptionId == 4 {
                        Button(action:{
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            if self.isNetworkReachability(with: flags) {
                                searchAddress()
                            } else {
                                self.isShowAlertInternetConnection = true
                            }
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .font(Font.system(size: 20))
                                .foregroundColor(Color(hex: "#707070"))
                        })
                    }
                }
                
            }
            
            HStack {
                LabelTextField(value: $atmData.atmAddressRtInput, label: "", placeHolder: "RT".localized(language), disabled:addressOptionId != 4 ) { (change) in
                    
                } onCommit: {
                    
                }
                
                LabelTextField(value: $atmData.atmAddressRwInput, label: "", placeHolder: "RW".localized(language), disabled:addressOptionId != 4 ) { (change) in
                    
                } onCommit: {
                    
                }
            }
            
            LabelTextField(value: $atmData.atmAddressKelurahanInput, label: "", placeHolder: "District".localized(language), disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddressKecamatanInput, label: "", placeHolder: "Sub-district".localized(language), disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddressKotaInput, label: "", placeHolder: "City".localized(language), disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddressPropinsiInput, label: "", placeHolder: "Province".localized(language), disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            HStack {
                TextField("Postal code".localized(language), text: $kodePos) {change in
                } onCommit: {
                    self.atmData.atmAddressPostalCodeInput = self.kodePos
                }
                .onReceive(kodePos.publisher.collect()) {
                    self.kodePos = String($0.prefix(5))
                }
                .keyboardType(.numberPad)
                .font(Font.system(size: 14))
                .frame(height: 36)
                .disabled(addressOptionId != 4)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
    }
    
    var formPerusahaan: some View {
        VStack(alignment: .leading) {
            
            Group {
                
                Text("")
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    MultilineTextField("Address".localized(language), text: $registerData.alamatPerusahaan, onCommit: {
                    })
                    .font(Font.system(size: 14))
                    .disabled(true)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
            }
            
//            LabelTextField(value: $registerData.rtrw, label: "", placeHolder: "RT/RW".localized(language), disabled: true ) { (change) in
//
//            } onCommit: {
//
//            }
            
            
            LabelTextField(value: $registerData.kabKota, label: "", placeHolder: "City".localized(language), disabled: true) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $registerData.kelurahan, label: "", placeHolder: "District".localized(language), disabled: true) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $registerData.kecamatan, label: "", placeHolder: "Sub-district".localized(language), disabled: true
            ) { (change) in
                
            } onCommit: {
                
            }
            
            HStack {
                TextField("Postal code".localized(language), text: $registerData.kodePos) {change in
                } onCommit: {
                    self.registerData.kodePos = self.kodePos
                }
                .onReceive(kodePos.publisher.collect()) {
                    self.kodePos = String($0.prefix(5))
                }
                .keyboardType(.numberPad)
                .font(Font.system(size: 14))
                .frame(height: 36)
                .disabled(true)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
    }
    
    var referalCodeCard: some View {
        ZStack {
            VStack {
                Text("Enter Referral Code".localized(language))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text("How do you know the information on Digital Banking Bank mestika".localized(language))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat", size: 12))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Group {
                    
                    Text("")
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("Enter the referral code".localized(language), text: $atmData.atmAddresspostalReferral) { changed in
                            
                        } onCommit: {
                        }
                        .font(Font.system(size: 14))
                        .frame(height: 36)
                    }
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                }
            }
            .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.vertical, 20)
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    func createBottomSuggestionNameFloater() -> some View {
        VStack {
            HStack {
                Text("Name Card".localized(language))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                MultilineTextField("Company's address".localized(language), text: $location, onCommit: {
                })
                .font(Font.system(size: 14))
                .disabled(true)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            List(self.suggestions, id: \.self) { suggestion in
                
                HStack {
                    Text(suggestion)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(suggestion)
                    atmData.atmName = suggestion
                    self.showingSuggestionNameModal.toggle()
                })
                
            }
            .background(Color.white)
            .padding(.bottom)
            .frame(height: 150)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .onAppear() {
            self.generateNameSuggestion()
        }
    }
    
    func createBottomAddressFloater() -> some View {
        VStack {
            HStack {
                Text("Address".localized(language))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                HStack {
                    MultilineTextField("Company's address".localized(language), text: $location, onCommit: {
                    })
                    .font(Font.system(size: 14))
                    .disabled(true)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Button(action:{
                    searchAddress(keyword: location)
                }, label: {
                    Image(systemName: "location.viewfinder")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            
            ScrollView {
                VStack {
                    ForEach(addressSugestionResult, id: \.formatted_address) {data in
                        Button(action: {
                            searchAddress(data: data.formatted_address)
                            self.showingAddressModal.toggle()
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
    
    func PopupNoInternetConnection() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Please check your internet connection".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.isShowAlertInternetConnection = false
                    appState.moveToWelcomeView = true
                },
                label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    func isValid() -> Bool {
        if addressOptionId == 4 {
            return atmData.atmName.trimmingCharacters(in: .whitespaces).count > 0 && atmData.atmAddressInput.trimmingCharacters(in: .whitespaces).count > 0 && atmData.atmAddressKecamatanInput.trimmingCharacters(in: .whitespaces).count > 0 &&
                atmData.atmAddressKotaInput.trimmingCharacters(in: .whitespaces).count > 0 &&
                atmData.atmAddressPropinsiInput.trimmingCharacters(in: .whitespaces).count > 0
                && atmData.atmAddressKelurahanInput.trimmingCharacters(in: .whitespaces).count > 0 && (atmData.atmAddressPostalCodeInput.trimmingCharacters(in: .whitespaces).count > 0 || self.kodePos.trimmingCharacters(in: .whitespaces).count > 0)
        } else {
            return !atmData.atmName.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    func fetchAddressOption() {
        switch addressOptionId {
        case 1: /// Sesuai KTP
            print("Case 1")
            atmData.atmAddressInput = registerData.alamatKtpFromNik
            atmData.atmAddressPostalCodeInput = registerData.kodePosFromNik
            atmData.atmAddressKecamatanInput = registerData.kecamatanFromNik
            atmData.atmAddressKelurahanInput = registerData.kelurahanFromNik
            atmData.atmAddressKotaInput = registerData.kabupatenKotaFromNik
//            atmData.atmAddressrtRwInput = "\(registerData.rtFromNik)/\(registerData.rwFromNik)"
//            atmData.atmAddressRtInput = registerData.rtFromNik
//            atmData.atmAddressRwInput = registerData.rwFromNik
            atmData.addressEqualToDukcapil = true
        case 2: /// Surat Menyurat
            print("Case 2")
            
            if registerData.isAddressEqualToDukcapil {
                            atmData.atmAddressInput = registerData.alamatKtpFromNik
                            atmData.atmAddressPostalCodeInput = registerData.kodePosFromNik
                            atmData.atmAddressKecamatanInput = registerData.kecamatanFromNik
                            atmData.atmAddressKelurahanInput = registerData.kelurahanFromNik
                            atmData.atmAddressKotaInput = registerData.kabupatenKotaFromNik
                            atmData.atmAddressPropinsiInput = registerData.provinsiFromNik
//                atmData.atmAddressRtInput = registerData.rtFromNik
//                atmData.atmAddressRwInput = registerData.rwFromNik
//                            atmData.atmAddressrtRwInput = "\(registerData.rtFromNik)/\(registerData.rwFromNik)"
                            atmData.addressEqualToDukcapil = true
            } else {
                atmData.atmAddressInput = registerData.alamatSuratMenyurat
                atmData.atmAddressPostalCodeInput = registerData.kodePosSuratMenyurat
                atmData.atmAddressKecamatanInput = registerData.kecamatanSuratMenyurat
                atmData.atmAddressKelurahanInput = registerData.kelurahanSuratMenyurat
//                atmData.atmAddressrtRwInput = "\(registerData.rtSuratMenyurat)/\(registerData.rwSuratMenyurat)"
//                atmData.atmAddressRtInput = registerData.rtSuratMenyurat
//                atmData.atmAddressRwInput = registerData.rwSuratMenyurat
                atmData.atmAddressKotaInput = registerData.kotaSuratMenyurat
                atmData.atmAddressPropinsiInput = registerData.provinsiSuratMenyurat
                atmData.addressEqualToDukcapil = false
            }
            
        case 3: /// Perusahaan
            print("Case 3")
            atmData.atmAddressInput = registerData.alamatPerusahaan
            atmData.atmAddressPostalCodeInput = registerData.kodePos
            atmData.atmAddressKecamatanInput = registerData.kecamatan
            atmData.atmAddressKelurahanInput = registerData.kelurahan
//            atmData.atmAddressrtRwInput = registerData.rtrw
//            atmData.atmAddressRtInput = registerData.rtPerusahaan
//            atmData.atmAddressRwInput = registerData.rwPerusahaan
            atmData.atmAddressPropinsiInput = registerData.provinsiPerusahaan
            atmData.atmAddressKotaInput = registerData.kotaPerusahaan
            atmData.addressEqualToDukcapil = false
        case 4:
            print("Case 4")
            self.kodePos = ""
            atmData.atmAddressInput = ""
            atmData.atmAddressPostalCodeInput = ""
            atmData.atmAddressKotaInput = ""
            atmData.atmAddressKecamatanInput = ""
            atmData.atmAddressKelurahanInput = ""
//            atmData.atmAddressrtRwInput = ""
            atmData.addressEqualToDukcapil = false
        default:
            self.kodePos = ""
            atmData.atmAddressInput = ""
            atmData.atmAddressPostalCodeInput = ""
            atmData.atmAddressKecamatanInput = ""
            atmData.atmAddressKotaInput = ""
            atmData.atmAddressKelurahanInput = ""
//            atmData.atmAddressrtRwInput = ""
            atmData.addressEqualToDukcapil = false
        }
    }
    
    func postData() {
        ///MARK : Complete data
        var isVideoCall = UserDefaults.standard.string(forKey: "register_nasabah_video_call") ?? ""
        
        atmData.nik = registerData.nik
        atmData.isNasabahMestika = false
        atmData.isVcall = isVideoCall == "true" ? true : false
        atmData.codeClass = atmData.productType
        
        
        self.goToSuccessPage = true
        self.isLoading = true
        
        productVM.addProductATM(dataRequest: atmData) { (success: Bool) in
            self.isLoading = false
            if success {
                self.goToSuccessPage = true
            }
        }
    }
    
    func generateNameSuggestion() {
        self.suggestions = []
        let names = self.registerData.namaLengkapFromNik.split(separator: " ").map { (name: Substring) -> String in
            return name.uppercased()
        }
        
        //suggestion 1
        let suggestion1 = names.joined(separator: " ")
        self.suggestions.append(suggestion1)
        
        //suggestion 2
        names.forEach { (name:String) in
            let alias = "\(name.substring(to: 1))."
            let suggestion = names.joined(separator: " ").replacingOccurrences(of: name, with: alias)
            if !self.suggestions.contains(suggestion) {
                self.suggestions.append(suggestion)
            }
        }
    }
    
    // MARK: - SEARCH LOCATION
    @ObservedObject var addressVM = AddressSummaryViewModel()
    func searchAddress(keyword: String? = nil) {
        self.isLoading = true
        
        self.addressVM.getAddressSugestionResult(addressInput: keyword ?? atmData.atmAddressInput) { success in
            if success {
                self.isLoading = self.addressVM.isLoading
                self.addressSugestionResult = self.addressVM.addressResult
                self.showingAddressModal = true
                print("Success")
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
                    
                    self.kodePos = self.addressSugestion[0].postalCode
                    atmData.atmAddressKotaInput = self.addressSugestion[0].city
                    atmData.atmAddressPropinsiInput = self.addressSugestion[0].province
                    atmData.atmAddressInput = self.addressSugestion[0].formatted_address
                    atmData.atmAddressPostalCodeInput = self.addressSugestion[0].postalCode
                    atmData.atmAddressKecamatanInput = self.addressSugestion[0].kecamatan
                    atmData.atmAddressKelurahanInput = self.addressSugestion[0].kelurahan
//                    atmData.atmAddressrtRwInput = "\(self.addressSugestion[0].rt)/\(self.addressSugestion[0].rw)"
                    atmData.addressEqualToDukcapil = false
                }
                
                self.showingAddressModal = false
                print("Success")
            }
            
            if !success {
                self.isLoading = self.addressVM.isLoading
                self.isShowAlert = true
                self.messageResponse = self.addressVM.message
                print("Not Found")
            }
        }
    }
    
    func isNetworkReachability(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }
}

struct FormCompletionDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormCompletionKartuATMView().environmentObject(AddProductATM()).environmentObject(RegistrasiModel())
    }
}
