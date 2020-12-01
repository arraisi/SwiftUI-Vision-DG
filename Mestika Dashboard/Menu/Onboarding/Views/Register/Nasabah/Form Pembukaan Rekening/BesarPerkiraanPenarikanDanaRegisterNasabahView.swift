//
//  FormBesarPerkiraanPenarikanDanaNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct BesarPerkiraanPenarikanDanaRegisterNasabahView: View {
    /*
     Registrasi Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    
    // Routing variables
    @State var editMode: EditMode = .inactive
    
    // View variables
    let besarPerkiraanPenarikan: [MasterModel] = load("besarPerkiraanPenarikan.json")
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 350)
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
                                .padding(.vertical, 30)
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
                                        Text("Berapa Besar Perkiraan Penarikan Dana Anda Setiap Bulannya")
                                            .font(.custom("Montserrat-SemiBold", size: 18))
                                            .foregroundColor(Color(hex: "#232175"))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 40)
                                            .padding(.vertical, 30)
                                        
                                        // Forms input
                                        ZStack {
                                            
                                            RadioButtonGroup(
                                                items: besarPerkiraanPenarikan,
                                                selectedId: $registerData.besarPerkiraanPenarikanId) { selected in
                                                
                                                if let i = besarPerkiraanPenarikan.firstIndex(where: { $0.id == selected }) {
                                                    print(besarPerkiraanPenarikan[i])
                                                    registerData.besarPerkiraanPenarikan = besarPerkiraanPenarikan[i].name
                                                }
                                                
                                                print("Selected is: \(registerData.besarPerkiraanPenarikan)")
                                            }
                                            .padding()
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 100)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                        
                                        // Button
                                        if (editMode == .inactive) {
                                            NavigationLink(destination: PerkiraanSetoranRegisterNasabahView().environmentObject(registerData)) {
                                                
                                                Text("Berikutnya")
                                                    .foregroundColor(.white)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                                
                                            }
                                            .disabled(registerData.besarPerkiraanPenarikanId == 0)
                                            .frame(height: 50)
                                            .background(registerData.besarPerkiraanPenarikanId == 0 ? Color(.lightGray) : Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 25)
                                        } else {
                                            NavigationLink(destination: FormVerificationRegisterDataNasabahScreen().environmentObject(registerData)) {
                                                
                                                Text("Simpan")
                                                    .foregroundColor(.white)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                                
                                            }
                                            .frame(height: 50)
                                            .background(Color(hex: "#2334D0"))
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
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct FormBesarPerkiraanPenarikanDanaNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        BesarPerkiraanPenarikanDanaRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
