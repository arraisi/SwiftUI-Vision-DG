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
                Text("Detail Limit Kartu ATM".localized(language))
                    .font(.custom("Montserrat-SemiBold", size: 15))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                RowLimitKartuAtmView(title: "ATM Card Limit Details".localized(language), value: card.description.limitPenarikanHarian)
                RowLimitKartuAtmView(title: "Daily Transfer".localized(language), value: card.description.limitTransferAntarSesama)
                RowLimitKartuAtmView(title: "Transfer ke Bank Lain".localized(language), value: card.description.limitTransferKeBankLain)
                RowLimitKartuAtmView(title: "Daily Withdrawals".localized(language).localized(language), value: card.description.limitPenarikanHarian)
                RowLimitKartuAtmView(title: "Payment".localized(language), value: card.description.limitPayment)
                RowLimitKartuAtmView(title: "Purchase".localized(language), value: card.description.limitPurchase)
            }
            
            NavigationLink(destination: FormPilihDesainATMView().environmentObject(atmData).environmentObject(registerData),
                           label: {
                            Text("CHOOSE THIS ATM CARD".localized(language))
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
