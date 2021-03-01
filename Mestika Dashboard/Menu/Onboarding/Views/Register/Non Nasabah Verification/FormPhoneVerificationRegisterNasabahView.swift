//
//  PhoneVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI

struct FormPhoneVerificationRegisterNasabahView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @State var showSelf: Bool = false
    @State var isInvalidInput: Bool = false
    @Binding var rootIsActive : Bool
    @Binding var root2IsActive : Bool
    
    @State var isShowModal: Bool = false
    
    /* Variable Data */
    @State var phoneNumber: String = ""
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    /* Disabled Form */
    var disableForm: Bool {
        phoneNumber.count < 10
    }
    
    // MARK: -MAIN CONTENT
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: UIScreen.main.bounds.height*0.35)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                
                VStack(alignment: .center) {
                    Text(NSLocalizedString("Phone Verification".localized(language), comment: ""))
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.top, 30)
                    
                    Text(NSLocalizedString("Please enter your Phone Number".localized(language), comment: ""))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("🇮🇩 +62 ").foregroundColor(.black)
                        
                        Divider()
                            .frame(height: 30)
                        
                        TextField(NSLocalizedString("Phone Number".localized(language), comment: ""), text: $phoneNumber, onEditingChanged: { changed in
                            print("\($phoneNumber)")
                            
                            self.registerData.noTelepon = phoneNumber
                            UserDefaults.standard.set(self.registerData.noTelepon, forKey: "phone_local")
                        }, onCommit: {
                            print("Commited")
                            self.registerData.noTelepon = phoneNumber
                            UserDefaults.standard.set(self.registerData.noTelepon, forKey: "phone_local")
                        })
                        .foregroundColor(.black)
                        .onReceive(phoneNumber.publisher.collect()) {
                            
                            if String($0).hasPrefix("1") {
                                self.isInvalidInput = true
                                print("INVALID")
                            }
                            
                            if String($0).hasPrefix("2") {
                                self.isInvalidInput = true
                                print("INVALID")
                            }
                            
                            if String($0).hasPrefix("3") {
                                self.isInvalidInput = true
                                print("INVALID")
                            }
                            
                            if String($0).hasPrefix("4") {
                                self.isInvalidInput = true
                                print("INVALID")
                            }
                            
                            if String($0).hasPrefix("5") {
                                self.isInvalidInput = true
                                print("INVALID")
                            }
                            
                            if String($0).hasPrefix("6") {
                                self.isInvalidInput = true
                                print("INVALID")
                            }
                            
                            if String($0).hasPrefix("7") {
                                self.isInvalidInput = true
                                print("INVALID")
                            }
                            
                            if String($0).hasPrefix("8") {
                                self.isInvalidInput = false
                                print("VALID")
                            }
                            
                            if String($0).hasPrefix("0") {
                                self.phoneNumber = String(String($0).substring(with: 1..<String($0).count).prefix(12))
                            } else {
                                self.phoneNumber = String($0.prefix(12))
                            }
                        }
                        .keyboardType(.numberPad)
                    }
                    .frame(height: 20)
                    .font(.custom("Montserrat-Regular", size: 12))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.25), radius: 15, x: 0.0, y: 4)
                    .padding(.vertical, 15)
                    
                    Button(action: {
                        if self.isInvalidInput {
                            self.isShowModal = true
                            print("INVALID INPUT (Cannot Pass Screen)")
                            UIApplication.shared.endEditing()
                        } else {
                            print("VALID")
                            self.root2IsActive = true
                        }
                        
                    }, label: {
                        Text(NSLocalizedString("Phone Number Verification".localized(language), comment: ""))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    })
                    .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                    .disabled(disableForm)
                    
                    NavigationLink(
                        destination: FormOTPVerificationRegisterNasabahView(rootIsActive: self.$rootIsActive, root2IsActive: self.$root2IsActive).environmentObject(registerData),
                        isActive: self.$root2IsActive,
                        label: {}
                    )
                    .isDetailLink(false)
  
                }
                .padding(.horizontal, 30)
                .frame(width: UIScreen.main.bounds.width - 40)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.vertical, 25)
                
            }
            
            if self.isShowModal {
                ModalOverlay(tapAction: { withAnimation {} })
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .introspectNavigationController { nc in
            nc.interactivePopGestureRecognizer?.isEnabled = true
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Do you want to cancel registration?".localized(language), comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YES".localized(language), comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("TIDAK".localized(language), comment: ""))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.showingAlert = true
            }
        }))
        .popup(
            isPresented: $isShowModal,
            type: .floater(),
            position: .bottom,
            animation: Animation.spring(),
            closeOnTap: true,
            closeOnTapOutside: true) { popupOTPInvalid() }
    }
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func popupOTPInvalid() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text(NSLocalizedString("Please Check Your Mobile Number".localized(language), comment: ""))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isShowModal = false
            }) {
                Text(NSLocalizedString("Back".localized(language), comment: ""))
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

struct PhoneVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormPhoneVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(RegistrasiModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
