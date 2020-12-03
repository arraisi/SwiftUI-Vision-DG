//
//  FormInformasiPerusahaanNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct BidangUsaha {
    var nama: String
}

struct InformasiPerusahaanRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var namaPerusahaan: String = ""
    @State var alamatPerusahaan: String = ""
    @State var kelurahan: String = ""
    @State var kodePos : String = ""
    @State var kecamatan : String = ""
    @State var location : String = ""
    
    @State var noTlpPerusahaan: String = ""
    @State var nextViewActive: Bool = false
    
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
    
    let cities:[Address] = [
        .init(city: "Jakarta Selatan", kodePos: "14012", kecamatan: "Jakarta Selatan", kelurahan: "Andir"),
        .init(city: "Jakarta Barat", kodePos: "14012", kecamatan: "Jakarta Barat", kelurahan: "Andir"),
        .init(city: "Jakarta Timur", kodePos: "14012", kecamatan: "Jakarta Timur", kelurahan: "Andir"),
        .init(city: "Jakarta Utara", kodePos: "14012", kecamatan: "Jakarta Utara", kelurahan: "Andir")
    ]
    
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    @State var showingModalBidang = false
    
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
                                        Text("Masukan Informasi Perusahaan")
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
                                            destination: PenghasilanKotorRegisterNasabahView().environmentObject(registerData),
                                            isActive: $nextViewActive,
                                            label: {
                                                Button(action: {
                                                    
                                                    self.registerData.noTeleponPerusahaan = self.noTlpPerusahaan
                                                    self.registerData.kodePos = self.kodePos
                                                    
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
                            .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
                            .navigationBarBackButtonHidden(true)
                            .padding(.bottom, 25)
                            
                        }
                    }
                }
                .KeyboardAwarePadding()
                
            }
            
            // Background Color When Modal Showing
            if self.showingModal || self.showingModalBidang {
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
        .popup(isPresented: $showingModalBidang, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomFloaterBidangUsaha()
        }
    }
    
    // MARK : - Check form is fill
    func isValid() -> Bool {
        if registerData.namaPerusahaan == "" {
            return true
        }
        if registerData.alamatPerusahaan == "" {
            return true
        }
        if registerData.kodePos == "" {
            return true
        }
        if registerData.kecamatan == "" {
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
            
            LabelTextField(value: $registerData.namaPerusahaan, label: "Nama Perusahaan", placeHolder: "Nama Perusahaan"){ (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .padding(.horizontal, 20)
            
            Group {
                
                Text("Alamat Perusahaan")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Alamat Perusahaan", text: $registerData.alamatPerusahaan) { changed in
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
            .padding(.horizontal, 20)
            
            //            LabelTextField(value: $registerData.kodePos, label: "Kode Pos", placeHolder: "Kode Pos") { (Bool) in
            //                print("on edit")
            //            } onCommit: {
            //                print("on commit")
            //            }
            //            .padding(.horizontal, 20)
            
            //            VStack(alignment: .leading) {
            //                Text("Kode Pos")
            //                    .font(Font.system(size: 10))
            //                    .fontWeight(.semibold)
            //                    .foregroundColor(Color(hex: "#707070"))
            //                    .multilineTextAlignment(.leading)
            //
            //                TextFieldValidation(data: self.$registerData.kodePos, title: "Kode Pos", disable: false, isValid: false, keyboardType: .numberPad) { strArr in
            //                    registerData.kodePos = ""
            //                }
            //            }
            //            .padding(.horizontal, 20)
            
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
            .padding(.horizontal, 20)
            
            LabelTextField(value: $registerData.kecamatan, label: "Kecamatan", placeHolder: "Kecamatan") { (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .padding(.horizontal, 20)
            
            LabelTextField(value: $registerData.kelurahan, label: "Kelurahan", placeHolder: "Kelurahan") { (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .padding(.horizontal, 20)
            
            Group {
                Text("Bidang Usaha")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Bidang Usaha", text: $registerData.bidangUsaha) { changed in
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                    .disabled(true)
                    
                    Button(action:{
                        showingModalBidang.toggle()
                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 20))
                            .foregroundColor(Color(hex: "#707070"))
                    })
                    
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            .padding(.horizontal, 20)
            
            Group {
                
                Text("No. Telepon Perusahaan")
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
                    
                    TextField("No. Telepon", text: $noTlpPerusahaan) {change in
                    } onCommit: {
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
                    registerData.alamatPerusahaan = cities[index].city
                    registerData.kodePos = cities[index].kodePos
                    kodePos = cities[index].kodePos
                    registerData.kecamatan = cities[index].kecamatan
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
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
        func createBottomFloaterBidangUsaha() -> some View {
            VStack {
                HStack {
                    Text("Bidang Usaha")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 19))
                        .foregroundColor(Color(hex: "#232175"))
                    Spacer()
                }
                
                HStack {
                    
                    TextField("Cari Bidang Usaha", text: $registerData.bidangUsaha)
                        .font(Font.system(size: 14))
                        .frame(height: 36)
                    
                    Button(action:{
                        print("cari bidang usaha")
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .font(Font.system(size: 20))
                            .foregroundColor(Color(hex: "#707070"))
                    })
                    
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                List(0...bidangUsaha.count-1, id: \.self) {index in
                    
                    HStack {
                        Text(bidangUsaha[index].nama)
                            .font(Font.system(size: 14))
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        registerData.bidangUsaha = bidangUsaha[index].nama
                        self.showingModalBidang.toggle()
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

struct FormInformasiPerusahaanNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        InformasiPerusahaanRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
