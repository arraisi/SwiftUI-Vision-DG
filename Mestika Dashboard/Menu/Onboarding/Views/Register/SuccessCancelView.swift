//
//  SuccessCancelView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 11/01/21.
//

import SwiftUI

struct SuccessCancelView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#232175")
            
            VStack(spacing: 10) {
                Spacer()
                
                ZStack() {
                    VStack(spacing: 5) {
                        Image("ic_success")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(.bottom, 20)
                        
                        Text(NSLocalizedString("Succeed".localized(language), comment: ""))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 16))
                        
                        Text(NSLocalizedString("Application For Account Opening Has Been Canceled".localized(language), comment: ""))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Normal", size: 12))
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(spacing: 5) {
                    
                    Button(action: {
                        self.appState.moveToWelcomeView = true
                    }, label: {
                        Text(NSLocalizedString("Back to Main Page".localized(language), comment: ""))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Bold", size: 16))
                    })
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .cornerRadius(15)
                }
                .padding(20)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
//                self.isShowingAlert = true
            }
        }))
    }
}

struct SuccessCancelView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessCancelView()
    }
}
