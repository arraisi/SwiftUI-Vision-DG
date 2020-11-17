//
//  FirstPasswordLoginView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 12/10/20.
//

import SwiftUI

struct FirstPasswordLoginView: View {
    
    @Binding var rootIsActive : Bool
    @State private var nextRoute: Bool = false
    @State var password: String = ""
    @State var confirmationPassword: String = ""
    
    @State private var securedPassword: Bool = true
    @State private var securedConfirmation: Bool = true
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    /* Disabled Form */
    var disableForm: Bool {
        password.count < 8 || confirmationPassword.count < 8
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                VStack {
                    Text("MASUKKAN PASSWORD")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 100)
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            bottomMessagePasswordIncorrect()
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            Text("Password Aplikasi harus berjumlah minimal 8 karakter huruf. Terdiri dari Uppercase, Number, etc.")
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
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
                                
                                Spacer()
                                
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
                                })
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .padding()
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color(hex: "#232175"))
                                
                                Spacer()
                                
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
                                
                                Spacer()
                                
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
                                
                                Spacer()
                                
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
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
            
            Button(
                action: {
                    checkPassword()
                },
                label: {
                    Text("SIMPAN DATA LOGIN")
                        .foregroundColor(disableForm ? .white : Color(hex: "#232175"))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                })
                .background(disableForm ? Color.gray.opacity(0.3) : Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .disabled(disableForm)
            
            NavigationLink(
                destination: LoginScreen(),
                isActive: self.$nextRoute,
                label: {}
            )
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    func checkPassword() {
        if (deviceId == user.last?.deviceId && password == user.last?.password) {
            
            UserDefaults.standard.set("false", forKey: "isFirstLogin")
            print("DATA READY")
            nextRoute = true
            
        } else {
            
            print("NO DATA")
            showingModal.toggle()
            
        }
    }
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func bottomMessagePasswordIncorrect() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password tidak sama, silahkan ketik ulang")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {}) {
                Text("Kembali")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Text("")
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#if DEBUG
struct FirstPasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPasswordLoginView(rootIsActive: .constant(false))
    }
}
#endif
