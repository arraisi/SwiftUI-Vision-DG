//
//  PinView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct PinView: View {
    
    var index : Int
    @Binding var password : String
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 15, height: 15)
            
            if password.count > index{
                Circle()
                    .fill(Color.white)
                    .frame(width: 15, height: 15)
            }
        }
    }
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView(index: 0, password: .constant(""))
    }
}
