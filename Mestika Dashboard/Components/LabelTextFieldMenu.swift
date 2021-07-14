//
//  LabelTextFieldMenu.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/05/21.
//

import SwiftUI
import Combine

struct LabelTextFieldMenu: View {
    
    @Binding var value: String
    var label: String
    var data: [String]
    let disabled: Bool
    let onEditingChanged: (Bool)->Void
    let onCommit: ()->Void
    
    var isValid: Bool = true
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(label)
                .font(Font.system(size: 12))
                .fontWeight(.semibold)
//                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
            
            HStack {
                TextField(label, text: $value)
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .padding(.horizontal)
                    .disabled(true)
                
                Menu {
                    ForEach(0..<data.count, id: \.self) { i in
                        Button(action: {
                            
                            if (data[i] == "0 - 10 Kali") {
                                self.value = "0-10_KALI"
                                print(value)
                            } else {
                                print(data[i])
                                self.value = data[i]
                            }
                            

                        }) {
                            Text(data[i])
                                .font(.custom("Montserrat-Regular", size: 12))
                        }
                    }
                } label: {
                    Image(systemName: "chevron.right").padding()
                }
                .disabled(disabled)
            }
            .frame(height: 40)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct LabelTextFieldMenu_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextFieldMenu(value: .constant("Male"), label: "Gender", data: ["Male", "Female"], disabled: false, onEditingChanged: {_ in}, onCommit: {})
    }
}
