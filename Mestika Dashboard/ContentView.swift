//
//  ContentView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        // this is not the same as manipulating the proxy directly
        let appearance = UINavigationBarAppearance()
        
        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = UIColor(Color(hex: "#242576"))
        
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
    
    var body: some View {
//        BottomNavigationView()
        NavigationView {
            ZStack {
                Color(hex: "#F6F8FB")
                WelcomeView()
                    .navigationBarHidden(true)
            }
            .edgesIgnoringSafeArea(.top)
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
