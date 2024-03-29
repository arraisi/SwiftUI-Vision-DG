//
//  KeluargaTerdekat.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 12/10/20.
//

import SwiftUI
import Combine

struct KeluargaTerdekat: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    // Routing variables
    @State var editMode: EditMode = .inactive
    
    @State var selectionID : Int = 0
    @State var location : String = ""
    @State var showingModal = false
    @State var noTelepon: String = ""
    @State var kodePos : String = ""
    @State var nextViewActive: Bool = false
    @State var verificationViewActive: Bool = false
    
    let hubunganKekerabatanOptions = ["Ayah", "Ibu", "Kakak", "Adik", "Saudara", "Teman"]
    
    @State var isLoading: Bool = false
    @State private var isShowAlert: Bool = false
    
    @State var messageResponse: String = ""
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    @State var allProvince = MasterProvinceResponse()
    @State var allRegency = MasterRegencyResponse()
    @State var allDistrict = MasterDistrictResponse()
    @State var allVillage = MasterVilageResponse()
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 380)
                Color(hex: "#F6F8FB")
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                ScrollView {
                    
                    ZStack {
                        
                        VStack {
                            Color(hex: "#232175")
                                .frame(height: 380)
                            Color(hex: "#F6F8FB")
                                .cornerRadius(radius: 25.0, corners: .topLeft)
                                .cornerRadius(radius: 25.0, corners: .topRight)
                                .padding(.top, -30)
                        }
                        
                        VStack {
                            
                            // Title
                            Text("OPENING ACCOUNT DATA".localized(language))
                                .font(.custom("Montserrat-ExtraBold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 25)
                                .padding(.horizontal, 40)
                            
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
                                        Text("Your Immediate Family Data".localized(language))
                                            .font(.custom("Montserrat-SemiBold", size: 18))
                                            .foregroundColor(Color(hex: "#232175"))
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 30)
                                        
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
                                                destination: VerificationAddressView().environmentObject(registerData),
                                                isActive: $nextViewActive,
                                                label: {
                                                    Button(action: {
                                                        
                                                        self.registerData.kodePosKeluarga = self.kodePos
                                                        self.registerData.noTlpKeluarga = self.noTelepon
                                                        
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
                                            NavigationLink(
                                                destination: RegisterSummaryView(deviceModel: DeviceTraceModel()).environmentObject(registerData),
                                                isActive: $verificationViewActive,
                                                label: {
                                                    Button(action: {
                                                        
                                                        self.registerData.kodePosKeluarga = self.kodePos
                                                        self.registerData.noTlpKeluarga = self.noTelepon
                                                        
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
                                    .background(LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(25.0)
                                    .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 10, y: -2)
                                    .padding(.horizontal, 30)
                                    .padding(.top, 25)
                                    
                                }
                                
                            }
                            .padding(.bottom, 25)
                            
                        }
                    }
                }
                .KeyboardAwarePadding()
            }
            
            // Background Color When Modal Showing
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomFloater()
        }
        .onAppear() {
            self.getAllProvince()
            self.kodePos = self.registerData.kodePosKeluarga
            self.noTelepon = self.registerData.noTlpKeluarga
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("OK".localized(language)))
            )
        }
        .navigationBarBackButtonHidden(true)
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
        if registerData.hubunganKekerabatanKeluarga == "" {
            return true
        }
        if registerData.namaKeluarga == "" {
            return true
        }
        if registerData.alamatKeluarga == "" {
            return true
        }
        if kodePos == "" {
            return true
        }
        if registerData.kecamatanKeluarga == "" {
            return true
        }
        if registerData.kelurahanKeluarga == "" {
            return true
        }
        if noTelepon == ""  {
            return true
        }
        return false
    }
    
    // MARK: - Form Group
    
    var cardForm: some View {
        
        VStack(alignment: .leading) {
            Group {
                
                Text("Genetic Relationship".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Genetic Relationship".localized(language), text: $registerData.hubunganKekerabatanKeluarga)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<hubunganKekerabatanOptions.count, id: \.self) { i in
                            Button(action: {
                                print(hubunganKekerabatanOptions[i])
                                registerData.hubunganKekerabatanKeluarga = hubunganKekerabatanOptions[i]
                            }) {
                                Text(hubunganKekerabatanOptions[i])
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
            
            LabelTextField(value: $registerData.namaKeluarga, label: "Name".localized(language), placeHolder: "Name".localized(language)) { (change) in
                
            } onCommit: {
                
            }
            .onReceive(Just(registerData.namaKeluarga)) { newValue in
                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                if filtered != newValue {
                    self.registerData.namaKeluarga = filtered
                }
            }
            
            Group {
                
                Text("Address".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    MultilineTextField("Address".localized(language), text: $registerData.alamatKeluarga, onCommit: {
                    })
                    .font(Font.system(size: 14))
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onReceive(Just(registerData.alamatKeluarga)) { newValue in
                        let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                        if filtered != newValue {
                            self.registerData.alamatKeluarga = filtered
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
            
            // Label Province
            VStack(alignment: .leading) {
                Text("Province".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Province".localized(language), text: $registerData.provinsiKeluarga)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allProvince.count, id: \.self) { i in
                            Button(action: {
                                registerData.provinsiKeluarga = self.allProvince[i].name
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
                    
                    TextField("City".localized(language), text: $registerData.kotaKeluarga)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allRegency.count, id: \.self) { i in
                            Button(action: {
                                registerData.kotaKeluarga = self.allRegency[i].name
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
                    
                    TextField("District".localized(language), text: $registerData.kelurahanKeluarga)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allDistrict.count, id: \.self) { i in
                            Button(action: {
                                registerData.kelurahanKeluarga = self.allDistrict[i].name
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
                    
                    TextField("Sub-district".localized(language), text: $registerData.kecamatanKeluarga)
                        .font(Font.system(size: 14))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<self.allVillage.count, id: \.self) { i in
                            Button(action: {
                                registerData.kecamatanKeluarga = self.allVillage[i].name
                                registerData.kodePosKeluarga = self.allVillage[i].postalCode ?? ""
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
            
            VStack(alignment: .leading) {
                
                Text("Postal code".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Postal code".localized(language), text: $kodePos) {change in
                    } onCommit: {
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
            
            Group {
                
                Text("Phone number".localized(language))
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
                    
                    TextField("Phone number".localized(language), text: $noTelepon) {change in
                    } onCommit: {
                        self.registerData.noTlpKeluarga = self.noTelepon
                    }
                    .onReceive(Just(noTelepon)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.noTelepon = filtered
                        }
                    }
                    .onReceive(noTelepon.publisher.collect()) {
                        if String($0).hasPrefix("0") {
                            self.noTelepon = String(String($0).substring(with: 1..<String($0).count).prefix(12))
                        } else {
                            self.noTelepon = String($0.prefix(12))
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
            
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    
    func createBottomFloater() -> some View {
        VStack {
            HStack {
                Text("Address".localized(language))
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
        
        self.addressVM.getAddressSugestionResult(addressInput: keyword ?? registerData.alamatKeluarga) { success in
            if success {
                self.isLoading = self.addressVM.isLoading
                self.addressSugestionResult = self.addressVM.addressResult
                self.showingModal = true
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
                    registerData.alamatKeluarga = self.addressSugestion[0].street
                    registerData.provinsiKeluarga = self.addressSugestion[0].province
                    registerData.kotaKeluarga = self.addressSugestion[0].city
                    registerData.kodePosKeluarga = self.addressSugestion[0].postalCode
                    self.kodePos = self.addressSugestion[0].postalCode
                    registerData.kecamatanKeluarga = self.addressSugestion[0].kelurahan
                    registerData.kelurahanKeluarga = self.addressSugestion[0].kecamatan
                }
                self.getAllProvince()
                self.showingModal = false
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

struct KeluargaTerdekat_Previews: PreviewProvider {
    static var previews: some View {
        KeluargaTerdekat().environmentObject(RegistrasiModel())
    }
}
