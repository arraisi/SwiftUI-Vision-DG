//
//  ForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct PhoneNumberVerificationForgotPasswordView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Environtment Object */
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var registerData: RegistrasiModel
    
    /* Controller Variable */
    @State private var phoneNumberCtrl = ""
    
    /* Validation */
    @State var isInvalidInput: Bool = false
    @State var isShowModal: Bool = false
    
    @State var isRouteToOTP: Bool = false
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                Text("VERIFY YOUR PHONE NUMBER".localized(language))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Please Enter Your Mobile Number".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                HStack {
                    HStack {
                        Image("indo_flag")
                        Text("+62 ")
                            .font(.system(size: 12))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    
                    Divider()
                        .frame(height: 20)
                    
                    TextField("Phone Number".localized(language), text: $phoneNumberCtrl, onEditingChanged: { changed in
                        print("\($phoneNumberCtrl)")
                        self.registerData.noTelepon = phoneNumberCtrl
                    }, onCommit: {
                        print("Commited")
                        self.registerData.noTelepon = phoneNumberCtrl
                    })
                    .onReceive(phoneNumberCtrl.publisher.collect()) {
                        
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
                            self.phoneNumberCtrl = String(String($0).substring(with: 1..<String($0).count).prefix(12))
                        } else {
                            self.phoneNumberCtrl = String($0.prefix(12))
                        }
                    }
                    .keyboardType(.numberPad)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.top, 20)
                .padding()
                
                Text("Make sure your cellphone number is correct before proceeding to the next stage.".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                VStack {
                    
                    Button(
                        action: {
                            if self.isInvalidInput {
                                self.isShowModal = true
                                print("INVALID INPUT (Cannot Pass Screen)")
                                UIApplication.shared.endEditing()
                            } else {
                                print("VALID")
                                self.isRouteToOTP = true
                            }
                        },
                        label: {
                            Text("ENTER YOUR PHONE NUMBER".localized(language))
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    )
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    
                    NavigationLink(
                        destination: OtpVerificationForgotPasswordView().environmentObject(registerData),
                        isActive: self.$isRouteToOTP,
                        label: {EmptyView()})

                }
                .padding(.bottom, 20)
            }
            
            if self.isShowModal {
                ModalOverlay(tapAction: { withAnimation {} })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Do you want to cancel changing password?".localized(language)),
                primaryButton: .default(Text("YES"), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text("No")))
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
            
            Text("Please Check Your Mobile Number".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isShowModal = false
            }) {
                Text("Back".localized(language))
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

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberVerificationForgotPasswordView()
    }
}
