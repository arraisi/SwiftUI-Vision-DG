//
//  DetailLimitKartuAtmView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/11/20.
//

import SwiftUI

struct RowLimitKartuAtmView: View {
    var title: String = ""
    var value: String = ""
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Text(title)
                        .font(.custom("Montserrat-Light", size: 12))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Rp")
                        .font(.custom("Montserrat-Bold", size: 12))
                        .foregroundColor(Color(hex: "#232175"))
                    Text(value)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .foregroundColor(Color(hex: "#232175"))
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
            }
            
            
        }
    }
}

struct RowLimitKartuAtmView_Previews: PreviewProvider {
    static var previews: some View {
        RowLimitKartuAtmView(title: "title", value: "0.00")
    }
}
