//
//  ContentView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import JGProgressHUD_SwiftUI
import NavigationStack

struct ContentView: View {
    
    let appState = AppState()
    
    @State var status: String = ""
    
    // Device ID
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
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
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            getUserStatus(deviceId: deviceId!)
        }
    }
    
    /* Function GET USER Status */
    @ObservedObject var userVM = UserRegistrationViewModel()
    func getUserStatus(deviceId: String) {
        print("GET USER STATUS")
        print("DEVICE ID : \(deviceId)")
        
        self.userVM.userCheck(deviceId: deviceId) { success in
            
            if success {
                print("CODE STATUS : \(self.userVM.code)")
                print("MESSAGE STATUS : \(self.userVM.message)")
                
                self.status = self.userVM.message
            }
            
            if !success {
                self.status = "USER_NOT_FOUND"
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
