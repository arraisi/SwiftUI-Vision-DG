//
//  DetailKartuTidakAktifView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct DetailKartuTidakAktifView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    var card: KartuKuDesignViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            HStack {
                Image("credit-card-locked")
                
                Spacer()
            }
            
            HStack {
                Text("Inactive Account Card".localized(language))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#232175"))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            
            HStack {
                Text("Activate your card first to see the settings.".localized(language))
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(Color(hex: "#232175"))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            if (card.status == "BLOCKED") {
                EmptyView()
            } else {
                NavigationLink(
                    destination: CardActivationView(card: card),
                    label: {
                        Text("ACTIVATE MY CARDS".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    })
                    .frame(height: 50)
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
            }
            
        }
        .padding(.top, 35)
        .padding(20)
        .background(Color.white)
    }
}

//struct DetailKartuTidakAktifView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailKartuTidakAktifView(card: myCardData[0])
//            .previewLayout(PreviewLayout.fixed(width: UIScreen.main.bounds.width, height: 400))
//            .environment(\.colorScheme, .dark)
//    }
//}
