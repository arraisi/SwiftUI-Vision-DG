//
//  FavoriteScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct FavoriteTabs: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var cardNo: String
    @Binding var sourceNumber: String
    
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            titleInfo
            
            ListFavoriteTransactionView(cardNo: self.cardNo, sourceNumber: self.sourceNumber)
                .padding()
                .frame(height: 400)
            
            Spacer()
        }
        .navigationBarTitle("Favorite".localized(language), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                        Text("Back".localized(language))
                                            .foregroundColor(.white)
                                    }
                                })
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
    }
    
    // MARK: -USERNAME INFO VIEW
    var titleInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Favorite".localized(language))
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("The following is a list of transactions that you have saved in the favorites menu".localized(language))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FavoriteTabs_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTabs(cardNo: .constant(""), sourceNumber: .constant(""))
    }
}
