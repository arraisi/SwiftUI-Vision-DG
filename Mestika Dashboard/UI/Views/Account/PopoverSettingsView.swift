//
//  PopoverSettingsView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct PopoverSettingsView: View {
    
    @State private var isFingerprint = false
    
    @State private var textHeight: Double = 20
    let listRowPadding: Double = 20
    let listRowMinHeight: Double = 45
    var listRowHeight: Double {
        max(listRowMinHeight, textHeight + 2 * listRowPadding)
    }
    
    var _listMenu = [
        SettingMenu(id: 1, namaMenu: "Manajemen Kartu"),
        SettingMenu(id: 2, namaMenu: "e-Statement"),
        SettingMenu(id: 3, namaMenu: "Biaya Transaksi"),
        SettingMenu(id: 4, namaMenu: "Aktifasi Fingerprint"),
        SettingMenu(id: 5, namaMenu: "Pengaturan Bahasa"),
        SettingMenu(id: 6, namaMenu: "Ubah Password / PIN"),
        SettingMenu(id: 7, namaMenu: "Sign Out"),
    ]
    
    var body: some View {
        VStack {
            VStack {
                List {
                    ForEach(_listMenu, id: \.self) { item in
                        VStack {
                            if (item.id == 1) {
                                NavigationLink(destination: CardManagementScreen(), label: {
                                    Text(item.namaMenu)
                                        .fontWeight(.light)
                                        .frame(height: CGFloat(self.textHeight))
                                        .foregroundColor(Color(hex: "#002251"))
                                })
                            }

                            if (item.id == 2) {
                                NavigationLink(destination: StatementScreen(), label: {
                                    Text(item.namaMenu)
                                            .fontWeight(.light)
                                            .frame(height: CGFloat(self.textHeight))
                                            .foregroundColor(Color(hex: "#002251"))
                                })
                            }

                            if (item.id == 3) {
                                NavigationLink(destination: TransactionFeesScreen(), label: {
                                    Text(item.namaMenu)
                                            .fontWeight(.light)
                                            .frame(height: CGFloat(self.textHeight))
                                            .foregroundColor(Color(hex: "#002251"))
                                })
                            }

                            if (item.id == 4) {
                                HStack {

                                    Toggle(isOn: $isFingerprint) {
                                        Text(item.namaMenu)
                                            .fontWeight(.light)
                                            .frame(height: CGFloat(self.textHeight))
                                            .foregroundColor(Color(hex: "#002251"))
                                    }

                                }
                            }

                            if (item.id == 5) {
                                NavigationLink(destination: LanguageSettingScreen(), label: {
                                    Text(item.namaMenu)
                                            .fontWeight(.light)
                                            .frame(height: CGFloat(self.textHeight))
                                            .foregroundColor(Color(hex: "#002251"))
                                })
                            }

                            if (item.id == 6) {
                                NavigationLink(destination: ChangePasswordOrPinSettingScreen(), label: {
                                    Text(item.namaMenu)
                                            .fontWeight(.light)
                                            .frame(height: CGFloat(self.textHeight))
                                            .foregroundColor(Color(hex: "#002251"))
                                })
                            }

                            if (item.id == 7) {
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Text(item.namaMenu)
                                        .fontWeight(.light)
                                        .frame(height: CGFloat(self.textHeight))
                                        .foregroundColor(Color(hex: "#002251"))
                                })
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
                .frame(height: CGFloat(_listMenu.count) * CGFloat(self.listRowHeight))
            }
            .frame(width: .infinity, alignment: .top)
            .background(Color.white)
            .cornerRadius(radius: 15, corners: [.topLeft, .bottomLeft])
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 60)
            .padding(.leading, UIScreen.main.bounds.width / 4)
            
            Spacer()
        }
    }
}

struct PopoverSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverSettingsView()
    }
}
