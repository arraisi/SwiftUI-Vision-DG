//
//  GridMenuView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct GridMenuView: View {
    
    let gridItems = [
        GridItem(.fixed(80), spacing: 5),
        GridItem(.fixed(80), spacing: 5),
        GridItem(.fixed(80), spacing: 5),
        GridItem(.fixed(80), spacing: 5)
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItems, alignment: .center, spacing: 20) {
            Button(action: {}, label: {
                Image("ic_menu_tarik_tunai")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_tarik_tunai")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_tambah_saldo")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_pindah_saldo")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_deposito_online")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_tabka")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_minimum")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_limit_transaksi")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_rekening")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {}, label: {
                Image("ic_menu_unfreeze_account")
            })
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
    }
}

struct GridMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GridMenuView()
    }
}
