//
//  BottomNavigationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct BottomNavigationView: View {
    
    @State private var showingSlideMenu = false
    @State private var showingSettingMenu = false
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        ZStack {
            VStack {
                appbar
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
                    
                    AccountTabs(showingSettingMenu: self.$showingSettingMenu)
                        .tabItem {
                            Image("ic_akun")
                                .renderingMode(.template)
                            Text("Akun")
                        }.tag(5)
                }
            }
            
            if (showingSettingMenu) {
                ModalOverlay(tapAction: { withAnimation { self.showingSettingMenu = false } })
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            
            if showingSettingMenu {
                withAnimation {
                    PopoverSettingsView()
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    var appbar: some View {
        VStack {
            HStack {
                Spacer()
                navBarItem
            }
        }
        .padding(.top, 30)
        .padding(.bottom, 10)
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
        .padding(.horizontal)
    }
    
}

class BottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView()
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: BottomNavigationView())
    }
    #endif
}
