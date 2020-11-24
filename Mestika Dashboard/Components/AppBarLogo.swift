//
//  AppBarLogo.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 23/11/20.
//

import SwiftUI
import NavigationStack

struct AppBarLogo: View {
    var light: Bool = false
    var hideBack: Bool = false
    
    var body: some View {
        HStack {
            if !hideBack {
                PopView {
                    Image("ic_back")
                        .foregroundColor(light ? .white : Color("DarkStaleBlue"))
                        .frame(width: 30, height: 25)
                        .padding(.horizontal, 10)
                }
            }
            Spacer()
            logo
            Spacer()
        }
    }
    
    // MARK: - LOGO
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            if !light {
                Image("Logo M")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("BANK MESTIKA")
                    .foregroundColor(Color(hex: "#232175"))
                    .font(.system(size: 20))
                    .bold()
            } else {
                Image("logo_mestika")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 25)
            }
        }
        .padding(.trailing, hideBack ? 0 : 50)
    }
}

struct AppBarLogo_Previews: PreviewProvider {
    static var previews: some View {
        AppBarLogo()
    }
}
