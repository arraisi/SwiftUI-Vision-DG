//
//  PinView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct PinView: View {
    
    var index: Int
    @Binding var password: String
    @Binding var emptyColor: Color
    @Binding var fillColor: Color
    
    var body: some View {
        ZStack{
            Circle()
                .fill(self.emptyColor)
                .frame(width: 15, height: 15)
            
            if password.count > index{
                Circle()
                    .fill(self.fillColor)
                    .frame(width: 15, height: 15)
            }
        }
    }
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView(index: 0, password: .constant(""), emptyColor: .constant(Color.white), fillColor: .constant(Color.white))
    }
}
