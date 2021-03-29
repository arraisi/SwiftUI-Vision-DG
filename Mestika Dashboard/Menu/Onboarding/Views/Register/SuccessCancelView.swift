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
    
    // View Variables
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
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
                        
                        Text("Succeed".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 16))
                        
                        Text("Application For Account Opening Has Been Canceled".localized(language))
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
                        Text("Back to Main Page".localized(language))
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
        .onAppear() {
            deleteCoreData()
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
//                self.isShowingAlert = true
            }
        }))
    }
    
    func deleteCoreData() {
        for users in user {
            // delete it from the context
            self.managedObjectContext.delete(users)
        }

        // save the context
        try? self.managedObjectContext.save()
    }
}

struct SuccessCancelView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessCancelView()
    }
}
