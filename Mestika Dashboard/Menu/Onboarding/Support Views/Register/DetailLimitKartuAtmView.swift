//
//  DetailLimitKartuAtmView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/11/20.
//

import SwiftUI

struct DetailLimitKartuAtmView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    
    let card: ATMViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Detail Limit Kartu ATM")
                    .font(.custom("Montserrat-SemiBold", size: 15))
                
                Spacer()
            }
            .padding()
            .padding(.top, 20)
            
            RowLimitKartuAtmView(title: "Penarikan Harian", value: card.description.limitPenarikanHarian)
            RowLimitKartuAtmView(title: "Transfer Antar Sesama Bank Mestika", value: card.description.limitTransferAntarSesama)
            RowLimitKartuAtmView(title: "Transfer ke Bank Lain", value: card.description.limitTransferKeBankLain)
            RowLimitKartuAtmView(title: "Penarikan Harian", value: card.description.limitPenarikanHarian)
            RowLimitKartuAtmView(title: "Payment", value: card.description.limitPayment)
            RowLimitKartuAtmView(title: "Purchase", value: card.description.limitPurchase)
            
            NavigationLink(destination: FormPilihDesainATMView().environmentObject(atmData),
                label: {
                    Text("PILIH KARTU ATM INI")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                })
                .frame(height: 50)
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.vertical, 20)
            
        }
        .padding()
        .background(Color.white)
        .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
    }
}

struct DetailLimitKartuAtmView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLimitKartuAtmView(card: ATMViewModel(id: "1", key: "1", title: "Test", cardImage: URL(string: "")!, description: ATMDescriptionModel(limitPurchase: "0", limitPayment: "0", limitPenarikanHarian: "0", limitTransferKeBankLain: "0", limitTransferAntarSesama: "0", codeClass: "0")))
    }
}
