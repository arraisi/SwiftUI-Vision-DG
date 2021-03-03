//
//  PinVerification.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/03/21.
//

import SwiftUI

struct PinVerification: View {
    
    @Binding var pin: String
    let onChange: ()->()
    let onCommit: ()->()
    
    var body: some View {
        
//        VStack {
//            Text(pin)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                
                ForEach(1...9,id: \.self) { value in
                    Numpad(value: "\(value)")
                }
                
                Numpad(value: "delete.fill")
                    .disabled(true)
                    .hidden()
                
                Numpad(value: "0")
                
                if pin.count > 0 {
                    Button(action: {
                        pin.removeLast()
                    }, label: {
                        VStack{
                            Image(systemName: "delete.left.fill")
                                .font(.system(size: 24))
                                .frame(width: 60, height: 60)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        
                    })
                } else {
                    Numpad(value: "delete.fill")
                        .disabled(true)
                        .hidden()
                }
                
            }
            .padding(.bottom)
            .padding(.horizontal, 30)
//        }
    }
    
    func Numpad(value: String) -> some View {
        Button(action: {
            
            if pin.count < 6 {
                withAnimation {
                    pin.append(value)
                }
            }
            
            self.onChange()
            
            if pin.count == 6 {
                self.onCommit()
            }
            
        }, label: {
            VStack{
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color(hex: "#000000").opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            
        })
    }
}

struct PinVerification_Previews: PreviewProvider {
    static var previews: some View {
        PinVerification(pin: .constant(""), onChange: {}, onCommit: {})
    }
}
