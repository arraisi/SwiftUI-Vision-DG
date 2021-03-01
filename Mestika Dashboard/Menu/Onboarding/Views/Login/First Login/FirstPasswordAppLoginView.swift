//
//  FirstPasswordAppLoginView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 01/02/21.
//

import SwiftUI

struct FirstPasswordAppLoginView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var nextRoute: Bool = false
    @State var password: String = ""
    
    @State private var securedPassword: Bool = true
    
    /* Disabled Form */
    var disableForm: Bool {
        password.count < 8
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                VStack {
                    Text(NSLocalizedString("LOGIN APPS".localized(language), comment: ""))
                        .font(.custom("Montserrat-Bold", size: 24))
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
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }

    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            Text(NSLocalizedString("Enter your Account Password".localized(language), comment: ""))
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
                                SecureField(NSLocalizedString("Enter Password".localized(language), comment: ""), text: $password)
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
                                TextField(NSLocalizedString("Enter Password".localized(language), comment: ""), text: $password, onEditingChanged: { changed in
                                    print("\($password)")
                                })
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .padding()
                                .frame(width: 200, height: 30)
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
                    
                }
                
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
                    Text(NSLocalizedString("LOGIN APPS".localized(language), comment: ""))
                        .foregroundColor(disableForm ? .white : Color(hex: "#232175"))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                })
                .background(disableForm ? Color.gray.opacity(0.3) : Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .disabled(disableForm)
            
            NavigationLink(
                destination: BottomNavigationView(),
                isActive: self.$nextRoute,
                label: {}
            )
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    func checkPassword() {
        self.nextRoute = true
    }
}

struct FirstPasswordAppLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPasswordAppLoginView()
    }
}
