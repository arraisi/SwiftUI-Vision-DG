//
//  CompletionDataView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 23/11/20.
//

import SwiftUI
import NavigationStack

struct FormCompletionKartuATMView: View {
    
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
    
    @State private var nama_local = UserDefaults.standard.string(forKey: "nama_local")
    @State private var is_video_call = UserDefaults.standard.string(forKey: "register_nasabah_video_call")
    @State private var is_register_nasabah = UserDefaults.standard.string(forKey: "register_nasabah")
    
    @State var addressOptionId = 1
    
    @State private var isShowAlert: Bool = false
    
    @State var messageResponse: String = ""
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    //Dummy data
    
    @State var addressOptions: [MasterModel] = [
        MasterModel(id: 1, name: NSLocalizedString("Alamat Sesuai KTP", comment: "")),
        MasterModel(id: 2, name: NSLocalizedString("Alamat Surat Menyurat", comment: "")),
        MasterModel(id: 3, name: NSLocalizedString("Alamat Perusahaan", comment: "")),
        MasterModel(id: 4, name: NSLocalizedString("Alamat Lainnya", comment: "")),
    ]
    
    @State var addressOptionsNonPekerja: [MasterModel] = [
        MasterModel(id: 1, name: NSLocalizedString("Alamat Sesuai KTP", comment: "")),
        MasterModel(id: 2, name: NSLocalizedString("Alamat Surat Menyurat", comment: "")),
        MasterModel(id: 4, name: NSLocalizedString("Alamat Lainnya", comment: "")),
    ]
    
    let cities:[Address] = [
        .init(city: "Jakarta Selatan", kodePos: "14012", kecamatan: "Jakarta Selatan", kelurahan: "Selatan"),
        .init(city: "Jakarta Barat", kodePos: "14012", kecamatan: "Jakarta Barat", kelurahan: "Barat"),
        .init(city: "Jakarta Timur", kodePos: "14012", kecamatan: "Jakarta Timur", kelurahan: "Timur"),
        .init(city: "Jakarta Utara", kodePos: "14012", kecamatan: "Jakarta Utara", kelurahan: "Utara")
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
                        Text(NSLocalizedString("LENGKAPI DATA", comment: ""))
                            .multilineTextAlignment(.center)
                            .font(.custom("Montserrat-Bold", size: 26))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 30, leading: 15, bottom: 0, trailing: 15))
                        
                        nameCard
                        addressCard
//                        referalCodeCard
                        
                        Button(action: {
                            self.postData()
                            self.atmData.atmAddresspostalCodeInput = self.kodePos
                        }, label: {
                            Text(NSLocalizedString("Submit Data", comment: ""))
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
                        .padding(.bottom, 30)
                    }
                    .padding(.bottom, 35)
                }
            }
            
            NavigationLink(destination: FormDetailKartuATMView().environmentObject(atmData).environmentObject(registerData), isActive: $goToSuccessPage){
                EmptyView()
            }
            
            if self.showingAddressModal || self.showingSuggestionNameModal {
                ModalOverlay(tapAction: { withAnimation {
                    self.showingAddressModal = false
                } })
            }
        }
        .edgesIgnoringSafeArea(.top)
        //        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        //        .navigationBarBackButtonHidden(true)
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
        .onAppear(){
//            registerData.namaLengkapFromNik = nama_local!
            atmData.atmName = registerData.namaLengkapFromNik
            fetchAddressOption()
            
            
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("Oke"))
            )
        }
    }
    
    var nameCard: some View {
        ZStack {
            VStack {
                Text(NSLocalizedString("Nama Pada Kartu ATM", comment: ""))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text(NSLocalizedString("Nama ini akan dicetak pada kartu ATM baru Anda", comment: ""))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat", size: 10))
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
                            Text(NSLocalizedString("Masukkan Nama", comment: ""))
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
            Text(NSLocalizedString("Alamat Pengiriman", comment: ""))
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
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField(NSLocalizedString("Alamat", comment: ""), text: $atmData.atmAddressInput) { changed in
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                    .disabled(addressOptionId != 4)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    if addressOptionId == 4 {
                        Button(action:{
                            searchAddress()
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .font(Font.system(size: 20))
                                .foregroundColor(Color(hex: "#707070"))
                        })
                    }
                }
                
            }
            
            LabelTextField(value: $atmData.atmAddressrtRwInput, label: "", placeHolder: "RT/RW", disabled:addressOptionId != 4 ) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddresskelurahanInput, label: "", placeHolder: NSLocalizedString("Kelurahan", comment: ""), disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddresskecamatanInput, label: "", placeHolder: NSLocalizedString("Kecamatan", comment: ""), disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            HStack {
                TextField("Kode Pos", text: $kodePos) {change in
                } onCommit: {
                    self.atmData.atmAddresspostalCodeInput = self.kodePos
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
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Alamat", text: $registerData.alamatPerusahaan) { changed in
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                    .disabled(true)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
            }
            
            LabelTextField(value: $registerData.rtrw, label: "", placeHolder: "RT/RW", disabled: true ) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $registerData.kelurahan, label: "", placeHolder: "Kelurahan", disabled: true) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $registerData.kecamatan, label: "", placeHolder: "Kecamatan", disabled: true
            ) { (change) in
                
            } onCommit: {
                
            }
            
            HStack {
                TextField("Kode Pos", text: $registerData.kodePos) {change in
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
                Text(NSLocalizedString("Masukkan Kode Referal", comment: ""))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text(NSLocalizedString("Dari mana Anda tahu informasi Digital Banking Bank mestika", comment: ""))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat", size: 10))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Group {
                    
                    Text("")
                        .font(Font.system(size: 10))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField(NSLocalizedString("Masukkan kode referal", comment: ""), text: $atmData.atmAddresspostalReferral) { changed in
                            
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
                Text(NSLocalizedString("Nama Kartu", comment: ""))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                TextField(NSLocalizedString("Alamat Perusahaan", comment: ""), text: $location)
                    .font(Font.system(size: 14))
                    .frame(height: 0)
                    .disabled(true)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
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
                Text(NSLocalizedString("Alamat", comment: ""))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField(NSLocalizedString("Alamat Perusahaan", comment: ""), text: $location)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                
                Button(action:{
                    print("find location")
                }, label: {
                    Image(systemName: "location.viewfinder")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            
            List(addressSugestionResult, id: \.formatted_address) {data in
                
                HStack {
                    Text(data.formatted_address)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    searchAddress(data: data.formatted_address)
                    self.showingAddressModal.toggle()
                })
                
            }
            .background(Color.white)
            .padding(.vertical)
            .frame(height: 150)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func isValid() -> Bool {
        if addressOptionId == 4 {
            return atmData.atmName.trimmingCharacters(in: .whitespaces).count > 0 && atmData.atmAddressInput.trimmingCharacters(in: .whitespaces).count > 0 && atmData.atmAddresskecamatanInput.trimmingCharacters(in: .whitespaces).count > 0 && atmData.atmAddresskelurahanInput.trimmingCharacters(in: .whitespaces).count > 0 && (atmData.atmAddresspostalCodeInput.trimmingCharacters(in: .whitespaces).count > 0 || self.kodePos.trimmingCharacters(in: .whitespaces).count > 0)
        } else {
            return !atmData.atmName.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    func fetchAddressOption() {
        switch addressOptionId {
        case 1: /// Sesuai KTP
            atmData.atmAddressInput = registerData.alamatKtpFromNik
            atmData.atmAddresspostalCodeInput = registerData.kodePos
            atmData.atmAddresskecamatanInput = registerData.kecamatanFromNik
            atmData.atmAddresskelurahanInput = registerData.kelurahanFromNik
            atmData.atmAddressrtRwInput = "\(registerData.rtFromNik)/\(registerData.rwFromNik)"
        case 2: /// Surat Menyurat
            atmData.atmAddressInput = registerData.alamatKeluarga
            atmData.atmAddresspostalCodeInput = registerData.kodePosKeluarga
            atmData.atmAddresskecamatanInput = registerData.kecamatanKeluarga
            atmData.atmAddresskelurahanInput = registerData.kelurahanKeluarga
            atmData.atmAddressrtRwInput = ""
        case 3: /// Perusahaan
            atmData.atmAddressInput = registerData.alamatPerusahaan
            atmData.atmAddresspostalCodeInput = registerData.kodePos
            atmData.atmAddresskecamatanInput = registerData.kecamatan
            atmData.atmAddresskelurahanInput = registerData.kelurahan
            atmData.atmAddressrtRwInput = registerData.rtrw
        //            currentAddress = Address(address: currentUser.companyAddress, city: currentUser.companyKecamatan, kodePos: currentUser.companyPostalCode, kecamatan: currentUser.companyKecamatan, kelurahan: currentUser.companyKelurahan, rtRw: "")
        default:
            self.kodePos = ""
            atmData.atmAddressInput = ""
            atmData.atmAddresspostalCodeInput = ""
            atmData.atmAddresskecamatanInput = ""
            atmData.atmAddresskelurahanInput = ""
            atmData.atmAddressrtRwInput = ""
        //            currentAddress = Address()
        }
    }
    
    func postData() {
        ///MARK : Complete data
        let isVideoCall = UserDefaults.standard.string(forKey: "register_nasabah_video_call") ?? ""
        
        atmData.nik = registerData.nik
        atmData.isNasabahMestika = is_register_nasabah == "true" ? true : false
        atmData.isVcall = is_video_call == "true" ? true : false
        
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
    func searchAddress() {
        self.isLoading = true
        
        self.addressVM.getAddressSugestionResult(addressInput: atmData.atmAddressInput) { success in
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
                atmData.atmAddressInput = self.addressSugestion[0].formatted_address
                atmData.atmAddresspostalCodeInput = self.addressSugestion[0].postalCode
//                self.kodePos = self.addressSugestion[0].postalCode
                atmData.atmAddresskecamatanInput = self.addressSugestion[0].kecamatan
                atmData.atmAddresskelurahanInput = self.addressSugestion[0].kelurahan
                atmData.atmAddressrtRwInput = self.addressSugestion[0].rt
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
}

struct FormCompletionDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormCompletionKartuATMView().environmentObject(AddProductATM()).environmentObject(RegistrasiModel())
    }
}
