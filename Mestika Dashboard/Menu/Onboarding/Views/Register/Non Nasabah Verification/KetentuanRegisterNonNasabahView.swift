//
//  RegisterProvisionView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI
import Introspect

struct KetentuanRegisterNonNasabahView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Data Model */
    @StateObject var ketentuanViewModel = KetentuanViewModel()
    
    /* Root Binding */
    @State var isActive : Bool = false
    @Binding var rootIsActive : Bool
    
    // MARK: -MAIN CONTENT
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: UIScreen.main.bounds.height*0.5)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                VStack {
                        ZStack {
                            VStack {
                                Color(hex: "#232175")
                                    .frame(height: UIScreen.main.bounds.height*0.2)
                                Color(hex: "#F6F8FB")
                            }
                            
                            VStack(alignment: .leading) {
                                Image("ic_bells")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .padding(.top, 30)
                                
                                Text("Sebelum Memulai..!!")
                                    .font(.custom("Montserrat-Bold", size: 22))
                                    .foregroundColor(Color(hex: "#232175"))
                                    .padding(.vertical, 10)
                                
                                WebView(urlString: Bundle.main.url(forResource: "term", withExtension: "html")?.absoluteString)
                                    .gesture(
                                       DragGesture().onChanged { value in
                                          if value.translation.height > 0 {
                                             print("Scroll down")
                                          } else {
                                             print("Scroll up")
                                          }
                                       }
                                    )
                                
                                NavigationLink(
                                    destination: FormPhoneVerificationRegisterNasabahView(rootIsActive: self.$rootIsActive, root2IsActive: self.$isActive).environmentObject(registerData)
                                    ){
                                    Text("Lanjut Membuat Rekening")
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                }
                                .isDetailLink(false)
                                .background(Color(hex: "#2334D0"))
                                .cornerRadius(12)
                                .padding(.bottom, 5)
                                .padding(.top, 10)
                                
                                Button(action : {
                                    self.appState.moveToWelcomeView = true
                                }) {
                                    Text("Batal Mendaftar")
                                        .foregroundColor(.gray)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                }
                                .cornerRadius(12)
                                .padding(.bottom, 20)
                            }
                            .padding(.horizontal, 30)
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                                .padding(.vertical, 30)
                    }
                }
                .padding(.vertical, 25)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .introspectNavigationController { nc in
            nc.navigationBar.isHidden = false
        }
        .onAppear() {
            self.registerData.isNasabahmestika = false
        }
    }
}

struct KetentuanRegisterNonNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KetentuanRegisterNonNasabahView(
                rootIsActive: .constant(false)).environmentObject(RegistrasiModel())
        }
    }
}
