//
//  KeluargaTerdekat.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 12/10/20.
//

import SwiftUI

struct KeluargaTerdekat: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                            Text("DATA PEMBUKAAN REKENING")
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
                                        Text("Data Keluarga Terdekat Anda")
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
                                                        Text("Berikutnya")
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
                                                destination: VerificationRegisterDataView().environmentObject(registerData),
                                                isActive: $verificationViewActive,
                                                label: {
                                                    Button(action: {
                                                        
                                                        self.registerData.kodePosKeluarga = self.kodePos
                                                        self.registerData.noTlpKeluarga = self.noTelepon
                                                        
                                                        self.verificationViewActive = true
                                                        
                                                    }, label: {
                                                        Text("Simpan")
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
            self.kodePos = self.registerData.kodePosKeluarga
            self.noTelepon = self.registerData.noTlpKeluarga
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("Oke"))
            )
        }
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
                
                Text("Hubungan Kekerabatan")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                //                TextFieldWithPickerAsInput(data: ["Ayah", "Ibu", "Kaka", "Adik", "Saudara", "Teman"], placeholder: "Hubungan kekerabatan", selectionIndex: $selectionID, text: $registerData.hubunganKekerabatan)
                //                    .frame(height: 36)
                //                    .font(Font.system(size: 14))
                //                    .padding(.horizontal)
                //                    .background(Color.gray.opacity(0.1))
                //                    .cornerRadius(10)
                
                HStack {
                    TextField("Hubungan Kekerabatan", text: $registerData.hubunganKekerabatanKeluarga)
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
                                    .font(.custom("Montserrat-Regular", size: 10))
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
            
            LabelTextField(value: $registerData.namaKeluarga, label: "Nama", placeHolder: "Nama") { (change) in
                
            } onCommit: {
                
            }
            
            Group {
                
                Text("Alamat")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Alamat", text: $registerData.alamatKeluarga) { changed in
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 36)
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
            
            VStack(alignment: .leading) {
                
                Text("Kode Pos")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Kode Pos", text: $kodePos) {change in
                    } onCommit: {
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
            
            LabelTextField(value: $registerData.kecamatanKeluarga, label: "Kecamatan", placeHolder: "Kecamatan") { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $registerData.kelurahanKeluarga, label: "Kelurahan", placeHolder: "Kelurahan") { (change) in
                
            } onCommit: {
                
            }
            
            Group {
                
                Text("No. Telepon")
                    .font(Font.system(size: 10))
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
                    
                    TextField("No. Telepon", text: $noTelepon) {change in
                    } onCommit: {
                        self.registerData.noTlpKeluarga = self.noTelepon
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
            
            List(addressSugestionResult, id: \.formatted_address) { data in
                
                HStack {
                    Text(data.formatted_address)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    searchAddress(data: data.formatted_address)
                    self.showingModal.toggle()
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
    
    // MARK: - SEARCH LOCATION
    @ObservedObject var addressVM = AddressSummaryViewModel()
    func searchAddress() {
        self.isLoading = true
        
        self.addressVM.getAddressSugestionResult(addressInput: registerData.alamatKeluarga) { success in
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
                print(self.addressSugestion[0].postalCode)
                registerData.alamatKeluarga = self.addressSugestion[0].formatted_address
                registerData.kodePosKeluarga = self.addressSugestion[0].postalCode
//                self.kodePos = "12345"
                registerData.kecamatanKeluarga = self.addressSugestion[0].kecamatan
                registerData.kelurahanKeluarga = self.addressSugestion[0].kelurahan
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
    
}

struct KeluargaTerdekat_Previews: PreviewProvider {
    static var previews: some View {
        KeluargaTerdekat().environmentObject(RegistrasiModel())
    }
}
