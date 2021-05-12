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
    @Binding var txtValue: String
    @Binding var max: Double
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(lable)
                    .font(.system(size: 14))
                Spacer()
            }
            
            //            TextField(String(format: "%.0f", min), value: $value, formatter: formatter)
            //                .multilineTextAlignment(.center)
            //                .textFieldStyle(RoundedBorderTextFieldStyle())
            //                .keyboardType(.numberPad)
            //                .padding(.horizontal, 30)
            
            TextField(String(format: "%.0f", min), text: $txtValue)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: txtValue, perform: { value in
                    self.txtValue = value.thousandSeparator()
                    self.value = Double(value.replacingOccurrences(of: ".", with: "")) ?? 0
                    
                    if (Double(value.replacingOccurrences(of: ".", with: "")) ?? 0 > max) {
                        self.txtValue = String(max).thousandSeparator()
                        self.value = max / 10
                    }
                })
                .keyboardType(.numberPad)
                .padding(.horizontal, 30)
            
            Slider(value: $value, in: min...max)
                .onChange(of: value) { v in
                    txtValue = String(format: "%.0f", value.rounded(toPlaces: 0)).thousandSeparator()
                }
            
            
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
        TrasactionLimitRow(lable: "Text", min: 10000, value: .constant(0), txtValue: .constant("100000"), max: .constant(1000000))
    }
}
