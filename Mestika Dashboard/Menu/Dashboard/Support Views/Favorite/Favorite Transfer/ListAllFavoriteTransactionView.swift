//
//  ListAllFavoriteTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListAllFavoriteTransactionView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    //    var action: ((FavoritModelElement) -> Void)?
    @State private var activeDetails: Bool = false
    
    @State private var showingDetail = false
    
    @StateObject private var favoritVM = FavoritViewModel()
    
    var cardNo: String = ""
    var sourceNumber: String = ""
    
    @State var isRouteOnUs: Bool = false
    @State var isRouteOffUs: Bool = false
    
    @State var transferDataOnUs = TransferOnUsModel()
    @State var transferDataOffUs = TransferOffUsModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text(NSLocalizedString("Transfer Favorites".localized(language), comment: ""))
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
                NavigationLink(
                    destination: TransferOnUsScreen().environmentObject(transferDataOnUs),
                    isActive: self.$isRouteOnUs,
                    label: {EmptyView()}
                )
                .isDetailLink(false)
                
                NavigationLink(
                    destination: TransferRtgsScreen().environmentObject(transferDataOffUs),
                    isActive: self.$isRouteOffUs,
                    label: {EmptyView()}
                )
                .isDetailLink(false)
                
                List(self.favoritVM.favorites, id: \.id) { data in
//                    NavigationLink(
//                        destination: LastFavoriteTransferScreen(data: data),
//                        label: {
//                            Button(action: {
//                                // self.action!(data)
//                            }, label: {
//                                HStack {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color.secondary)
//                                            .frame(width: 30, height: 30)
//
//                                        Text(data.name.prefix(1))
//                                            .foregroundColor(.white)
//                                            .fontWeight(.heavy)
//                                    }
//
//                                    VStack(alignment: .leading) {
//                                        Text("\(data.name)")
//                                            .font(.custom("Montserrat-SemiBold", size: 14))
//
//                                        HStack {
//                                            Text("\(data.bankName) :")
//                                                .font(.custom("Montserrat-Light", size: 14))
//                                            Text("\(data.sourceNumber)")
//                                                .font(.custom("Montserrat-Light", size: 14))
//                                        }
//                                    }
//                                    Spacer()
//                                }
//                            })
//                        })
//                        .padding(.vertical, 5)
                    HStack {
                        
                        Button(
                            action: {
                                if (data.type == "TRANSFER_SESAMA") {
                                    self.isRouteOnUs = true
                                } else {
                                    self.isRouteOffUs = true
                                }
                            },
                            label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.secondary)
                                        .frame(width: 30, height: 30)
                                    
                                    Text(data.name.prefix(1))
                                        .foregroundColor(.white)
                                        .fontWeight(.heavy)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(data.name)")
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                    
                                    HStack {
                                        Text("\(data.bankName) : \(data.sourceNumber)")
                                            .font(.custom("Montserrat-Light", size: 14))
                                    }
                                }
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            self.showingDetail = true
                        }, label: {
                            Image(systemName: "ellipsis")
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
                .listStyle(PlainListStyle())
                .colorMultiply(Color(hex: "#F6F8FB"))
                .frame(height: 500)
            }
            .frame(width: UIScreen.main.bounds.width - 10)
        }
        .onAppear(perform: getList)
        .actionSheet(isPresented: self.$showingDetail) {
            ActionSheet(title: Text(NSLocalizedString("Selection".localized(language), comment: "")), message: Text(NSLocalizedString("Select the menu below".localized(language), comment: "")), buttons: [.default(Text(NSLocalizedString("Delete".localized(language), comment: "")), action: {
                print(NSLocalizedString("Delete".localized(language), comment: ""))
                
//                self.favoritVM.remove(data: data) { result in
//                    print("result remove favorite \(result)")
//                    if result {
//                        
//                    }
//                }
            })])
        }
    }
    
    func getList() {
        self.favoritVM.getList(cardNo: self.cardNo, sourceNumber: self.sourceNumber, completion: { result in
            print(result)
        })
    }
}

struct ListAllFavoriteTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListAllFavoriteTransactionView()
    }
}
