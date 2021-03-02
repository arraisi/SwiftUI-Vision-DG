//
//  GridMenuView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct GridMenuView: View {
    
    @Binding var cardNo: String
    @Binding var sourceNumber: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                
                Group {
                    NavigationLink(destination: FavoriteTabs(cardNo: self.$cardNo, sourceNumber: self.$sourceNumber), label: {
                        Image("ic_menu_favorite")
                        .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    })
                    
                    Button(action: {}, label: {
                        Image("ic_menu_tarik_tunai")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        Image("ic_menu_tarik_tunai")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        Image("ic_menu_tambah_saldo")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                }
                
                Button(action: {}, label: {
                    Image("ic_menu_pindah_saldo")
                })
                .shadow(color: Color.gray.opacity(0.3), radius: 2)
                
                Button(action: {}, label: {
                    Image("ic_menu_deposito_online")
                })
                .shadow(color: Color.gray.opacity(0.3), radius: 2)
                
                Button(action: {}, label: {
                    Image("ic_menu_tabka")
                })
                .shadow(color: Color.gray.opacity(0.3), radius: 2)
                
                Button(action: {}, label: {
                    Image("ic_menu_minimum")
                })
                .shadow(color: Color.gray.opacity(0.3), radius: 2)
                
                Button(action: {}, label: {
                    Image("ic_menu_limit_transaksi")
                })
                .shadow(color: Color.gray.opacity(0.3), radius: 2)
                
                Button(action: {}, label: {
                    Image("ic_menu_rekening")
                })
                .shadow(color: Color.gray.opacity(0.3), radius: 2)
                
                Button(action: {}, label: {
                    Image("ic_menu_unfreeze_account")
                })
                .shadow(color: Color.gray.opacity(0.3), radius: 2)
            }
            .padding([.leading, .trailing], 15)
        })
    }
}

struct GridMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GridMenuView(cardNo: .constant(""), sourceNumber: .constant(""))
    }
}
