//
//  ListPromoForYouView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct ListPromoForYouView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Just for you!".localized(language), comment: ""))
                    .font(.title3)
                    .fontWeight(.ultraLight)
                
                Spacer()
            }
            .padding([.leading, .trailing], 15)
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack{
                    Image("foryou-card-1")
                        .padding(.leading, 15)
                        .padding(.trailing, 20)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    
                    Image("foryou-card-2")
                        .padding(.trailing, 15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
            })
        }
    }
}

struct ListPromoForYouView_Previews: PreviewProvider {
    static var previews: some View {
        ListPromoForYouView()
    }
}
