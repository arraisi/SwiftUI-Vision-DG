//
//  LabelTextField.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 29/09/20.
//

import SwiftUI

struct LabelTextField: View {
    
    @Binding var value: String
    var label: String
    var placeHolder: String
    let onEditingChanged: (Bool)->Void
    let onCommit: ()->Void
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text(label)
                .font(Font.system(size: 10))
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
            
            TextField(placeHolder, text: $value, onEditingChanged: onEditingChanged, onCommit: onCommit)
                .frame(height: 36)
                .font(Font.system(size: 14))
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
       
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextField(value: Binding.constant(""), label: "Demo", placeHolder: "Demo") { (Bool) in
            print("on edit")
        } onCommit: {
            print("on commit")
        }
    }
}
