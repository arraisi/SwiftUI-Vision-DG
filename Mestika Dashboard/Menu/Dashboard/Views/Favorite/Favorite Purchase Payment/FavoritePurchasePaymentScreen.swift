//
//  FavoritePurchasePaymentScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI
import Combine

struct FavoritePurchasePaymentScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var searchCtrl = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        searchCard
                        
                        ListAllFavoritePurchasePaymentView() { data in
                            print(data.id)
                        }
                        .padding(.bottom)
                    }
                    .padding(.bottom, 25)
                })
            }
            .navigationBarTitle("Favorit Purchase".localized(language), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {}, label: {
                Text("Cancel".localized(language))
            }))
        }
    }
    
    var searchCard: some View {
        HStack {
            HStack {
                TextField("Search for Transfer contacts".localized(language), text: $searchCtrl, onEditingChanged: { changed in
                    print("\($searchCtrl)")
                })
                .onReceive(Just(searchCtrl)) { newValue in
                    let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
                    if filtered != newValue {
                        self.searchCtrl = filtered
                    }
                }
                
                Image("ic_search")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
            }
            .keyboardType(.numberPad)
            .frame(height: 10)
            .font(.subheadline)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding(.leading, 20)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("ic_fillter")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
            })
            .frame(height: 10)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding(.trailing, 20)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .padding(.top)
        .padding([.bottom, .top], 20)
    }
}

struct FavoritePurchasePaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePurchasePaymentScreen()
    }
}
