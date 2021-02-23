//
//  AppBarLogo.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 23/11/20.
//

import SwiftUI

struct AppBarLogo: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var light: Bool = true
    var showBack: Bool = false
    var showCancel: Bool = false
    var showBackgroundBlueOnStatusBar: Bool = false
    let onCancel: ()->()
    
    var body: some View {
        VStack {
            if showBackgroundBlueOnStatusBar {
                ZStack{ Color("DarkStaleBlue") }.frame(height: 40)
            }
            HStack(spacing: 0) {
                if showBack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("ic_back")
                            .foregroundColor(light ? Color("DarkStaleBlue") : .white)
                            .frame(width: 30, height: 25)
                    })
                    .frame(width: UIScreen.main.bounds.width * 0.2)
                } else {
                    Spacer().frame(width: UIScreen.main.bounds.width * 0.2)
                }
                
                logo
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                
                if showCancel {
                    Button(action: {
                        self.onCancel()
                    }, label: {
                        Text("Cancel")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundColor(light ? Color("DarkStaleBlue") : .white )
                    })
                    .frame(width: UIScreen.main.bounds.width * 0.2)
                } else {
                    Spacer().frame(width: UIScreen.main.bounds.width * 0.2)
                }
            }
            .padding(.top, showBackgroundBlueOnStatusBar ? 10 : 50)
        }
        .padding(.bottom, 5)
    }
    
    // MARK: - LOGO
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            if light {
                Image("Logo M")
                    .resizable()
                    .frame(width: 28, height: 28)
                Text("BANK MESTIKA")
                    .foregroundColor(Color(hex: "#232175"))
                    .font(.system(size: 26))
                    .bold()
            } else {
                Image("logo_mestika")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
            }
        }
    }
}

struct AppBarLogo_Previews: PreviewProvider {
    static var previews: some View {
        AppBarLogo() {
            
        }
    }
}
