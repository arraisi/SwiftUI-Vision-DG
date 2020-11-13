//
//  RadioButtonGroup.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 01/10/20.
//

import SwiftUI

struct RadioButton: View {

    let id: Int
    let label: String
    let callback: (Int)->()
    let selectedID : Int
    let size: CGFloat
    let color: Color
    let textSize: CGFloat

    init(
        _ id: Int,
        label: String,
        callback: @escaping (Int)->(),
        selectedID: Int,
        size: CGFloat = 19,
        color: Color = Color(hex: "#707070"),
        textSize: CGFloat = 10
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.selectedID = selectedID
        self.callback = callback
    }

    var body: some View {
        
        Button(action:{
            
            self.callback(self.id)
            
        }) {
            
            HStack(alignment: .center, spacing: 10) {
                
                Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
//                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                
                Text(label)
                    .font(.custom("Montserrat-Regular", size: textSize))
                
                Spacer()
                
            }
            .foregroundColor(self.color)
        }
    }
}


// MARK: - Radio Button Group
struct RadioButtonGroup: View {

    let items : [MasterModel]
    @Binding var selectedId: Int

    let callback: (Int) -> ()

    var body: some View {
        VStack {
            ForEach(0..<items.count) { index in
                RadioButton(self.items[index].id, label: self.items[index].name, callback: self.radioGroupCallback, selectedID: self.selectedId)
            }
        }
    }

    func radioGroupCallback(id: Int) {
        selectedId = id
        callback(id)
    }
}

struct RadioButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonGroup(items: masterData, selectedId: Binding.constant(0)) { (id) in
            print(id)
        }
    }
}
