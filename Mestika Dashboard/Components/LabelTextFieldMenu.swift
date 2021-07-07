//
//  LabelTextFieldMenu.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/05/21.
//

import SwiftUI

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
//                TextField(label, text: $value, onEditingChanged: onEditingChanged, onCommit: onCommit)
                Menu {
                    ForEach(0..<data.count, id: \.self) { i in
                        Button(action: {
                            print(data[i])
                            self.value = data[i]
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
        
//        HStack {
//            TextField("Select other income".localized(language), text: $registerData.sumberPendapatanLainnya)
//                .font(.custom("Montserrat-Regular", size: 12))
//                .frame(height: 50)
//                .padding(.leading, 15)
//                .disabled(true)
//
//            Menu {
//                ForEach(0..<sumberPendapatanLainnyaList.count, id: \.self) { i in
//                    Button(action: {
//                        print(sumberPendapatanLainnyaList[i])
//                        registerData.sumberPendapatanLainnya = sumberPendapatanLainnyaList[i]
//                    }) {
//                        Text(sumberPendapatanLainnyaList[i])
//                            .font(.custom("Montserrat-Regular", size: 12))
//                    }
//                }
//            } label: {
//                Image(systemName: "chevron.right").padding()
//            }
//
//        }
//        .frame(height: 36)
//        .font(Font.system(size: 14))
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//        .padding(.horizontal, 20)
    }
}

struct LabelTextFieldMenu_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextFieldMenu(value: .constant("Male"), label: "Gender", data: ["Male", "Female"], disabled: false, onEditingChanged: {_ in}, onCommit: {})
    }
}
