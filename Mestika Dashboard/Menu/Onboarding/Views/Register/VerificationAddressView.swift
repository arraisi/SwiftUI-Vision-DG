//
//  VerificationAddressView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI
import Combine

struct VerificationAddressView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var registerData: RegistrasiModel
    @State var isShowNextView : Bool = false
    
    @State var addressInput: String = ""
//    @State var addressRtRwInput: String = ""
    @State var addressProvinsiInput: String = ""
    @State var addressKotaInput: String = ""
    @State var addressKelurahanInput: String = ""
    @State var addressKecamatanInput: String = ""
    @State var addressKodePosInput: String = ""
    
    let verificationAddress: [MasterModel] = load("verificationAddress.json")
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    @State var isShowingAlert: Bool = false
    
    @State var allProvince = MasterProvinceResponse()
    @State var allRegency = MasterRegencyResponse()
    @State var allDistrict = MasterDistrictResponse()
    @State var allVillage = MasterVilageResponse()
    
    var disableForm: Bool {
        
        if (registerData.verificationAddressId == 0) {
            return true
        }
        
        if (registerData.verificationAddressId != 1) {
            if addressKelurahanInput.isEmpty || addressKecamatanInput.isEmpty || addressKodePosInput.isEmpty || addressKotaInput.isEmpty || addressProvinsiInput.isEmpty {
                return true
            }
        } 
        
        return false
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    @State var showingModal = false
    
    @State var isLoading: Bool = false
    @State private var isShowAlert: Bool = false
    
    @State var messageResponse: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack(spacing: 0) {
                
                AppBarLogo(light: false, onCancel: {})
                
                ScrollView {
                    VStack {
                        Text("MAKE SURE YOUR INFORMATION IS CORRECT".localized(language))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .center) {
                            Text("Does Your Mailing Address Match Your Identity Card/(KTP)?".localized(language))
                                .font(.title2)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                            
                            ZStack {
                                
                                RadioButtonGroup(
                                    items: verificationAddress,
                                    selectedId: $registerData.verificationAddressId) { selected in
                                    print("Selected is: \(selected)")
                                    
                                    if (selected == 1) {
                                        registerData.isAddressEqualToDukcapil = true
                                    } else if (selected == 2) {
                                        registerData.isAddressEqualToDukcapil = false
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 15)
                                .padding(.bottom, 20)
                                
                            }
                            
                            if (registerData.verificationAddressId == 1 || registerData.verificationAddressId == 0) {
                                EmptyView()
                            } else {
                                
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
                                            MultilineTextField("Address".localized(language), text: $registerData.addressInput, onCommit: {
                                                self.addressInput = self.registerData.addressInput
                                            })
                                            .font(Font.system(size: 11))
                                            .padding(.horizontal)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                            .onReceive(Just(registerData.addressInput)) { newValue in
                                                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                                                if filtered != newValue {
                                                    self.registerData.addressInput = filtered
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
                                            
                                            TextField("Province".localized(language), text: $registerData.addressProvinsiInput)
                                                .font(Font.system(size: 14))
                                                .frame(height: 50)
                                                .padding(.leading, 15)
                                                .disabled(true)
                                            
                                            Menu {
                                                ForEach(0..<self.allProvince.count, id: \.self) { i in
                                                    Button(action: {
                                                        registerData.addressProvinsiInput = self.allProvince[i].name
                                                        self.addressProvinsiInput = self.allProvince[i].name
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
                                            
                                            TextField("City".localized(language), text: $registerData.addressKotaInput)
                                                .font(Font.system(size: 14))
                                                .frame(height: 50)
                                                .padding(.leading, 15)
                                                .disabled(true)
                                            
                                            Menu {
                                                ForEach(0..<self.allRegency.count, id: \.self) { i in
                                                    Button(action: {
                                                        registerData.addressKotaInput = self.allRegency[i].name
                                                        self.addressKotaInput = self.allRegency[i].name
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
                                            
                                            TextField("District".localized(language), text: $registerData.addressKelurahanInput)
                                                .font(Font.system(size: 14))
                                                .frame(height: 50)
                                                .padding(.leading, 15)
                                                .disabled(true)
                                            
                                            Menu {
                                                ForEach(0..<self.allDistrict.count, id: \.self) { i in
                                                    Button(action: {
                                                        registerData.addressKelurahanInput = self.allDistrict[i].name
                                                        self.addressKelurahanInput = self.allDistrict[i].name
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
                                            
                                            TextField("Sub-district".localized(language), text: $registerData.addressKecamatanInput)
                                                .font(Font.system(size: 14))
                                                .frame(height: 50)
                                                .padding(.leading, 15)
                                                .disabled(true)
                                            
                                            Menu {
                                                ForEach(0..<self.allVillage.count, id: \.self) { i in
                                                    Button(action: {
                                                        registerData.addressKecamatanInput = self.allVillage[i].name
                                                        registerData.kodePosKeluarga = self.allVillage[i].postalCode ?? ""
                                                        
                                                        self.addressKodePosInput = self.allVillage[i].postalCode ?? ""
                                                        self.addressKecamatanInput = self.allVillage[i].name
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
                                        
                                        HStack {
                                            TextField("Postal code".localized(language), text: $addressKodePosInput) { change in
                                            } onCommit: {
                                                print("on commit")
                                                registerData.addressPostalCodeInput = self.addressKodePosInput
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
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                }
                
                VStack {
                    NavigationLink(destination: PasswordView().environmentObject(registerData), isActive: self.$isShowNextView) {EmptyView()}
                    
                    
                    Button(action: {
                        
                        if (registerData.isAddressEqualToDukcapil) {
                            
                            self.registerData.addressInput = registerData.alamatKtpFromNik
                            self.registerData.addressKelurahanInput = registerData.kelurahanFromNik
                            self.registerData.addressKecamatanInput = registerData.kecamatanFromNik
                            self.registerData.addressPostalCodeInput = registerData.kodePosFromNik
                            self.registerData.addressProvinsiInput = registerData.provinsiFromNik
                            self.registerData.addressKotaInput = registerData.kabupatenKotaFromNik
                            
                            self.isShowNextView = true
                            
                        } else {
                            self.isShowNextView = true
                        }
                        
                    }, label: {
                        Text("Submit Data".localized(language))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .disabled(disableForm)
                    .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 100)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                }
                .background(Color.white)
            }
        }
        .KeyboardAwarePadding()
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            self.getAllProvince()
        }
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text("Do you want to cancel registration?".localized(language)),
                primaryButton: .default(Text("YES".localized(language)), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text("NO".localized(language))))
        }
        .popup(isPresented: $showingModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            addressSuggestionPopUp()
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.isShowingAlert = true
            }
        }))
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
        
        self.addressVM.getAddressSugestionResult(addressInput: keyword ?? registerData.addressInput) { success in
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
                    registerData.addressInput = self.addressSugestion[0].formatted_address
                    self.addressInput = self.addressSugestion[0].formatted_address
                    
                    registerData.addressPostalCodeInput = self.addressSugestion[0].postalCode
                    registerData.addressKecamatanInput = self.addressSugestion[0].kelurahan
                    registerData.addressKelurahanInput = self.addressSugestion[0].kecamatan
                    registerData.addressKotaInput = self.addressSugestion[0].city
                    registerData.addressProvinsiInput = self.addressSugestion[0].province
                    
                    self.addressKelurahanInput = self.addressSugestion[0].kecamatan
                    self.addressKecamatanInput = self.addressSugestion[0].kelurahan
                    self.addressKotaInput = self.addressSugestion[0].city
                    self.addressProvinsiInput = self.addressSugestion[0].province
                    self.addressKodePosInput = self.addressSugestion[0].postalCode
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

struct VerificationAddressView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationAddressView().environmentObject(RegistrasiModel())
    }
}
