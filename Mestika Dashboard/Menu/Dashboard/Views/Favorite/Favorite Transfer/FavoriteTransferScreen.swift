//
//  FavoriteTransferScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct FavoriteTransferScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var cardNo: String = ""
    var sourceNumber: String = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack {
                ListAllFavoriteTransactionView(cardNo: self.cardNo, sourceNumber: self.sourceNumber)
//                    .padding(.bottom)
//                    .padding(.bottom, 25)
            }
            .navigationBarTitle("Transfer Favorites".localized(language), displayMode: .inline)
            
        }
    }
}

struct FavoriteTransferScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTransferScreen()
    }
}
