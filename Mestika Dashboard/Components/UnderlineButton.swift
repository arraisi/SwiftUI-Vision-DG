//
//  UnderlineButton.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 23/04/21.
//

import SwiftUI

struct UnderlineButton: View {
    
    var active: Bool
    var label: String
    var action: ()->()
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack{
                Text(label)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(active ? Color("StaleBlue") : Color.gray)
                Group {
                    Rectangle()
                }
                .frame(height: 3)
                .foregroundColor(active ? Color("StaleBlue") : Color.gray)
            }
        })
    }
}

struct UnderlineButton_Previews: PreviewProvider {
    static var previews: some View {
        UnderlineButton(active: false, label: "Test", action: {
        
        })
    }
}
