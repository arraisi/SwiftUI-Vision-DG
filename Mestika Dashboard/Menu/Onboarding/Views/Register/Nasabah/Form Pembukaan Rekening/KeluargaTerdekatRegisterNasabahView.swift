//
//  FormDataKeluargaTerdekatNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct KeluargaTerdekatRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var selectionID : Int = 0
    @State var location : String = ""
    @State var showingModal = false
    @State var noTelepon: String = ""
    @State var kodePos : String = ""
    @State var nextViewActive: Bool = false
    
    let hubunganKekerabatanOptions = ["Ayah", "Ibu", "Kaka", "Adik", "Saudara", "Teman"]
    
    let cities:[Address] = [
        .init(city: "Jakarta Selatan", kodePos: "14012", kecamatan: "Jakarta Selatan", kelurahan: "Selatan"),
        .init(city: "Jakarta Barat", kodePos: "14012", kecamatan: "Jakarta Barat", kelurahan: "Barat"),
        .init(city: "Jakarta Timur", kodePos: "14012", kecamatan: "Jakarta Timur", kelurahan: "Timur"),
        .init(city: "Jakarta Utara", kodePos: "14012", kecamatan: "Jakarta Utara", kelurahan: "Utara")
    ]
    
    
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
                                        
                                        NavigationLink(
                                            destination: FormVerificationAddressViewNasabahScreen().environmentObject(registerData),
                                            isActive: $nextViewActive,
                                            label: {
                                                Button(action: {
                                                    
                                                    self.registerData.kodePosKeluarga = self.kodePos
                                                    self.registerData.noTeleponPerusahaan = self.noTelepon
                                                    
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
                    
                    Button(action:{
                        showingModal.toggle()
                    }, label: {
                        Image(systemName: "location.viewfinder")
                            .font(Font.system(size: 20))
                            .foregroundColor(Color(hex: "#707070"))
                    })
                    
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            
            //            LabelTextField(value: $registerData.kodePosKeluarga, label: "Kode Pos", placeHolder: "Kode Pos") { (change) in
            //
            //            } onCommit: {
            //
            //            }
            
            VStack(alignment: .leading) {
                
                Text("Kode Pos")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Kode Pos", text: $kodePos) {change in
                    } onCommit: {
                        self.registerData.kodePosKeluarga = self.kodePos
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
            
            List(0...cities.count-1, id: \.self) {index in
                
                HStack {
                    Text(cities[index].city)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(cities[index])
                    registerData.alamatKeluarga = cities[index].city
                    registerData.kodePosKeluarga = cities[index].kodePos
                    self.kodePos = cities[index].kodePos
                    registerData.kecamatanKeluarga = cities[index].kecamatan
                    registerData.kelurahanKeluarga = cities[index].kelurahan
                    
                    //                    registerData.alamatKeluarga = alamatKeluarga
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
}

struct FormDataKeluargaTerdekatNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        KeluargaTerdekatRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
