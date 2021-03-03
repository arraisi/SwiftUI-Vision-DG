//
//  RoundedIconLabel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 02/03/21.
//

import SwiftUI

struct RoundedIconLabel: View {
    
    var imageName: String
    var label: String
    
    var body: some View {
        VStack {
            
            Image(imageName)
                .resizable()
                .frame(width: 23, height: 23)
            
            Text(label)
                .font(.custom("Montserrat-Regular", size: 6))
                .foregroundColor(Color("DarkStaleBlue"))
            
        }
        .frame(width: 60, height: 60)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("White"), lineWidth: 1)
        )
        .cornerRadius(10)
        .shadow(color: Color("WarmBlue15").opacity(0.15), radius: 15, x: 0, y: 3)
    }
}

struct RoundedIconLabel_Previews: PreviewProvider {
    static var previews: some View {
        RoundedIconLabel(imageName: "ic_rekening", label: "Rekening")
    }
}
