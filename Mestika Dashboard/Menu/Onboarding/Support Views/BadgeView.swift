//
//  BadgeView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/01/21.
//

import SwiftUI

struct BadgeView: View {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal)
        }
        .background(Color.black.opacity(0.5))
        .cornerRadius(20)
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(text: "Silahkan scroll kebawah")
    }
}
