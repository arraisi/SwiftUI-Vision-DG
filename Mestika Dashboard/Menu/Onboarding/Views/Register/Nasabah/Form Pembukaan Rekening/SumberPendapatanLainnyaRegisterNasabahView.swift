//
//  FormSumberPendapatanLainnyaScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct SumberPendapatanLainnyaRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    let sumberPendapatanLainnya: [MasterModel] = load("sumberPendapatanLainnya.json")
    
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
                                        Text("Apakah Anda Memiliki Sumber Pendapatan Lainnya")
                                            .font(.custom("Montserrat-SemiBold", size: 18))
                                            .foregroundColor(Color(hex: "#232175"))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 40)
                                            .padding(.vertical, 30)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        // Forms input
                                        ZStack {
                                            
                                            RadioButtonGroup(
                                                items: sumberPendapatanLainnya,
                                                selectedId: $registerData.sumberPendapatanLainnyaId) { selected in
                                                print("Selected is: \(selected)")
                                                
                                                if let i = sumberPendapatanLainnya.firstIndex(where: { $0.id == selected }) {
                                                    print(sumberPendapatanLainnya[i])
                                                    registerData.sumberPendapatanLainnya = sumberPendapatanLainnya[i].name
                                                }
                                                
                                                print(registerData.sumberPendapatanLainnya)
                                            }
                                            .padding()
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 100)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                        
                                        // Button
        //                                NavigationLink(destination: FormVerificationRegisterDataNasabahScreen().environmentObject(registerData), label:{
                                        NavigationLink(destination: KeluargaTerdekatRegisterNasabahView().environmentObject(registerData), label:{
                                            
                                            Text("Berikutnya")
                                                .foregroundColor(.white)
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .frame(maxWidth: .infinity, maxHeight: 40)
                                            
                                        })
                                        .disabled(registerData.sumberPendapatanLainnyaId == 0)
                                        .frame(height: 50)
                                        .background(registerData.sumberPendapatanLainnyaId == 0 ? Color(.lightGray) : Color(hex: "#2334D0"))
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
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct SumberPendapatanLainnyaRegisterNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        SumberPendapatanLainnyaRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
