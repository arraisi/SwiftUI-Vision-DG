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
//        ScrollView(.vertical, showsIndicators: false, content: {
            
//            GeometryReader { geometry in
//                Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
//                    .frame(height: 0)
//            }
            
            VStack {
                titleInfo
                
//                ListFavoritePurchasePaymentView()
//                    .padding()
                
                ListFavoriteTransactionView(cardNo: self.cardNo, sourceNumber: self.sourceNumber)
                    .padding()
                    .frame(height: 400)
                
                Spacer()
            }
//        })
            .navigationBarTitle("Favorit", displayMode: .inline)
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
            
//            Button(action: {}, label: {
//                Image("ic_search")
//            })
        }
        .padding()
    }
}

struct FavoriteTabs_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTabs(cardNo: .constant(""), sourceNumber: .constant(""))
    }
}
