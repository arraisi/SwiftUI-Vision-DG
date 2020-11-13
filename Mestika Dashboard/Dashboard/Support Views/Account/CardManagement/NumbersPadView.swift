//
//  NumbersPadView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 10/11/20.
//

import SwiftUI

struct NumbersPadView: View {
    
    let previousPIN: String
    @Binding var currentPIN: String
    @Binding var unLocked: Bool
    @Binding var wrongPin: Bool
    
    @State var falseCount = 0
    let callback: (Int)->()
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
            
            ForEach(1...9,id: \.self) { value in
                NumberPadView(currentPIN: $currentPIN, wrongPIN: $wrongPin, value: "\(value)", keyDeleteColor: Color(hex: "#2334D0")) { (value, currentPIN) in
                    setPassword(value: value)
                }
            }
            
            NumberPadView(currentPIN: $currentPIN, wrongPIN: $wrongPin, value: "delete.fill", keyDeleteColor: Color(hex: "#2334D0")) { (value, currentPIN) in
                setPassword(value: value)
            }
            .disabled(true)
            .hidden()
            
            NumberPadView(currentPIN: $currentPIN, wrongPIN: $wrongPin, value: "\(0)", keyDeleteColor: Color(hex: "#2334D0")) { (value, currentPIN) in
                setPassword(value: value)
            }
            
            NumberPadView(currentPIN: $currentPIN, wrongPIN: $wrongPin, value: "delete.fill", keyDeleteColor: Color(hex: "#2334D0")) { (value, currentPIN) in
                setPassword(value: value)
            }
        }
        .padding(.bottom)
        .padding(.horizontal, 30)
    }
    
    func setPassword(value: String){
        withAnimation{
            if value.count > 1{
                
                if currentPIN.count != 0{
                    
                    currentPIN.removeLast()
                }
            }
            else{
                
                if currentPIN.count != 6{
                    
                    currentPIN.append(value)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        
                        withAnimation{
                            
                            if currentPIN.count == 6 {
                                
                                print(currentPIN)
                                
                                if currentPIN == previousPIN {
                                    
                                    unLocked = true
                                    wrongPin = false
                                }
                                else{
                                    falseCount += 1
                                    wrongPin = true
                                    currentPIN.removeAll()
                                    
                                    callback(falseCount)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct NumberPadView: View {
    
    @Binding var currentPIN: String
    @Binding var wrongPIN: Bool
    var value: String
    let keyDeleteColor: Color
    let callback: (String, String)->()
    
    var body: some View {
        Button(action: {
            callback(value, currentPIN)
        }, label: {
            VStack{
                if value.count > 1 {
                    Image(systemName: "delete.left.fill")
                        .font(.system(size: 24))
                        .foregroundColor(self.keyDeleteColor)
                        .frame(width: 60, height: 60)
                    
                } else {
                    Text(value)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color(hex: "#000000").opacity(0.6))
                        .clipShape(Circle())
                    
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            
        })
    }
}

struct NumbersPadView_Previews: PreviewProvider {
    static var previews: some View {
        NumbersPadView(previousPIN: "123", currentPIN: Binding.constant(""), unLocked: Binding.constant(false), wrongPin: Binding.constant(false)) {falseCount in
            
        }
    }
}
