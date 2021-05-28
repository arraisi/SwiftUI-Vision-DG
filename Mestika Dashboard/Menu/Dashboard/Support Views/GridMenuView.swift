//
//  GridMenuView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct GridMenuView: View {
    
    @EnvironmentObject var appState: AppState
    
    @Binding var cardNo: String
    @Binding var sourceNumber: String
    
    @State private var savingAccountActive: Bool = false
    @State private var moveBalancesActive: Bool = false
    @State private var addBalancesActive: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            
            NavigationLink(
                destination: SavingAccountView(),
                isActive: $savingAccountActive,
                label: { EmptyView() }
            )
            .isDetailLink(false)
            
            NavigationLink(
                destination: DestinationAccountBalancesView(),
                isActive: $moveBalancesActive,
                label: { EmptyView() }
            )
            
            NavigationLink(
                destination: DestinationAccountAddBalanceView(),
                isActive: $addBalancesActive,
                label: { EmptyView() }
            )
            .isDetailLink(false)
            
            HStack {
                
                Group {
                    
                    NavigationLink(destination: FavoriteTabs(cardNo: self.$cardNo, sourceNumber: self.$sourceNumber), label: {
                        RoundedIconLabel(imageName: "ic_favorite", label: "Favorite")
                    })
                    
                    Button(action: {
                        self.savingAccountActive = true
                    }, label: {
                        RoundedIconLabel(imageName: "ic_rekening", label: "Saving Account")
                    })
                    
                    Button(action: {}, label: {
                        RoundedIconLabel(imageName: "ic_tarik_tunai", label: "Tarik Tunai")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        RoundedIconLabel(imageName: "ic_setor_tunai", label: "Setor Tunai")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {
                        self.addBalancesActive = true
                    }, label: {
                        Image("ic_menu_tambah_saldo")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {
                        self.moveBalancesActive = true
                    }, label: {
                        Image("ic_menu_pindah_saldo")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                }
                
                Group {
                    
                    Button(action: {}, label: {
                        Image("ic_menu_deposito_online")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        Image("ic_menu_tabka")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        Image("ic_menu_minimum")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        Image("ic_menu_limit_transaksi")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        Image("ic_menu_rekening")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                    Button(action: {}, label: {
                        Image("ic_menu_unfreeze_account")
                    })
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                    
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 15)
        })
        .onReceive(self.appState.$moveToDashboard) { value in
            if value {
                //                getCoreDataNewDevice()
                print("Move to moveToDashboard: \(value)")
                //                activateWelcomeView()
                self.savingAccountActive = false
                self.moveBalancesActive = false
                self.addBalancesActive = false
                self.appState.moveToDashboard = false
            }
        }
    }
}

struct GridMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GridMenuView(cardNo: .constant(""), sourceNumber: .constant(""))
            .previewLayout(PreviewLayout.fixed(width:  UIScreen.main.bounds.width, height: 80))
    }
}
