//
//  LanguageSettingScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct LanguageSettingScreen: View {
    
    // View variables
    let languages: [MasterModel] = load("languages.json")
    @State private var languageId: Int = 2
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var showingAlert: Bool = false
    
    var body: some View {
        VStack {
            AppBarLogo(light: true, showBackgroundBlueOnStatusBar: true) {}
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Choose Language".localized(language))
                        .font(.custom("Montserrat-Bold", size: 24))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    VStack(alignment: .leading, spacing: 30) {
                        Text("Select this Language to use for the Application".localized(language))
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#002251"))
                            .padding(.top, 5)
                        
                        RadioButtonGroup(
                            items: languages,
                            selectedId: $languageId) { selected in
                        }
                        
                        Button(action: {
                            if languageId == 1 {
                                LocalizationService.shared.language = .indonesia
                            } else {
                                LocalizationService.shared.language = .english_us
                            }
                            
                            self.showingAlert = true
                        }) {
                            Text("Use this Language".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 16))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        }
                        .padding()
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    }
                    
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
                .padding()
                //            .padding(.top, 30)
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Succeed".localized(language)),
                message: Text("Language changed successfully".localized(language)),
                dismissButton: .default(Text("OK".localized(language)), action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
            )
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 50) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            print("User language : \(LocalizationService.shared.language)")
            if language == .indonesia {
                self.languageId = 1
            } else { self.languageId = 2 }
            
        }
    }
}

struct LanguageSettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSettingScreen()
    }
}
