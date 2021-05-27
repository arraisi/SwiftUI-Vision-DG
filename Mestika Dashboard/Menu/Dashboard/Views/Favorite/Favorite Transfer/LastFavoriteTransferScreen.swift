//
//  LastFavoriteTransferScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI
import Introspect

struct LastFavoriteTransferScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var favoritVM = FavoritViewModel()
    
    @State private var isLoading: Bool = false
    
    @State private var name: String = ""
    @State private var nameTextFieldDisabled: Bool = true
    
    var data: FavoritModelElement
    
    var body: some View {
        
        LoadingView(isShowing: self.$isLoading) {
            
            ZStack {
                Color(hex: "#F6F8FB")
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            
                            TextField("Name".localized(language), text: $name).introspectTextField { textField in
                                textField.becomeFirstResponder()
                            }
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Bold", size: 28))
                            .padding(.bottom, 5)
                            .textCase(.uppercase)
                            .lineLimit(2)
                            .disabled(nameTextFieldDisabled)
                            
                            HStack {
//                                Text("\(data.bankName) :")
//                                    .foregroundColor(.white)
//                                    .font(.caption)
//                                    .fontWeight(.light)
                                
                                Text("\(data.cardNo)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .fontWeight(.light)
                            }
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                if !nameTextFieldDisabled {
                                    
                                    self.isLoading.toggle()
                                    
                                    self.favoritVM.update(data: data, name: self.name) { result in
                                        self.nameTextFieldDisabled.toggle()
                                        self.isLoading.toggle()
                                    }
                                    
                                } else {self.nameTextFieldDisabled.toggle()}
                                
                            }) {
                                if nameTextFieldDisabled {
                                    Image("ic_edit")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image("ic_checked")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.gray)
                                        .frame(width: 25, height: 25)
                                }
                            }
                            
                            Button(action: {
                                self.isLoading.toggle()
                                self.favoritVM.remove(data: data) { result in
                                    print("result remove favorite \(result)")
                                    if result {
                                        DispatchQueue.main.async {
                                            presentationMode.wrappedValue.dismiss()
                                            self.isLoading.toggle()
                                        }
                                    }
                                }
                            }, label: {
                                Image("ic_trash")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            })
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 30)
                    }
                    .padding(.vertical, 20)
                    .background(Color(hex: "#232175"))
                    
//                        ListLastTransactionView()
//                            .padding(.vertical)
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {}, label: {
                            Text("Lakukan Transfer".localized(language))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            
                        })
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    }
                    .padding(.bottom)
                }
                .navigationBarTitle("", displayMode: .inline)
            }
            .onAppear {
                self.name = data.name ?? ""
            }
            
        }
    }
}

//#if DEBUG
//struct LastFavoriteTransferScreen_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let data = FavoritModelElement
//
//        LastFavoriteTransferScreen(dataFavorit: .constant(data))
//    }
//}
//#endif
