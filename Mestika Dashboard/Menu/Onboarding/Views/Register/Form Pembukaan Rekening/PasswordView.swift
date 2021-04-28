//
//  FormPasswordView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 04/10/20.
//

import SwiftUI
import SwiftyRSA

struct PasswordView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    @State var password: String = ""
    @State var confirmationPassword: String = ""
    
    @State private var securedPassword: Bool = true
    @State private var securedConfirmation: Bool = true
    
    @State private var showingModal: Bool = false
    @State private var showingModalPasswordError: Bool = false
    @State private var activeRoute: Bool = false
    @State private var modalErrorMessage: String = ""
    
    // Masking Password
    @State private var isPasswordValid : Bool = false
    @State private var haveCharacter: Bool = false
    @State private var haveLowercase: Bool = false
    @State private var haveUppercase: Bool = false
    @State private var haveNumber: Bool = false
    @State private var haveSpecialcase: Bool = false
    @State private var haveMin8Char: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func isHaveUppercase(_ string: String) -> Bool {
        
        let format = ".*[A-Z]+.*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: string)
    }
    
    func isHaveLowercase(_ string: String) -> Bool {
        
        let format = ".*[a-z]+.*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: string)
    }
    
    func isHaveSpecialChar(_ string: String) -> Bool {
        
        let format = ".*[!@#$&]+.*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: string)
    }
    
    func isHaveNumber(_ string: String) -> Bool {
        
        let format = ".*[0-9]+.*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: string)
    }
    
    func isHave8Char(_ string: String) -> Bool {
        
        if string.count >= 8 {
            return true
        }
        
        return false
    }
    
    func isHaveChar(_ string: String) -> Bool {
        
        if string.count >= 1 {
            return true
        }
        
        return false
    }
    
    func textFieldValidatorPassword(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        
        let emailFormat = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    var disableForm: Bool {
        password.isEmpty || !isPasswordValid || confirmationPassword.isEmpty || password.count < 6 || confirmationPassword.count < 6
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
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                ScrollView {
                    // Title
                    Text("OPENING ACCOUNT DATA".localized(language))
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 25)
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
                            Text("Enter Digital Banking Application Password".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundColor(Color(hex: "#232175"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("This password is used when you enter the Mestika Bank Mobile Banking Application".localized(language))
                                .font(.custom("Montserrat-Regular", size: 12))
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
                                                SecureField("Enter Password".localized(language), text: $password)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .padding()
                                                    .frame(width: 200, height: 50)
                                                    .foregroundColor(Color(hex: "#232175"))
                                                
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
                                                    
                                                    //                                                    self.registerData.password = password
                                                })
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .padding()
                                                .frame(width: 200, height: 50)
                                                .foregroundColor(Color(hex: "#232175"))
                                                .onReceive(password.publisher.collect()) { it in
                                                    self.isPasswordValid = self.textFieldValidatorPassword(String(it))
                                                    self.haveUppercase = self.isHaveUppercase(String(it))
                                                    self.haveLowercase = self.isHaveLowercase(String(it))
                                                    self.haveNumber = self.isHaveNumber(String(it))
                                                    self.haveSpecialcase = self.isHaveSpecialChar(String(it))
                                                    self.haveMin8Char = self.isHave8Char(String(it))
                                                    self.haveCharacter = self.isHaveChar(String(it))
                                                }
                                                
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
                                                    .onReceive(password.publisher.collect()) { it in
                                                        self.isPasswordValid = self.textFieldValidatorPassword(String(it))
                                                        self.haveUppercase = self.isHaveUppercase(String(it))
                                                        self.haveLowercase = self.isHaveLowercase(String(it))
                                                        self.haveNumber = self.isHaveNumber(String(it))
                                                        self.haveSpecialcase = self.isHaveSpecialChar(String(it))
                                                        self.haveMin8Char = self.isHave8Char(String(it))
                                                        self.haveCharacter = self.isHaveChar(String(it))
                                                    }
                                                
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
                            .frame(width: UIScreen.main.bounds.width - 100)
                            .background(Color.white)
                            .cornerRadius(15)
                            .addBorder(self.isPasswordValid ? Color.blue : Color.red, width: self.password.count > 0 ? 1 : 0 , cornerRadius: 15)
                            .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                            
                            
                            VStack {
                                
                                HStack {
                                    Text("Harap gunakan setidaknya :")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                        .padding(.bottom, 5)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    if (self.haveCharacter) {
                                        Text("✓")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    } else {
                                        Text("✗")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    }
                                    
                                    Text("1 Karakter")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                                
                                HStack {
                                    if (self.haveLowercase) {
                                        Text("✓")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    } else {
                                        Text("✗")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    }
                                    
                                    Text("1 Huruf Kecil")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                                
                                HStack {
                                    
                                    if (self.haveUppercase) {
                                        Text("✓")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    } else {
                                        Text("✗")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    }
                                    
                                    Text("1 Huruf kapital/besar")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                                
                                HStack {
                                    if (self.haveNumber) {
                                        Text("✓")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    } else {
                                        Text("✗")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    }
                                    
                                    Text("1 Angka")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                                
                                HStack {
                                    if (self.haveSpecialcase) {
                                        Text("✓")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    } else {
                                        Text("✗")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    }
                                    
                                    Text("1 Karakter Spesial")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                                
                                HStack {
                                    if (self.haveMin8Char) {
                                        Text("✓")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    } else {
                                        Text("✗")
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .padding(.leading, 25)
                                    }
                                    
                                    Text("Minimal 8 karakter")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                            }
                            .frame(width: UIScreen.main.bounds.width - 90, alignment: .leading)
                            
                            NavigationLink(
                                destination: PINView().environmentObject(registerData),
                                isActive: $activeRoute,
                                label: {
                                    Text("")
                                }
                            )
                            
                            Button(
                                action: {
                                    if (password != confirmationPassword) {
                                        self.showingModal.toggle()
                                    } else {
                                        getValidationPassword()
                                    }
                                },
                                label:{
                                    Text("Next".localized(language))
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
                    .navigationBarBackButtonHidden(true)
                    .padding(.bottom, 25)
                }
                .KeyboardAwarePadding()
            }
            
            if self.showingModal || self.showingModalPasswordError {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Do you want to cancel registration?".localized(language)),
                primaryButton: .default(Text("YES".localized(language)), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text("NO".localized(language))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.showingAlert = true
            }
        }))
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalPasswordNotMatched()
        }
        .popup(isPresented: $showingModalPasswordError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalPasswordError()
        }
        
    }
    
    // MARK: -Bottom modal for error
    func modalPasswordNotMatched() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password is not the same, please retype".localized(language))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {}) {
                Text("Back".localized(language))
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
    
    // MARK: -Bottom modal for error
    func modalPasswordError() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(20)
            
            Text(modalErrorMessage)
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(20)
            
            Button(action: {}) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(20)
        }
        .background(Color.white)
        .cornerRadius(20)
    }
    
    @ObservedObject var passwordVM = PasswordViewModel()
    func getValidationPassword() {
        self.passwordVM.validationPassword(password: password) { success in
            if success {
                switch self.passwordVM.code {
                case "R100":
                    self.activeRoute = true
                case "200":
                    encryptPassword(password: password)
                    self.activeRoute = true
                default:
                    //                    self.modalErrorMessage = self.passwordVM.message
                    self.modalErrorMessage = "Weak password, please change your password"
                    self.showingModalPasswordError.toggle()
                }
            }
            else {
                print(self.passwordVM.code)
                print(self.passwordVM.message)
            }
        }
    }
    
    func encryptPassword(password: String) {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: password, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        
        self.registerData.password = base64String
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView().environmentObject(RegistrasiModel())
    }
}
