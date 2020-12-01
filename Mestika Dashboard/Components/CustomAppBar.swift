//
//  CustomAppBar.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 01/12/20.
//

import SwiftUI

struct CustomAppBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var light: Bool = true
    var showBack: Bool = false
    var barItemsHidden: Bool = false
    var barItems: AnyView
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: UIScreen.main.bounds.width * 0.2)
            
            logo
                .frame(width: UIScreen.main.bounds.width * 0.6)
            
            if !barItemsHidden {
                barItems
                    .frame(width: UIScreen.main.bounds.width * 0.2)
            } else {Spacer().frame(width: UIScreen.main.bounds.width * 0.2)}
            
        }
        .padding(.top, 50)
        .padding(.bottom, 5)
    }
    
    // MARK: - LOGO
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            if light {
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
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
            }
        }
    }
}

struct CustomAppBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomAppBar(barItems: AnyView(EmptyView()))
    }
}
