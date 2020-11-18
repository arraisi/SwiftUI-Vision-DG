//
//  TextFieldIcon.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 17/11/20.
//

import SwiftUI

struct TextFieldValidation: View {
    
    @Binding var data: String
    
    var title: String
    var disable: Bool
    var isValid: Bool
    var keyboardType: UIKeyboardType
    var callback: (_ str: Array<Character>) -> Void
    
    var body: some View {
        HStack {
            TextField(self.title, text: $data)
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(.black)
                .keyboardType(keyboardType)
                .onReceive(data.publisher.collect()) {
                    callback($0)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .disabled(disable)
                .frame(width: .infinity, height: .infinity)
            if isValid {
                Image("ic_checked")
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

struct TextFieldIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldValidation(data: .constant(""), title: "Title Here", disable: false, isValid: false, keyboardType: .numberPad, callback: { (str: Array<Character>) in
        })
    }
}
