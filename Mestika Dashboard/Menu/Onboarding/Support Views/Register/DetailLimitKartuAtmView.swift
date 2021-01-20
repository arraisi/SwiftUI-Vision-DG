//
//  DetailLimitKartuAtmView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/11/20.
//

import SwiftUI

struct DetailLimitKartuAtmView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    
    let card: ATMViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Detail Limit Kartu ATM", comment: ""))
                    .font(.custom("Montserrat-SemiBold", size: 15))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                RowLimitKartuAtmView(title: NSLocalizedString("Penarikan Harian", comment: ""), value: card.description.limitPenarikanHarian)
                RowLimitKartuAtmView(title: NSLocalizedString("Transfer Antar Sesama Bank Mestika", comment: ""), value: card.description.limitTransferAntarSesama)
                RowLimitKartuAtmView(title: NSLocalizedString("Transfer ke Bank Lain", comment: ""), value: card.description.limitTransferKeBankLain)
                RowLimitKartuAtmView(title: NSLocalizedString("Penarikan Harian", comment: ""), value: card.description.limitPenarikanHarian)
                RowLimitKartuAtmView(title: NSLocalizedString("Payment", comment: ""), value: card.description.limitPayment)
                RowLimitKartuAtmView(title: NSLocalizedString("Purchase", comment: ""), value: card.description.limitPurchase)
            }
            
            NavigationLink(destination: FormPilihDesainATMView().environmentObject(atmData).environmentObject(registerData),
                           label: {
                            Text(NSLocalizedString("PILIH KARTU ATM INI", comment: ""))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 40)
                           })
                .frame(height: 50)
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.horizontal)
            
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
