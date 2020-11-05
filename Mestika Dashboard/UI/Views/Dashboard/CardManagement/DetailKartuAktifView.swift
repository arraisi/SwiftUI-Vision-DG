//
//  DetailKartuAktifView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct DetailKartuAktifView: View {
    var data: MyCard
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            
            ForEach(0..<data.details.count) {i in
                HStack {
                    Image("ic_list")
                        .resizable()
                        .frame(width: 25, height: 25)
                    
                    VStack(alignment: .leading){
                        Text(data.details[i].name)
                            .font(.custom("Montserrat-SemiBold", size: 15))
                            .fixedSize(horizontal: false, vertical: true)
//                            .foregroundColor(Color(hex: "#232175"))
                        
                        
                        Text(data.details[i].description)
                            .font(.custom("Montserrat-Light", size: 10))
                            .fixedSize(horizontal: false, vertical: true)
//                            .foregroundColor(Color(hex: "#232175"))
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.top, 15)
        .padding(30)
        .background(Color.white)
    }
}

struct DetailKartuAktifView_Previews: PreviewProvider {
    static var previews: some View {
        DetailKartuAktifView(data: myCardData[0])
            .previewLayout(PreviewLayout.fixed(width: UIScreen.main.bounds.width-60, height: 400))
    }
}
