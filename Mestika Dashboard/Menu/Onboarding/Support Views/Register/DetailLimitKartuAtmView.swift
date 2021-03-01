//
//  DetailLimitKartuAtmView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/11/20.
//

import SwiftUI

struct DetailLimitKartuAtmView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    
    let card: ATMViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Detail Limit Kartu ATM".localized(language), comment: ""))
                    .font(.custom("Montserrat-SemiBold", size: 15))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                RowLimitKartuAtmView(title: NSLocalizedString("ATM Card Limit Details".localized(language), comment: ""), value: card.description.limitPenarikanHarian)
                RowLimitKartuAtmView(title: NSLocalizedString("Daily Transfer".localized(language), comment: ""), value: card.description.limitTransferAntarSesama)
                RowLimitKartuAtmView(title: NSLocalizedString("Transfer ke Bank Lain".localized(language), comment: ""), value: card.description.limitTransferKeBankLain)
                RowLimitKartuAtmView(title: NSLocalizedString("Daily Withdrawals".localized(language).localized(language), comment: ""), value: card.description.limitPenarikanHarian)
                RowLimitKartuAtmView(title: NSLocalizedString("Payment".localized(language), comment: ""), value: card.description.limitPayment)
                RowLimitKartuAtmView(title: NSLocalizedString("Purchase".localized(language), comment: ""), value: card.description.limitPurchase)
            }
            
            NavigationLink(destination: FormPilihDesainATMView().environmentObject(atmData).environmentObject(registerData),
                           label: {
                            Text(NSLocalizedString("CHOOSE THIS ATM CARD".localized(language), comment: ""))
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
