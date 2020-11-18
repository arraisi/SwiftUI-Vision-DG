//
//  LabelTextFieldWithIcon.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 18/11/20.
//

import SwiftUI

struct LabelTextFieldWithIcon: View {
    
    @Binding var value: String
    var label: String
    var placeHolder: String
    var iconName: String = "ic_checked"
    let onEditingChanged: (Bool)->Void
    let onCommit: ()->Void
    
    var isValid: Bool = true
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(label)
                .font(Font.system(size: 10))
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
            
            HStack {
                TextField(placeHolder, text: $value,onEditingChanged: onEditingChanged, onCommit: onCommit)
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .padding(.horizontal)
                if isValid {
                    Image(iconName)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
            .frame(height: 40)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct LabelTextFieldWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextFieldWithIcon(value: Binding.constant(""), label: "Demo", placeHolder: "Demo", iconName: "ic_checked") { (Bool) in
            print("on edit")
        } onCommit: {
            print("on commit")
        }
    }
}
