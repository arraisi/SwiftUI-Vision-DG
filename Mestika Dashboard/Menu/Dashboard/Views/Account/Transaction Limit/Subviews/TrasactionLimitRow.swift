//
//  TrasactionLimitRow.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/05/21.
//

import SwiftUI

struct TrasactionLimitRow: View {
    
    var lable: String
    var min: Double
    @Binding var value: Double
//    @Binding var txtValue: String
    @Binding var max: Double
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(lable)
                    .font(.system(size: 14))
                Spacer()
            }
            
            TextField(String(format: "%.0f", min), value: $value, formatter: formatter)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal, 30)
            
            //            TextField(String(Int(min)), text: $txtValue)
            //                .multilineTextAlignment(.center)
            //                .textFieldStyle(RoundedBorderTextFieldStyle())
            //                .onChange(of: txtValue, perform: { value in
            //                    self.value = Double(value) ?? 0
            //                })
            //                .keyboardType(.numberPad)
            //                .padding(.horizontal, 30)
            
            Slider(value: $value, in: min...max)
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Min.")
                        .font(.system(size: 12))
                    Text(String(Int(min)).thousandSeparator())
                        .font(.system(size: 12))
                        .foregroundColor(Color("StaleBlue"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Max.")
                        .font(.system(size: 12))
                    Text(String(format: "%.0f", max).thousandSeparator())
                        .font(.system(size: 12))
                        .foregroundColor(Color("StaleBlue"))
                }
            }
            
            Divider()
            
        }
    }
    
}

struct TrasactionLimitRow_Previews: PreviewProvider {
    static var previews: some View {
        TrasactionLimitRow(lable: "Text", min: 10000, value: .constant(0), max: .constant(1000000))
    }
}
