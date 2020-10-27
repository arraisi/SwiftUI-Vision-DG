//
//  SIdemenuCell.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/10/20.
//

import SwiftUI

#if DEBUG
let menuMyAccount = SideMenuContent(name: "My Account", image: "ic_akun")
let menuMyCard = SideMenuContent(name: "Kartu-Ku", image: "ic_credit_card")
let menuVoucher = SideMenuContent(name: "Voucher", image: "ic_bookmark")
let menuPendingTransaction = SideMenuContent(name: "Transaksi Tunda", image: "ic_calendar")
let menuListFavorite = SideMenuContent(name: "Daftar Favorit", image: "ic_pin")
let menuContactUs = SideMenuContent(name: "Hubungi Kami", image: "ic_chat")
let menuLogOut = SideMenuContent(name: "Log Out", image: "ic_exit")

let sideMenuContent = [menuMyAccount, menuMyCard, menuVoucher, menuPendingTransaction, menuListFavorite, menuContactUs, menuLogOut]

struct SidemenuCell: View {
    var sideItem: SideMenuContent = sideMenuContent[0]
    var body: some View {
        HStack {
            Image(sideItem.image)
            Text(sideItem.name)
                .foregroundColor(.white)
                .fontWeight(.light)
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
    }
}
#endif

struct SidemenuCell_Previews: PreviewProvider {
    static var previews: some View {
        SidemenuCell()
    }
}
