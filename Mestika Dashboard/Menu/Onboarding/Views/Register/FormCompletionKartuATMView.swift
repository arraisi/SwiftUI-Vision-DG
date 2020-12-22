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
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var location : String = ""
    @State var kodePos : String = ""
    @State var showingAddressModal = false
    @State var showingSuggestionNameModal = false
    @State var goToSuccessPage = false
    @State var isLoading = false
    
    @State private var nama_local = UserDefaults.standard.string(forKey: "nama_local")
    
    @State var addressOptionId = 1
    
//    @State var nameOnCard : String = ""
//    @State var currentAddress : Address = Address()
    
    //Dummy data
    
    let addressOptions: [MasterModel] = [
        MasterModel(id: 1, name: "Alamat Sesuai KTP"),
        MasterModel(id: 2, name: "Alamat Surat Menyurat"),
        MasterModel(id: 3, name: "Alamat Perusahaan"),
        MasterModel(id: 4, name: "Alamat Lainnya"),
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
                        Text("LENGKAPI DATA")
                            .multilineTextAlignment(.center)
                            .font(.custom("Montserrat-Bold", size: 26))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 30, leading: 15, bottom: 0, trailing: 15))
                        
                        nameCard
                        addressCard
                        referalCodeCard
                        
                        Button(action: {
                            self.postData()
                            self.atmData.atmAddresspostalCodeInput = self.kodePos
                        }, label: {
                            Text("Submit Data")
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
            registerData.namaLengkapFromNik = nama_local!
            atmData.atmName = registerData.namaLengkapFromNik
            fetchAddressOption()
        }
    }
    
    var nameCard: some View {
        ZStack {
            VStack {
                Text("Nama Pada Kartu ATM")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text("Nama ini akan dicetak pada kartu ATM baru Anda")
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
                            Text("Masukkan Nama")
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
            Text("Alamat Pengiriman")
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
            
            if addressOptionId == 4 {
                formAddress
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
                    
                    TextField("Alamat", text: $atmData.atmAddressInput) { changed in
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                    .disabled(addressOptionId != 4)
                    
                    if addressOptionId == 4 {
                        Button(action:{
                            showingAddressModal.toggle()
                        }, label: {
                            Image(systemName: "location.viewfinder")
                                .font(Font.system(size: 20))
                                .foregroundColor(Color(hex: "#707070"))
                        })
                    }
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            
            LabelTextField(value: $atmData.atmAddressrtRwInput, label: "", placeHolder: "RT/RW", disabled:addressOptionId != 4 ) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddresskelurahanInput, label: "", placeHolder: "Kelurahan", disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddresskecamatanInput, label: "", placeHolder: "Kecamatan", disabled:addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
//            LabelTextField(value: $atmData.atmAddresspostalCodeInput, label: "", placeHolder: "Kode Pos", disabled:addressOptionId != 4) { (change) in
//
//            } onCommit: {
//
//            }
            
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
    
    var referalCodeCard: some View {
        ZStack {
            VStack {
                Text("Masukkan Kode Referal")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text("Dari mana Anda tahu informasi Digital Banking Bank mestika")
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
                        
                        TextField("Masukkan kode referal", text: $atmData.atmAddresspostalReferral) { changed in
                            
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
                Text("Nama Kartu")
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                TextField("Alamat Perusahaan", text: $location)
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
                Text("Alamat")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField("Alamat Perusahaan", text: $location)
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
            
            List(0...cities.count-1, id: \.self) {index in
                
                HStack {
                    Text(cities[index].city)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(cities[index])
                    atmData.atmAddressInput = cities[index].address
                    atmData.atmAddresspostalCodeInput = cities[index].kodePos
                    self.kodePos = cities[index].kodePos
                    atmData.atmAddresskecamatanInput = cities[index].kecamatan
                    atmData.atmAddresskelurahanInput = cities[index].kelurahan
                    atmData.atmAddressrtRwInput = cities[index].rtRw
                    
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
        atmData.nik = registerData.nik
        
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
}

struct FormCompletionDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormCompletionKartuATMView().environmentObject(AddProductATM()).environmentObject(RegistrasiModel())
    }
}