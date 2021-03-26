//
//  ChooseAccountQrisView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/03/21.
//

import SwiftUI

struct ChooseAccountQrisView: View {
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Pilih rekening sumber untuk melakukan transaksi".localized(language))
                        .font(.custom("Montserrat-Bold", size: 16))
                }
                Spacer()
            }
            .padding([.top, .horizontal], 30)
            
            ForEach(myCardData, id: \.self) { item in
                NavigationLink(
                    destination: SummaryQrisView(),
                    label: {
                        ZStack {
                            Image(item.imageName)
                            
                            Text("Account Name")
                        }
                        .foregroundColor(.white)
                        .padding(5)
                    })
            }
        }
        .navigationBarTitle("Pembayaran QRIS", displayMode: .inline)
    }
}

struct ChooseAccountQrisView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAccountQrisView()
    }
}
