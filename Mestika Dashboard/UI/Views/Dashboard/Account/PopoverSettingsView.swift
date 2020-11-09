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
                HStack {
                    NavigationLink(destination: CardManagementScreen(), label: {
                        Text("Manajemen Kartu")
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    NavigationLink(destination: StatementScreen(), label: {
                        Text("e-Statement")
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    NavigationLink(destination: TransactionFeesScreen(), label: {
                        Text("Biaya Transaksi")
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    Toggle(isOn: $isFingerprint) {
                        Text("Aktifasi Fingerprint")
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    NavigationLink(destination: LanguageSettingScreen(), label: {
                        Text("Pengaturan Bahasa")
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    NavigationLink(destination: ChangePasswordOrPinSettingScreen(), label: {
                        Text("Ubah Password / PIN")
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    Button(action: {}, label: {
                        Text("Sign Out")
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .frame(width: .infinity, alignment: .top)
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 170)
            .padding(.leading, UIScreen.main.bounds.width / 4)
            .clipShape(PopupBubble(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
            
            Spacer()
        }
    }
}

struct PopoverSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverSettingsView()
    }
}
