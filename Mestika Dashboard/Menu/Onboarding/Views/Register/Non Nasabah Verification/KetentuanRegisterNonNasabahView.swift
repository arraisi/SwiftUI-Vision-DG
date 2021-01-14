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
    @State var goToNext : Bool = false
    @Binding var rootIsActive : Bool
    
    @State var readFinished = false
    @State var scrollToBottom = false
    
    var isAllowBack: Bool = true
    
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
                                .frame(width: 70, height: 70)
                                .padding(.top, 20)
                            
                            Text(NSLocalizedString("Sebelum Memulai..!!", comment: ""))
                                .font(.custom("Montserrat-Bold", size: 18))
                                .foregroundColor(Color(hex: "#232175"))
                                .padding(.top, 0)
                                .padding(.bottom, 5)
                            
                            WebView(readFinished: self.$readFinished, scrollToBottom: self.$scrollToBottom, urlString: Bundle.main.url(forResource: "term", withExtension: "html")?.absoluteString)
                                .onChange(of: readFinished, perform: { value in
                                    scrollToBottom = true
                                })
                                .highPriorityGesture(
                                    
                                    DragGesture()
                                        .onChanged({ (value) in
                                            
                                            if value.translation.height > 0 {
                                                print("\(value.translation.height) > 0")
                                                scrollToBottom = false
                                                
                                            }
                                            
                                        })
                                )
                            
                            NavigationLink(
                                destination: FormPhoneVerificationRegisterNasabahView(rootIsActive: self.$rootIsActive, root2IsActive: self.$isActive).environmentObject(registerData),
                                isActive: $goToNext,
                                label: {}
                            )
                            .isDetailLink(false)
                            
                            Button(action : {
                                self.goToNext = true
                            }) {
                                Text(NSLocalizedString("Lanjut Membuat Rekening", comment: ""))
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            }
                            .background(self.readFinished ? Color(hex: "#2334D0") : Color(.lightGray))
                            .disabled(!self.readFinished)
                            .cornerRadius(12)
                            .padding(.top, 10)
                            
                            Button(action : {
                                self.appState.moveToWelcomeView = true
                            }) {
                                Text(NSLocalizedString("Batal Mendaftar", comment: ""))
                                    .foregroundColor(.gray)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            }
                            .cornerRadius(12)
                            .padding(.bottom, 10)
                        }
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .introspectNavigationController { nc in
            nc.navigationBar.isHidden = false
            nc.interactivePopGestureRecognizer?.isEnabled = false
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
