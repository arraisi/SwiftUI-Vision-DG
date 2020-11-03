//
//  BottomNavigationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct BottomNavigationView: View {
    
    @State private var showingSlideMenu = false
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView {
                    DashboardTabs()
                        .tabItem {
                            Image("ic_dashboard")
                                .renderingMode(.template)
                            Text("Dashboard")
                        }.tag(1)
                    
                    TransferTabs()
                        .tabItem {
                            Image("ic_transfer")
                                .renderingMode(.template)
                            Text("Transfer")
                        }.tag(2)
                    
                    PaymentTransactionTabs()
                        .tabItem {
                            Image("ic_floating")
                        }.tag(3)
                    
                    FavoriteTabs()
                        .tabItem {
                            Image("ic_favorit")
                                .renderingMode(.template)
                            Text("Favorit")
                        }.tag(4)
                    
                    AccountTabs()
                        .tabItem {
                            Image("ic_akun")
                                .renderingMode(.template)
                            Text("Akun")
                        }.tag(5)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    var appbar: some View {
        HStack {
            Spacer()
            navBarItem
        }
    }
    
    var navBarItem: some View {
        HStack(spacing: 30) {
            Button(action: {}, label: {
                Image("ic_bell")
            })
            
            Button(action: {}, label: {
                Image("ic_qrcode")
            })
        }
    }
    
}

struct BottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView()
    }
}
