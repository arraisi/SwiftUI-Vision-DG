//
//  FormIndustriTempatBekerjaView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 18/11/20.
//

import SwiftUI

struct FormIndustriTempatBekerjaView: View {
    /*
     Registrasi Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var editMode: EditMode = .inactive
    
    let industriTempatBekerja: [MasterModel] = load("industriTempatBekerja.json")
    
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
                
                ScrollView(.vertical) {
                    
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
                            
                        }
                        
                        VStack {
                            
                            Spacer()
                            
                            // Sub title
                            Text("Industri Tempat Bekerja")
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundColor(Color(hex: "#232175"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 30)
                            
                            // Forms input
                            ZStack {
                                
                                RadioButtonGroup(
                                    items: industriTempatBekerja,
                                    selectedId: $registerData.industriTempatBekerjaId) { selected in
                                    
                                    if let i = industriTempatBekerja.firstIndex(where: { $0.id == selected }) {
                                        print(industriTempatBekerja[i])
                                        registerData.industriTempatBekerja = industriTempatBekerja[i].name
                                    }
                                    
                                }
                                .padding()
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 100)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                            
                            // Button
                            if (editMode == .inactive) {
                                NavigationLink(destination: InformasiPerusahaanView().environmentObject(registerData)) {
                                    
                                    Text("Berikutnya")
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                    
                                }
                                .disabled(registerData.industriTempatBekerjaId == 0)
                                .frame(height: 50)
                                .background(registerData.industriTempatBekerjaId == 0 ? Color(.lightGray) : Color(hex: "#2334D0"))
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 25)
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
                    .padding(.bottom, 0.1)
                    .padding(.bottom, 25)
                    
                }
                .KeyboardAwarePadding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct FormIndustriTempatBekerjaView_Previews: PreviewProvider {
    static var previews: some View {
        FormIndustriTempatBekerjaView()
    }
}
