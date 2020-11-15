//
//  DetailLimitKartuAtmView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/11/20.
//

import SwiftUI

struct DetailLimitKartuAtmView: View {
    
    let card: MyCard
    
    var body: some View {
        VStack {
            HStack {
                Text("Detail Limit Kartu ATM")
                    .font(.custom("Montserrat-SemiBold", size: 15))
                
                Spacer()
            }
            .padding()
            .padding(.top, 20)
            
            ForEach(card.limits) {limit in
                RowLimitKartuAtmView(title: limit.title, value: limit.value)
            }
            
            NavigationLink(destination: PilihDesainATMView(),
                label: {
                    Text("PILIH KARTU ATM INI")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                })
                .frame(height: 50)
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.vertical, 20)
            
        }
        .padding()
        .background(Color.white)
        .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
    }
}

struct DetailLimitKartuAtmView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLimitKartuAtmView(card: myCardData[0])
    }
}
