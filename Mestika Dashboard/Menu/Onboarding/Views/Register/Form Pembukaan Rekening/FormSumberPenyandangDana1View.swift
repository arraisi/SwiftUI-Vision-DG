//
//  FormSumberPenyandangDanaView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 06/10/20.
//

import SwiftUI

struct FormSumberPenyandangDana1View: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Registrasi Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    // View variables
    let sumberPenyandangDana: [MasterModel] = load("sumberPenyandangDana.json")
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 380)
                Color(hex: "#F6F8FB")
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                
                ScrollView {
                    
                    ZStack {
                        
                        VStack {
                            Color(hex: "#232175")
                                .frame(height: 380)
                            Color(hex: "#F6F8FB")
                                .cornerRadius(radius: 25.0, corners: .topLeft)
                                .cornerRadius(radius: 25.0, corners: .topRight)
                                .padding(.top, -30)
                        }
                        
                        VStack{
                            // Title
                            Text("OPENING ACCOUNT DATA".localized(language))
                                .font(.custom("Montserrat-ExtraBold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(40)
                            
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
                                    
                                    VStack {
                                        
                                        Spacer()
                                        
                                        // Sub title
                                        Text("Funding Resources - 01".localized(language))
                                            .font(.custom("Montserrat-SemiBold", size: 18))
                                            .foregroundColor(Color(hex: "#232175"))
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 30)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        // Forms input
                                        ZStack {
                                            
                                            RadioButtonGroup(
                                                items: sumberPenyandangDana,
                                                selectedId: $registerData.sumberPenyandangDanaId) { selected in
                                                
                                                if let i = sumberPenyandangDana.firstIndex(where: { $0.id == selected }) {
                                                    print(sumberPenyandangDana[i])
                                                    registerData.sumberPenyandangDana = sumberPenyandangDana[i].name
                                                }
                                                
                                                print("Selected is: \(registerData.sumberPenyandangDana)")
                                                
                                            }
                                            .padding()
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 100)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                        
                                        // Button
                                        NavigationLink(destination: FormSumberPenyandandDana2View().environmentObject(registerData), label:{
                                            
                                            Text("Next".localized(language))
                                                .foregroundColor(.white)
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                            
                                        })
                                        .disabled(registerData.sumberPenyandangDanaId == 0)
                                        .frame(height: 50)
                                        .background(registerData.sumberPenyandangDanaId == 0 ? Color(.lightGray) : Color(hex: "#2334D0"))
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 25)
                                        
                                    }
                                    .background(LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(25.0)
                                    .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 10, y: -2)
                                    .padding(.horizontal, 30)
                                    .padding(.top, 25)
                                }
                                
                            }
                            .padding(.bottom, 25)
                            
                        }
                    }
                }
                .KeyboardAwarePadding()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
    }
}

struct FormSumberPenyandangDanaView_Previews: PreviewProvider {
    static var previews: some View {
        FormSumberPenyandangDana1View().environmentObject(RegistrasiModel())
    }
}
