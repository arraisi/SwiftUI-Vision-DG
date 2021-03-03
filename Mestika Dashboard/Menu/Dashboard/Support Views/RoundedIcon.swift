//
//  RoundedIcon.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/03/21.
//

import SwiftUI

struct RoundedIcon: View {
    
    var imageName: String
    
    var body: some View {
        VStack {
            
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.white)
                .frame(width: 23, height: 23)
            
        }
        .frame(width: 40, height: 40)
        .background(Color("StaleBlue"))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("White"), lineWidth: 1)
        )
        .cornerRadius(10)
        .shadow(color: Color("WarmBlue15").opacity(0.30), radius: 10, x: 0, y: 3)
    }
}

struct RoundedIcon_Previews: PreviewProvider {
    static var previews: some View {
        RoundedIcon(imageName: "ic_rekening")
    }
}
