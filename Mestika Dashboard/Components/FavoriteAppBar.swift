//
//  FavoriteAppBar.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/02/21.
//

import SwiftUI

struct FavoriteAppBar: View {
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
            Text("Tambahkan ke Favorit ?")
                .foregroundColor(Color.white)
                .font(.system(size: 20))
                .bold()
        }
    }
}

struct FavoriteAppBar_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAppBar(barItems: AnyView(EmptyView()))
    }
}
