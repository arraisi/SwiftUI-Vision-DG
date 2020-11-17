//
//  FormPerkerjaan.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 01/10/20.
//

import SwiftUI

struct PerkerjaanView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var editMode: EditMode = .inactive
    
    let pekerjaan: [MasterModel] = load("pekerjaan.json")
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color(hex: "#232175")
            
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 45 / 100 * UIScreen.main.bounds.height)
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                ScrollView {
                    
                    // Title
                    Text("DATA PEMBUKAAN REKENING")
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
                        .padding(.vertical, 45)
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
                                
                                // Button
                                if (editMode == .inactive) {
                                    if registerData.pekerjaanId == 9 {
                                        NavigationLink(destination: SumberPenyandangDanaView().environmentObject(registerData)) {
                                            
                                            Text("Berikutnya")
                                                .foregroundColor(.white)
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .frame(maxWidth: .infinity, maxHeight: 40)
                                            
                                        }
                                        .disabled(registerData.pekerjaanId == 0)
                                        .frame(height: 50)
                                        .background(registerData.pekerjaanId == 0 ? Color(.lightGray) : Color(hex: "#2334D0"))
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 25)
                                    } else {
                                        NavigationLink(destination: InformasiPerusahaanView().environmentObject(registerData)) {
                                            
                                            Text("Berikutnya")
                                                .foregroundColor(.white)
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .frame(maxWidth: .infinity, maxHeight: 40)
                                            
                                        }
                                        .disabled(registerData.pekerjaanId == 0)
                                        .frame(height: 50)
                                        .background(Color(hex: "#2334D0"))
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 25)
                                    }
                                    
                                } else {
                                    NavigationLink(destination: VerificationRegisterDataView().environmentObject(registerData)) {
                                        
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
                .padding(.bottom, 0.1)
                .KeyboardAwarePadding()
                
            }
            
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct FormPerkerjaan_Previews: PreviewProvider {
    static var previews: some View {
        PerkerjaanView().environmentObject(RegistrasiModel())
    }
}
