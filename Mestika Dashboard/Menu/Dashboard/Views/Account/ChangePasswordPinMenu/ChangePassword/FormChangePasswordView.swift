//
//  FormChangePasswordView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI

struct FormChangePasswordView: View {
    
    @State private var oldPasswordCtrl = ""
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showOldPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showModal: Bool = false
    @State private var isPasswordChanged: Bool = false
    
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
            
            VStack {
                AppBarLogo(light: true) {}
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        Text("Ubah Password")
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        VStack(alignment: .leading) {
                            Text("Silahkan masukkan password lama dan baru Anda")
                                .font(.custom("Montserrat-Regular", size: 14))
                                .foregroundColor(Color(hex: "#002251"))
                                .padding(.top, 5)
                            
                            Text("Password Lama")
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .padding(.top, 5)
                            
                            HStack {
                                if (showOldPassword) {
                                    TextField("Input Password lama Anda", text: self.$oldPasswordCtrl)
                                } else {
                                    SecureField("Input Password lama Anda", text: self.$oldPasswordCtrl)
                                }
                                
                                Button(action: {
                                    self.showOldPassword.toggle()
                                }, label: {
                                    Image(systemName: showOldPassword ? "eye.fill" : "eye.slash")
                                        .foregroundColor(Color(hex: "#3756DF"))
                                })
                            }
                            .frame(height: 25)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10)
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            
                            Text("Password Baru")
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                            
                            VStack {
                                HStack {
                                    if (showPassword) {
                                        TextField("Input Password baru Anda", text: self.$passwordCtrl)
                                    } else {
                                        SecureField("Input Password baru Anda", text: self.$passwordCtrl)
                                    }
                                    
                                    Button(action: {
                                        self.showPassword.toggle()
                                    }, label: {
                                        Image(systemName: showPassword ? "eye.fill" : "eye.slash")
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    })
                                }
                                .frame(height: 25)
                                .padding(.vertical, 10)
                                
                                Divider()
                                
                                HStack {
                                    if (showConfirmPassword) {
                                        TextField("Input Ulang Password baru Anda", text: self.$confirmPasswordCtrl)
                                    } else {
                                        SecureField("Input Ulang Password baru Anda", text: self.$confirmPasswordCtrl)
                                    }
                                    
                                    Button(action: {
                                        self.showConfirmPassword.toggle()
                                    }, label: {
                                        Image(systemName: showConfirmPassword ? "eye.fill" : "eye.slash")
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    })
                                }
                                .frame(height: 25)
                                .padding(.vertical, 10)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            self.showModal.toggle()
                        }, label: {
                            Text("Simpan Password Baru")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            
                        })
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                    .padding()
                    
                }
            }
            
            if self.showModal {
                ModalOverlay(tapAction: { withAnimation { self.showModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
        .popup(isPresented: $showModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            ZStack {
                if isPasswordChanged {
                    SuccessChangePasswordModal()
                } else {
                    FailedChangePasswordModal()
                }
            }
        }
    }
    // MARK: POPUP SUCCSESS CHANGE PASSWORD
    func SuccessChangePasswordModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_check")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("PASSWORD APLIKASI YANG BARU TELAH BERHASIL DISIMPAN")
                .font(.custom("Montserrat-ExtraBold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.showModal = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: POPUP FAILED CHANGE PASSWORD
    func FailedChangePasswordModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_attention")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Password not Changed")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
            
            Button(action: {
                self.showModal = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct FormChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangePasswordView()
    }
}
