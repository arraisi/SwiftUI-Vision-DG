//
//  DetailKartuAktifView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct DetailKartuAktifView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    var card: KartuKuDesignViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            
            //            NavigationLink(
            //                destination: Text("Riwayat Transaksi"),
            //                label: {
            //                    HStack{
            //                        Image("ic_list")
            //                            .resizable()
            //                            .frame(width: 25, height: 25)
            //                        VStack(alignment: .leading){
            //                            Text("Riwayat Transaksi")
            //                                .font(.custom("Montserrat-SemiBold", size: 15))
            //                                .fixedSize(horizontal: false, vertical: true)
            //                                .foregroundColor(Color(hex: "#232175"))
            //
            //
            //                            Text("Riwayat transaksi pengunaan kartu")
            //                                .font(.custom("Montserrat-Light", size: 12))
            //                                .fixedSize(horizontal: false, vertical: true)
            //                                .foregroundColor(Color(hex: "#232175"))
            //                        }
            //                        Spacer()
            //                    }
            //                })
            //
                        NavigationLink(
                            destination: ListStatementView(),
                            label: {
                                HStack{
                                    Image("ic_list")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                    VStack(alignment: .leading){
                                        Text("e-Statement")
                                            .font(.custom("Montserrat-SemiBold", size: 15))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .foregroundColor(Color(hex: "#232175"))
            
            
                                        Text("Laporan keuangan bulanan")
                                            .font(.custom("Montserrat-Light", size: 12))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .foregroundColor(Color(hex: "#232175"))
                                    }
                                    Spacer()
                                }
                            })
            
            NavigationLink(
                destination: CardLimitView(card: card),
                label: {
                    HStack{
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text(NSLocalizedString("Transaction Limit".localized(language), comment: ""))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text(NSLocalizedString("Set card transaction limit".localized(language), comment: ""))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                })
            
            NavigationLink(
                destination: FormChangePinCardView(cardNo: .constant(card.cardNo)),
                label: {
                    HStack{
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text(NSLocalizedString("ATM PIN Settings".localized(language), comment: ""))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text(NSLocalizedString("Change ATM PIN / Reset ATM PIN".localized(language), comment: ""))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                })
            
            NavigationLink(
                destination: CardBlockView(card: card),
                label: {
                    HStack{
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text("Blokir Kartu")
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text("Blokir kartu sementara")
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                })
            
            NavigationLink(
                destination: CardDamageView(card: card),
                label: {
                    HStack{
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text(NSLocalizedString("Broken Card".localized(language), comment: ""))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text(NSLocalizedString("Report card damage".localized(language), comment: ""))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                })
            
        }
        .padding(.top, 25)
        .padding(.bottom, 10)
        .padding(20)
        .background(Color.white)
    }
}

//struct DetailKartuAktifView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailKartuAktifView(card: myCardData[0])
//            .previewLayout(PreviewLayout.fixed(width: UIScreen.main.bounds.width-60, height: 400))
//    }
//}
