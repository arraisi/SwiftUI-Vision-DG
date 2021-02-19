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
    @State private var language: Int = 2
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            AppBarLogo(light: true, showBackgroundBlueOnStatusBar: true) {
                
            }
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Choose Language")
                        .font(.custom("Montserrat-Bold", size: 24))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    VStack(alignment: .leading, spacing: 30) {
                        Text("Select this Language to use for the Application")
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#002251"))
                            .padding(.top, 5)
                        
                        RadioButtonGroup(
                            items: languages,
                            selectedId: $language) { selected in }
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            print("language \(language)")
                        }) {
                            Text("Use this Language")
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
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct LanguageSettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSettingScreen()
    }
}
