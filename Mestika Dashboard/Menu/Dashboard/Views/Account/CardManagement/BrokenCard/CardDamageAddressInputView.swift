//
//  CardDamageAddressInputView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/03/21.
//

import SwiftUI
import Combine

struct CardDamageAddressInputView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var cardData: BrokenKartuKuModel
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var addressOptions: [MasterModel] = [
        MasterModel(id: 1, name: "Address according to Identity Card/(KTP)".localized(LocalizationService.shared.language)),
        MasterModel(id: 2, name: "Mailing address".localized(LocalizationService.shared.language)),
        MasterModel(id: 3, name: "Company's address".localized(LocalizationService.shared.language)),
    ]
    
    @State var addressOptionId = 0
    
    @State var allProvince = MasterProvinceResponse()
    @State var allRegency = MasterRegencyResponse()
    @State var allDistrict = MasterDistrictResponse()
    @State var allVillage = MasterVilageResponse()
    
    @State var addressInput: String = ""
//    @State var addressRtRwInput: String = ""
    @State var addressKelurahanInput: String = ""
    @State var addressKecamatanInput: String = ""
    @State var addressKodePosInput: String = ""
    @State var addressKotaInput: String = ""
    @State var addressProvinsiInput: String = ""
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    @State var showingModal = false
    
    @State var isLoading: Bool = false
    @State private var isShowAlert: Bool = false
    
    @State var isRoute: Bool = false
    
    @State var messageResponse: String = ""
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    var disableForm: Bool {
        if addressOptionId == 0 || addressInput.isEmpty || addressKelurahanInput.isEmpty || addressKecamatanInput.isEmpty || addressKodePosInput.isEmpty {
            return true
        }
        
        return false
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text("MAKE SURE YOUR INFORMATION IS CORRECT".localized(language))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        addressCard
                            .padding(.bottom, 10)
                        
                        VStack(alignment: .center) {
                            Text("Make sure your correspondence address is correct".localized(language))
                                .font(.title2)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                            
                            Group {
                                Divider()
                                    .padding(.horizontal, 20)
                                
                                Group {
                                    HStack {
                                        Text("Address".localized(language))
                                            .font(Font.system(size: 12))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#707070"))
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        MultilineTextField("Address".localized(language), text: $addressInput, onCommit: {
                                             self.cardData.addressInput = self.addressInput
                                        })
                                        .onReceive(Just(addressInput)) { newValue in
                                            let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                                            if filtered != newValue {
                                                self.addressInput = filtered
                                            }
                                        }
                                        .font(Font.system(size: 14))
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        
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
                                
                                LabelTextField(value: $addressKotaInput, label: "City".localized(language), placeHolder: "City".localized(language), onEditingChanged: { (Bool) in
                                    print("on edit")
                                    cardData.addressKotaInput = self.addressKotaInput
                                }, onCommit: {
                                    print("on commit")
                                    cardData.addressKotaInput = self.addressKotaInput
                                })
                                .onReceive(addressKotaInput.publisher.collect()) {
                                    self.addressKotaInput = String($0.prefix(20))
                                }
                                .padding(.horizontal, 20)
                                
                                LabelTextField(value: $addressProvinsiInput, label: "Province".localized(language), placeHolder: "Province".localized(language), onEditingChanged: { (Bool) in
                                    print("on edit")
                                    cardData.addressProvinsiInput = self.addressProvinsiInput
                                }, onCommit: {
                                    print("on commit")
                                    cardData.addressProvinsiInput = self.addressProvinsiInput
                                })
                                .onReceive(addressProvinsiInput.publisher.collect()) {
                                    self.addressProvinsiInput = String($0.prefix(15))
                                }
                                .padding(.horizontal, 20)
                                
                                LabelTextField(value: $addressKelurahanInput, label: "Village".localized(language), placeHolder: "Village".localized(language), onEditingChanged: { (Bool) in
                                    print("on edit")
                                    cardData.addressKelurahanInput = self.addressKelurahanInput
                                }, onCommit: {
                                    print("on commit")
                                    cardData.addressKelurahanInput = self.addressKelurahanInput
                                })
                                .onReceive(addressKelurahanInput.publisher.collect()) {
                                    self.addressKelurahanInput = String($0.prefix(50))
                                }
                                .padding(.horizontal, 20)
                                
                                LabelTextField(value: $addressKecamatanInput, label: "Sub-district".localized(language), placeHolder: "Sub-district".localized(language), onEditingChanged: { (Bool) in
                                    print("on edit")
                                    cardData.addressKecamatanInput = self.addressKecamatanInput
                                }, onCommit: {
                                    print("on commit")
                                    cardData.addressKecamatanInput = self.addressKecamatanInput
                                })
                                .onReceive(addressKecamatanInput.publisher.collect()) {
                                    self.addressKecamatanInput = String($0.prefix(50))
                                }
                                .padding(.horizontal, 20)
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Postal code".localized(language))
                                        .font(Font.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(hex: "#707070"))
                                    
                                    HStack {
                                        TextField("Postal code".localized(language), text: $addressKodePosInput) { change in
                                        } onCommit: {
                                            print("on commit")
                                            cardData.addressPostalCodeInput = self.addressKodePosInput
                                        }
                                        .onReceive(Just(addressKodePosInput)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.addressKodePosInput = filtered
                                            }
                                        }
                                        .onReceive(addressKodePosInput.publisher.collect()) {
                                            self.addressKodePosInput = String($0.prefix(5))
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
                                .padding(.bottom, 30)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 30)
                        
                        Button(action: {
                            self.isRoute = true
                        }, label: {
                            Text("Submit Data".localized(language))
                                .foregroundColor(disableForm ? Color.white : Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disableForm)
                        .background(disableForm ? Color(.lightGray) : Color.white)
                        .cornerRadius(12)
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }
                
                NavigationLink(
                    destination: CardDamageDescriptionInputView().environmentObject(cardData),
                    isActive: self.$isRoute,
                    label: {
                        EmptyView()
                    })
                    .isDetailLink(false)
            }
            
        }
        .navigationBarTitle("Broken Card".localized(language), displayMode: .inline)
        .onAppear {
            print("ON APPEAR")
            getCustomerAddress()
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            addressSuggestionPopUp()
        }
    }
    
    var addressCard: some View {
        VStack {
            Text("Card Block Address".localized(language))
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color("DarkStaleBlue"))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
        
            RadioButtonGroup(
                items: addressOptions,
                selectedId: $addressOptionId) { selected in
                fetchAddressOption()
            }
            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            
            VStack { Divider() }.padding(.horizontal, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 50)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.top, 20)
    }
    
    func fetchAddressOption() {
        switch addressOptionId {
        case 1: /// Sesuai KTP
            print("Case Sesuai KTP")
            cardData.addressInput = self.profileVM.alamat
            cardData.addressKodePosInput = "40287"
            cardData.addressKecamatanInput = self.profileVM.kecamatanName
            cardData.addressKelurahanInput = self.profileVM.kelurahanName
            cardData.addressKotaInput = self.profileVM.kabupatenName
            cardData.addressProvinsiInput = self.profileVM.provinsiName
            
            self.addressInput = self.profileVM.alamat
            self.addressKelurahanInput = self.profileVM.kelurahanName
            self.addressKecamatanInput = self.profileVM.kecamatanName
            self.addressKodePosInput = "40287"
            self.addressKotaInput = self.profileVM.kabupatenName
            self.addressProvinsiInput = self.profileVM.provinsiName
        case 2: /// Sesuai Surat Menyurat
            print("Case Sesuai Surat Menyurat")
            cardData.addressInput = self.profileVM.alamatSuratMenyurat
            cardData.addressKodePosInput = self.profileVM.kodePosSuratMenyurat
            cardData.addressKecamatanInput = self.profileVM.kecamatanSuratMenyurat
            cardData.addressKelurahanInput = self.profileVM.kelurahanSuratMenyurat
            cardData.addressKotaInput = self.profileVM.kabupatenSuratMenyurat
            cardData.addressProvinsiInput = self.profileVM.provinsiSuratMenyurat
            
            self.addressInput = self.profileVM.alamatSuratMenyurat
            self.addressKelurahanInput = self.profileVM.kelurahanSuratMenyurat
            self.addressKecamatanInput = self.profileVM.kecamatanSuratMenyurat
            self.addressKodePosInput = self.profileVM.kodePosSuratMenyurat
            self.addressKotaInput = self.profileVM.kabupatenSuratMenyurat
            self.addressProvinsiInput = self.profileVM.provinsiSuratMenyurat
        case 3: /// Sesuai Perusahaan
            print("Case Sesuai Perusahaan")
            cardData.addressInput = self.profileVM.alamatPerusahaan
            cardData.addressKodePosInput = self.profileVM.kodePosPerusahaan
            cardData.addressKecamatanInput = self.profileVM.kecamatanPerusahaan
            cardData.addressKelurahanInput = self.profileVM.kelurahanPerusahaan
            cardData.addressKotaInput = self.profileVM.kotaPerusahaan
            cardData.addressProvinsiInput = self.profileVM.provinsiPerusahaan
            
            self.addressInput = self.profileVM.alamatPerusahaan
            self.addressKelurahanInput = self.profileVM.kelurahanPerusahaan
            self.addressKecamatanInput = self.profileVM.kecamatanPerusahaan
            self.addressKodePosInput = self.profileVM.kodePosPerusahaan
            self.addressKotaInput = self.profileVM.kotaPerusahaan
            self.addressProvinsiInput = self.profileVM.provinsiPerusahaan
        default:
            cardData.addressInput = ""
            cardData.addressPostalCodeInput = ""
            cardData.addressKecamatanInput = ""
            cardData.addressKelurahanInput = ""
            cardData.addressKotaInput = ""
            cardData.addressProvinsiInput = ""
            
            self.addressInput = ""
            self.addressKelurahanInput = ""
            self.addressKecamatanInput = ""
            self.addressKodePosInput = ""
            self.addressKotaInput = ""
            self.addressProvinsiInput = ""
        }
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    func addressSuggestionPopUp() -> some View {
        VStack {
            HStack {
                Text("Address".localized(language))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
//                TextField("Address".localized(language), text: $addressInput)
//                    .font(Font.system(size: 14))
//                    .frame(height: 36)
                
                MultilineTextField("Address".localized(language), text: $addressInput, onCommit: {
                })
                .font(Font.system(size: 14))
                
                Button(action:{
                    searchAddress(keyword: addressInput)
                }, label: {
                    Image(systemName: "location")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
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
        
        self.addressVM.getAddressSugestionResult(addressInput: keyword ?? addressInput) { success in
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
    
    @StateObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.isLoading = true
        self.profileVM.getProfile { success in
            if success {
                print(self.profileVM.limitOnUs)
                self.isLoading = false
                
                cardData.addressInput = self.profileVM.alamat
                cardData.addressPostalCodeInput = ""
                cardData.addressKecamatanInput = self.profileVM.kecamatanName
                cardData.addressKelurahanInput = self.profileVM.kelurahanName
//                cardData.addressRtRwInput = "\(self.profileVM.rt) / \(self.profileVM.rw)"
                
                self.addressInput = self.profileVM.alamat
//                self.addressRtRwInput = "\(self.profileVM.rt) / \(self.profileVM.rw)"
                self.addressKelurahanInput = self.profileVM.kelurahanName
                self.addressKecamatanInput = self.profileVM.kecamatanName
                self.addressKodePosInput = ""
            }
            
            if !success {
                self.isLoading = false
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
                    cardData.addressInput = self.addressSugestion[0].street
                    cardData.addressPostalCodeInput = self.addressSugestion[0].postalCode
                    cardData.addressKecamatanInput = self.addressSugestion[0].kecamatan
                    cardData.addressKelurahanInput = self.addressSugestion[0].kelurahan
                    cardData.addressKotaInput = self.addressSugestion[0].city
                    cardData.addressProvinsiInput = self.addressSugestion[0].province
//                    cardData.addressRtRwInput = "\(self.addressSugestion[0].rt) / \(self.addressSugestion[0].rw)"
                    
                    self.addressInput = self.addressSugestion[0].street
//                    self.addressRtRwInput = "\(self.addressSugestion[0].rt) / \(self.addressSugestion[0].rw)"
                    self.addressKelurahanInput = self.addressSugestion[0].kelurahan
                    self.addressKecamatanInput = self.addressSugestion[0].kecamatan
                    self.addressKodePosInput = self.addressSugestion[0].postalCode
                    self.addressKotaInput = self.addressSugestion[0].city
                    self.addressProvinsiInput = self.addressSugestion[0].province
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
    
    func getCustomerAddress() {
        self.isLoading = true
        self.profileVM.getCustomerAddress { success in
            if success {
                self.isLoading = false
            }
            
            if !success {
                self.isLoading = false
            }
        }
    }
}

struct CardDamageAddressInputView_Previews: PreviewProvider {
    static var previews: some View {
        CardDamageAddressInputView().environmentObject(CardBrokenModel())
    }
}
