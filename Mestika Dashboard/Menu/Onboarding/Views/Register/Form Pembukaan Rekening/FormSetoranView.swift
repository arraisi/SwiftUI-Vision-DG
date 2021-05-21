//
//  FormSetoranView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 20/05/21.
//

import SwiftUI

struct FormSetoranView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Registrasi Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    // Routing variables
    @State var editMode: EditMode = .inactive
    
    // View variables
    let perkiraanSetoran: [MasterModel] = load("perkiraanSetoran.json")
    let besarPerkiraanSetoran: [MasterModel] = load("besarPerkiraanSetoran.json")
    
    var disableButton: Bool {
        registerData.perkiraanSetoranId == 0 || registerData.besarPerkiraanSetoranId == 0
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 350)
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
                        
                        VStack {
                            // Title
                            Text("OPENING ACCOUNT DATA".localized(language))
                                .font(.custom("Montserrat-ExtraBold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 30)
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
                                    
                                    VStack {
                                        
                                        Spacer()
                                        
                                        perkiraanSetoranView
                                        
                                        besarSetoranView
                                        
                                        // Button
                                        if (editMode == .inactive) {
                                            NavigationLink(destination: PerkerjaanView().environmentObject(registerData)) {
                                                
                                                Text("Next".localized(language))
                                                    .foregroundColor(.white)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                                
                                            }
                                            .disabled(disableButton)
                                            .frame(height: 50)
                                            .background(disableButton ? Color(.lightGray) : Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 25)
                                        } else {
                                            NavigationLink(destination: RegisterSummaryView().environmentObject(registerData)) {
                                                
                                                Text("Save".localized(language))
                                                    .foregroundColor(.white)
                                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                                
                                            }
                                            .disabled(disableButton)
                                            .frame(height: 50)
                                            .background(disableButton ? Color(.lightGray) : Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 25)
                                        }
                                        
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
    
    private var perkiraanSetoranView: some View {
        VStack {
            // Sub title
            Text("How many times are estimated for the deposit of funds in a month".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            
            // Forms input
            ZStack {
                
                RadioButtonGroup(
                    items: perkiraanSetoran,
                    selectedId: $registerData.perkiraanSetoranId) { selected in
                    
                    if let i = perkiraanSetoran.firstIndex(where: { $0.id == selected }) {
                        print(perkiraanSetoran[i])
                        registerData.perkiraanSetoran = perkiraanSetoran[i].name
                    }
                    
                    print("Selected is: \(registerData.perkiraanSetoran)")
                    
                }
                .padding()
                
            }
            .frame(width: UIScreen.main.bounds.width - 100)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        }
    }
    
    private var besarSetoranView: some View {
        VStack {
            // Sub title
            Text("How Much Your Estimated Deposit Funds Each Month".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            
            // Forms input
            ZStack {
                
                RadioButtonGroup(
                    items: besarPerkiraanSetoran,
                    selectedId: $registerData.besarPerkiraanSetoranId) { selected in
                    
                    if let i = besarPerkiraanSetoran.firstIndex(where: { $0.id == selected }) {
                        print(besarPerkiraanSetoran[i])
                        registerData.besarPerkiraanSetoran = besarPerkiraanSetoran[i].name
                    }
                    
                    print("Selected is: \(registerData.besarPerkiraanSetoran)")
                    
                }
                .padding()
                
            }
            .frame(width: UIScreen.main.bounds.width - 100)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        }
    }
}

struct FormSetoranView_Previews: PreviewProvider {
    static var previews: some View {
        FormSetoranView().environmentObject(RegistrasiModel())
    }
}
