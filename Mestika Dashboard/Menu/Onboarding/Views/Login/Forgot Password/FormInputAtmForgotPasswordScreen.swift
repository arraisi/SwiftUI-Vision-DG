//
//  FormInputAtmForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormInputAtmForgotPasswordScreen: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var atmNumberCtrl = ""
    @State private var pinAtmCtrl = ""
    @State private var showPassword: Bool = false
    
    @State var errorMessage: String = ""
    
    @GestureState private var dragOffset = CGSize.zero
    
    @State var showingModalError: Bool = false
    
    /* Route */
    @State var isNextRoute: Bool = false
    
    var disableForm: Bool {
        if (atmNumberCtrl.isEmpty || pinAtmCtrl.isEmpty) {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                Text("INPUT DATA ATM")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Masukkan nomor kartu ATM dan PIN ATM Anda yang sudah terdaftar")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        TextField("Masukkan nomor ATM Anda", text: self.$atmNumberCtrl)
                            .keyboardType(.numberPad)
                            .onReceive(atmNumberCtrl.publisher.collect()) {
                                self.atmNumberCtrl = String($0.prefix(16))
                            }
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding()
                
                VStack {
                    HStack {
                        if (showPassword) {
                            TextField("Masukkan PIN ATM Anda", text: self.$pinAtmCtrl)
                                .keyboardType(.numberPad)
                                .onReceive(pinAtmCtrl.publisher.collect()) {
                                    self.pinAtmCtrl = String($0.prefix(6))
                                }
                        } else {
                            SecureField("Masukkan PIN ATM Anda", text: self.$pinAtmCtrl)
                                .keyboardType(.numberPad)
                                .onReceive(pinAtmCtrl.publisher.collect()) {
                                    self.pinAtmCtrl = String($0.prefix(6))
                                }
                        }
                        
//                        Button(action: {
//                            self.showPassword.toggle()
//                        }, label: {
//                            Image(systemName: showPassword ? "eye.slash" : "eye.fill")
//                                .foregroundColor(Color(hex: "#3756DF"))
//                        })
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding(.horizontal)
                
                Spacer()
                
//                VStack {
//                    NavigationLink(destination: FormInputAtmPinForgotPasswordView(), label: {
//                        Text("AKTIVASI KARTU ATM BARU")
//                            .foregroundColor(Color(hex: "#232175"))
//                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                            .font(.system(size: 13))
//                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
//
//                    })
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .padding(.leading, 20)
//                    .padding(.trailing, 10)
//                }
//                .padding(.bottom, 10)
                
                VStack {
                    
                    Button(
                        action: {
                            setPassword()
                        },
                        label: {
                            Text("KONFIRMASI DATA")
                                .foregroundColor(disableForm ? Color.white : Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        }
                    )
                    .background(disableForm ? Color(.lightGray) : Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    .disabled(disableForm)
                    
                    NavigationLink(
                        destination: LoginScreen(isNewDeviceLogin: .constant(false)).environmentObject(registerData),
                        isActive: self.$isNextRoute) {}
                        .isDetailLink(false)
                }
                .padding(.bottom, 50)
            }
            
            if self.showingModalError {
                ModalOverlay(tapAction: { withAnimation { } })
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
        .popup(isPresented: $showingModalError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalError()
        }
    }
    
    // MARK: -Bottom modal for error
    func modalError() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text(self.errorMessage)
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showingModalError = false
            }) {
                Text("Kembali")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
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
    
    @ObservedObject private var authVM = AuthViewModel()
    func setPassword() {
        self.authVM.setPwd(
            pwd: registerData.password,
            accountNumber: atmNumberCtrl,
            nik: "",
            pinTrx: pinAtmCtrl) { success in
            if success {
                print("SUCCESS CHANGE PASSWORD")
                self.isNextRoute = true
            }
            
            if !success {
                print("NOT SUCCESS CHANGE PASSWORD")
                self.errorMessage = self.authVM.errorMessage
                self.showingModalError = true
            }
        }
    }
}

struct FormInputAtmForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputAtmForgotPasswordScreen()
    }
}
