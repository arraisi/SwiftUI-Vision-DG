//
//  ContentView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import JGProgressHUD_SwiftUI

struct ContentView: View {
    
    let appState = AppState()
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        // this is not the same as manipulating the proxy directly
        let appearance = UINavigationBarAppearance()
        
        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = #colorLiteral(red: 0.1223579869, green: 0.1184208766, blue: 0.4122344553, alpha: 1)
        
        //        // this only applies to big titles
        //        appearance.largeTitleTextAttributes = [
        //            .font : UIFont.systemFont(ofSize: 20),
        //            NSAttributedString.Key.foregroundColor : UIColor.white
        //        ]
        
        // this only applies to small titles
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        //In the following two lines you make sure that you apply the style for good
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        
        
        // This property is not present on the UINavigationBarAppearance
        // object for some reason and you have to leave it til the end
        UINavigationBar.appearance().tintColor = .white
        
    }
    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var registerData = RegistrasiModel()
    
    var body: some View {
        JGProgressHUDPresenter(userInteractionOnHUD: false) {
            ZStack {
                Color(hex: "#F6F8FB")
                
                //                if (status == "LOGGED_IN") {
                //                    BottomNavigationView().environmentObject(appState)
                //                } else {
                //                    WelcomeView()
                //                        .environmentObject(appState)
                //                }
                
                WelcomeView()
                    .environmentObject(appState)
                
//                NavigationView{
//                    InformasiPerusahaanView()
//                        .environment(\.managedObjectContext, context)
//                        .environmentObject(appState)
//                        .environmentObject(registerData)
//                }
            }
            .edgesIgnoringSafeArea(.top)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .active {
                    print("Active")
                } else if newPhase == .background {
                    print("Background")
                }
            }
        }
    }
}

class ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: ContentView())
    }
}
