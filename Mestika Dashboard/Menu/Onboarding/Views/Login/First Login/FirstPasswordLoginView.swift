//
//  FirstPasswordLoginView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 12/10/20.
//

import SwiftUI

struct FirstPasswordLoginView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var appState: AppState
    
    @State private var nextRoute: Bool = false
    @State var password: String = ""
    @State var confirmationPassword: String = ""
    
    @State private var securedPassword: Bool = true
    @State private var securedConfirmation: Bool = true
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
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
                
                AppBarLogo(light: false, onCancel: {})
                
                VStack {
                    Text("ENTER PASSWORD".localized(language))
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
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            bottomMessagePasswordIncorrect()
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            Text("The Application Password must be at least 8 characters long. It consists of Uppercase, Number, etc.".localized(language))
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
                                SecureField("Masukkan Password".localized(language), text: $password)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .padding()
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(Color(hex: "#232175"))
                                
                                Spacer()
                                
                                Button(action: {
                                    self.securedPassword.toggle()
                                }) {
                                    Image(systemName: "eye.slash")
                                        .font(.custom("Montserrat-Light", size: 14))
                                        .frame(width: 80, height: 50)
                                        .cornerRadius(10)
                                        .foregroundColor(Color(hex: "#3756DF"))
                                }
                            }.padding(.leading, 15)
                        }
                    } else {
                        ZStack {
                            HStack (spacing: 0) {
                                TextField("Enter Password".localized(language), text: $password, onEditingChanged: { changed in
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
                                    Image(systemName: "eye.fill")
                                        .font(.custom("Montserrat-Light", size: 14))
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
                                SecureField("Confirm Password".localized(language), text: $confirmationPassword)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .padding()
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(Color(hex: "#232175"))
                                
                                Spacer()
                                
                                Button(action: {
                                    self.securedConfirmation.toggle()
                                }) {
                                    Image(systemName: "eye.slash")
                                        .font(.custom("Montserrat-Light", size: 14))
                                        .frame(width: 80, height: 50)
                                        .cornerRadius(10)
                                        .foregroundColor(Color(hex: "#3756DF"))
                                }
                            }
                        }.padding(.leading, 15)
                    } else {
                        ZStack {
                            HStack (spacing: 0) {
                                TextField("Confirm Password".localized(language), text: $confirmationPassword)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .padding()
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(Color(hex: "#232175"))
                                
                                Spacer()
                                
                                Button(action: {
                                    self.securedConfirmation.toggle()
                                }) {
                                    Image(systemName: "eye.fill")
                                        .font(.custom("Montserrat-Light", size: 14))
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
                    Text("SAVE LOGIN DATA".localized(language))
                        .foregroundColor(disableForm ? .white : Color(hex: "#232175"))
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                })
                .background(disableForm ? Color.gray.opacity(0.3) : Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .disabled(disableForm)
            
            NavigationLink(
                destination: LoginScreen(isNewDeviceLogin: .constant(false)),
                isActive: self.$nextRoute,
                label: {}
            )
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    func checkPassword() {
        
    }
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func bottomMessagePasswordIncorrect() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password is not the same, please retype")
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.appState.moveToWelcomeView = true
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
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
        NavigationView {
            FirstPasswordLoginView()
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
#endif
