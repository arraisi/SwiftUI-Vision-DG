//
//  FormPekerjaanNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct PekerjaanRegisterNasabahView: View {
    /*
     Registrasi Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    
    // Routing variables
    @State var editMode: EditMode = .inactive
    
    // View variables
    let pekerjaan: [MasterModel] = load("pekerjaan.json")
    @State var selection: String?
    
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
                
                ScrollView(showsIndicators: false) {
                    
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
                                        Text("Apa Pekerjaan Anda")
                                            .font(.custom("Montserrat-SemiBold", size: 18))
                                            .foregroundColor(Color(hex: "#232175"))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 40)
                                            .padding(.vertical, 30)
                                        
                                        // Forms input
                                        ZStack {
                                            
                                            RadioButtonGroup(
                                                items: pekerjaan,
                                                selectedId: $registerData.pekerjaanId) { selected in
                                                
                                                if let i = pekerjaan.firstIndex(where: { $0.id == selected }) {
                                                    print(pekerjaan[i])
                                                    registerData.pekerjaan = pekerjaan[i].name
                                                }
                                                
                                                print(registerData.pekerjaan)
                                            }
                                            .padding()
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 100)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                        
                                        // Navigation Jabatan Profesi
                                        NavigationLink(
                                            destination: JabatanProfesiRegisterNasabahView().environmentObject(registerData),
                                            tag: "jabatanProfesi",
                                            selection: $selection,
                                            label: {EmptyView()})
                                        
                                        // Navigation Sumber Penyandang Dana
                                        NavigationLink(
                                            destination: SumberPenyandangDana1RegisterNasabahView().environmentObject(registerData),
                                            tag: "sumberPenyandangDana",
                                            selection: $selection,
                                            label: {EmptyView()})
                                        
                                        // Navigation Sumber Penyandang Dana 2
                                        NavigationLink(
                                            destination: SumberPenyandandDana2RegisterNasabahView().environmentObject(registerData),
                                            tag: "sumberPenyandangDana2",
                                            selection: $selection,
                                            label: {EmptyView()})
                                        
                                        // Navigation Sumber Penyandang Dana
                                        NavigationLink(
                                            destination: InformasiPerusahaanRegisterNasabahView().environmentObject(registerData),
                                            tag: "informasiPerusahaan",
                                            selection: $selection,
                                            label: {EmptyView()})
                                        
                                        // Navigation Industri Tempat Bekerja
                                        NavigationLink(
                                            destination: IndustriTempatBekerjaRegisterNasabahView().environmentObject(registerData),
                                            tag: "industriTempatBekerja",
                                            selection: $selection,
                                            label: {EmptyView()})
                                        
                                        // Button
                                        if (editMode == .inactive) {
                                            
                                            Button(action: {
                                                print("pekerjaan id : \(registerData.pekerjaanId)")
                                                
                                                switch registerData.pekerjaanId {
                                                case 6 :
                                                    self.selection = "jabatanProfesi"
                                                case 9:
                                                    self.selection = "industriTempatBekerja"
                                                case 10:
                                                    self.selection = "sumberPenyandangDana2"
                                                case 11:
                                                    self.selection = "sumberPenyandangDana2"
                                                case 12:
                                                    self.selection = "sumberPenyandangDana2"
                                                default:
                                                    self.selection = "informasiPerusahaan"
                                                }
                                                
                                            }, label: {
                                                Text("Berikutnya")
                                                    .foregroundColor(.white)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                            })
                                            .disabled(registerData.pekerjaanId == 0)
                                            .frame(height: 50)
                                            .background(registerData.pekerjaanId == 0 ? Color(.lightGray) : Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 25)
                                            
                                        } else {
                                            NavigationLink(destination: DataVerificationRegisterNasabahView().environmentObject(registerData)) {
                                                
                                                Text("Simpan")
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                                
                                            }
                                            .frame(height: 50)
                                            .background(Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 35)
                                            .padding(.vertical, 20)
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
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct FormPekerjaanNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        PekerjaanRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
