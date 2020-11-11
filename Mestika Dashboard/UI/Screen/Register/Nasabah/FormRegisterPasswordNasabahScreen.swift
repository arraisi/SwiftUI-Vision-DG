//
//  FormRegisterPasswordNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct FormRegisterPasswordNasabahScreen: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var password: String = ""
    @State var confirmationPassword: String = ""
    
    @State private var securedPassword: Bool = true
    @State private var securedConfirmation: Bool = true
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var disableForm: Bool {
        password != confirmationPassword || password.count < 6
    }
    
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
            
            ScrollView {
                VStack {
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
                            // Sub title
                            Text("Masukan Password Aplikasi Digital Banking")
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundColor(Color(hex: "#232175"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("Password ini digunakan saat anda masuk kedalam Aplikasi Mobile Banking Mestika Bank")
                                .font(.custom("Montserrat-Regular", size: 8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 3)
                                .padding(.bottom, 20)
                            
                            // Forms input
                            ZStack {
                                VStack(alignment: .leading) {
                                    if (securedPassword) {
                                        ZStack {
                                            HStack (spacing: 0) {
                                                SecureField("Masukan Password", text: $password)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .padding()
                                                    .frame(width: 200, height: 50)
                                                    .foregroundColor(Color(hex: "#232175"))
                                                
                                                Button(action: {
                                                    self.securedPassword.toggle()
                                                }) {
                                                    Text("show")
                                                        .font(.custom("Montserrat-Light", size: 10))
                                                        .frame(width: 80, height: 50)
                                                        .cornerRadius(10)
                                                        .foregroundColor(Color(hex: "#3756DF"))
                                                }
                                            }.padding(.leading, 15)
                                        }
                                    } else {
                                        ZStack {
                                            HStack (spacing: 0) {
                                                TextField("Masukan Password", text: $password, onEditingChanged: { changed in
                                                    print("\($password)")
                                                    
                                                    self.registerData.password = password
                                                })
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .padding()
                                                .frame(width: 200, height: 50)
                                                .foregroundColor(Color(hex: "#232175"))
                                                
                                                Button(action: {
                                                    self.securedPassword.toggle()
                                                }) {
                                                    Text("show")
                                                        .font(.custom("Montserrat-Light", size: 10))
                                                        .frame(width: 80, height: 50)
                                                        .cornerRadius(10)
                                                        .foregroundColor(Color(hex: "#3756DF"))
                                                }
                                            }
                                        }.padding(.leading, 15)
                                    }
                                    
                                    Divider()
                                        .padding(.horizontal, 15)
                                    
                                    if (securedConfirmation) {
                                        ZStack {
                                            HStack (spacing: 0) {
                                                SecureField("Konfirmasi Password", text: $confirmationPassword)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .padding()
                                                    .frame(width: 200, height: 50)
                                                    .foregroundColor(Color(hex: "#232175"))
                                                
                                                Button(action: {
                                                    self.securedConfirmation.toggle()
                                                }) {
                                                    Text("show")
                                                        .font(.custom("Montserrat-Light", size: 10))
                                                        .frame(width: 80, height: 50)
                                                        .cornerRadius(10)
                                                        .foregroundColor(Color(hex: "#3756DF"))
                                                }
                                            }
                                        }.padding(.leading, 15)
                                    } else {
                                        ZStack {
                                            HStack (spacing: 0) {
                                                TextField("Konfirmasi Password", text: $confirmationPassword)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .padding()
                                                    .frame(width: 200, height: 50)
                                                    .foregroundColor(Color(hex: "#232175"))
                                                
                                                Button(action: {
                                                    self.securedConfirmation.toggle()
                                                }) {
                                                    Text("show")
                                                        .font(.custom("Montserrat-Light", size: 10))
                                                        .frame(width: 80, height: 50)
                                                        .cornerRadius(10)
                                                        .foregroundColor(Color(hex: "#3756DF"))
                                                }
                                            }
                                        }.padding(.leading, 15)
                                    }
                                }
                                    .padding(.vertical, 10)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 100)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                            
                            NavigationLink(destination: FormRegisterPinNasabahScreen().environmentObject(registerData), label:{
                                
                                Text("Berikutnya")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                
                            })
                            .frame(height: 50)
                            .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 25)
                            .disabled(disableForm)
                            
                        }
                        .background(LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(25.0)
                        .shadow(color: Color(hex: "#D6DAF0"), radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.top, 25)
                        
                    }
                    .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
                    .padding(.bottom, 25)
                }
                .KeyboardAwarePadding()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct FormRegisterPasswordNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormRegisterPasswordNasabahScreen().environmentObject(RegistrasiModel())
    }
}
