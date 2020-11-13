//
//  CheckBoxGroup.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 05/10/20.
//

import SwiftUI

struct CheckBoxField: View {
    
    let id: Int
    let markedId: [Int]
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let callback: (Int, [Int])->()
    
    init(
        id: Int,
        markedId: [Int],
        label:String,
        size: CGFloat = 19,
        color: Color = Color(hex: "#707070"),
        textSize: CGFloat = 10,
        callback: @escaping (Int, [Int])->()
    ) {
        self.id = id
        self.markedId = markedId
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
    }
    
    var body: some View {
        
        Button(action:{
            
            self.callback(self.id, self.markedId)
            
        }) {
            HStack(alignment: .center, spacing: 10) {
                
                Image(systemName: self.markedId.contains(self.id) ? "checkmark.square" : "square")
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

struct CheckBoxGroup: View {
    
    let items : [MasterModel]
    @Binding var markedId: [Int]
    let callback: (Int, [Int])->()
    
    var body: some View {
        HStack{
            
            VStack {
                
                ForEach(0..<items.count) { index in
                    CheckBoxField(id: items[index].id, markedId: self.markedId, label: items[index].name, callback: self.checkboxSelected)
                }
                
            }
        }
    }
    
    func checkboxSelected(id: Int, marked: [Int]) {
        if markedId.contains(id) {
            
            markedId = markedId.filter {$0 != id}
            
        } else {
            
            self.markedId.append(id)
            
        }
        
        callback(id, markedId)
    }
}

struct CheckBoxGroup_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxGroup(items: masterData, markedId: Binding.constant([])) { (id, marked) in
            
        }
    }
}
