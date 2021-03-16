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
    
    @State private var isRouteStatement: Bool = false
    @State private var isRouteTrxLimit: Bool = false
    @State private var isRouteChangePin: Bool = false
    @State private var isRouteBlockCard: Bool = false
    @State private var isRouteBrokenCard: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            
            Button(
                action: {
                    self.isRouteStatement = true
                },
                label: {
                    HStack {
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text("e-Statement")
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))


                            Text("Monthly financial reports".localized(language))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                }
            )
            
            Button(
                action: {
                    self.isRouteTrxLimit = true
                },
                label: {
                    HStack{
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text("Transaction Limit".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text("Set card transaction limit".localized(language))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                }
            )
            
            Button(
                action: {
                    self.isRouteChangePin = true
                },
                label: {
                    HStack {
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text("ATM PIN Settings".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text("Change ATM PIN / Reset ATM PIN".localized(language))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                }
            )
            
            Button(
                action: {
                    self.isRouteBlockCard = true
                },
                label: {
                    HStack {
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text("Block card".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text("Temporary Block Cards".localized(language))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                }
            )
            
            Button(
                action: {
                    self.isRouteBrokenCard = true
                },
                label: {
                    HStack {
                        Image("ic_list")
                            .resizable()
                            .frame(width: 25, height: 25)
                        VStack(alignment: .leading){
                            Text("Broken Card".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                            
                            
                            Text("Report card damage".localized(language))
                                .font(.custom("Montserrat-Light", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color(hex: "#232175"))
                        }
                        Spacer()
                    }
                }
            )
            
            NavigationLink(
                destination: ListStatementView(),
                isActive: self.$isRouteStatement,
                label: {EmptyView()}
            )
            
            NavigationLink(
                destination: CardLimitView(card: card),
                isActive: self.$isRouteTrxLimit,
                label: {EmptyView()}
            )
            
            NavigationLink(
                destination: FormChangePinCardView(cardNo: .constant(card.cardNo)),
                isActive: self.$isRouteChangePin,
                label: {EmptyView()}
            )
            
            NavigationLink(
                destination: CardBlockView(card: card),
                isActive: self.$isRouteBlockCard,
                label: {}
            )
            .isDetailLink(false)
            
            NavigationLink(
                destination: CardDamageView(card: card),
                isActive: self.$isRouteBrokenCard,
                label: {EmptyView()}
            )
            .isDetailLink(false)
            
        }
        .onAppear {
            self.isRouteBlockCard = false
            self.isRouteBrokenCard = false
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
