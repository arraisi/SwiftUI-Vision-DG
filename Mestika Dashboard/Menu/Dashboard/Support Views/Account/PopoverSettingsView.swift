//
//  PopoverSettingsView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct PopoverSettingsView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @EnvironmentObject var appState: AppState
    /* Data Binding */
    @ObservedObject private var authVM = AuthViewModel()
    @State private var isFingerprint = false
    
    @State private var textHeight: Double = 20
    let listRowPadding: Double = 20
    let listRowMinHeight: Double = 45
    var listRowHeight: Double {
        max(listRowMinHeight, textHeight + 2 * listRowPadding)
    }
    
    var _listMenu = [
        SettingMenu(id: 1, namaMenu: "Card Management".localized(LocalizationService.shared.language)),
        SettingMenu(id: 2, namaMenu: "e-Statement"),
        SettingMenu(id: 3, namaMenu: "Transaction Fee".localized(LocalizationService.shared.language)),
        SettingMenu(id: 4, namaMenu: "Fingerprint Activation".localized(LocalizationService.shared.language)),
        SettingMenu(id: 5, namaMenu: "Language setting".localized(LocalizationService.shared.language)),
        SettingMenu(id: 6, namaMenu: "Change Password / PIN".localized(LocalizationService.shared.language)),
        SettingMenu(id: 7, namaMenu: "Sign Out"),
    ]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    NavigationLink(destination: CardManagementScreen(), label: {
                        Text("Card Management".localized(language))
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
                        Text("Transaction Fee".localized(language))
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
                        Text("Fingerprint Activation".localized(language))
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    NavigationLink(destination: LanguageSettingScreen(), label: {
                        Text("Language setting".localized(language))
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
                        Text("Change Password / PIN".localized(language))
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    Button(action: {
                        self.authVM.postLogout { success in
                            if success {
                                self.appState.moveToWelcomeView = true
                            }
                        }
                    }, label: {
                        Text("Sign Out")
                            .fontWeight(.light)
                            .foregroundColor(Color(hex: "#002251"))
                            .frame(height: CGFloat(self.textHeight))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .frame(width: .infinity, alignment: .top)
            .background(Color.white)
            .cornerRadius(radius: 15, corners: [.topLeft, .bottomLeft])
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 170)
            .padding(.leading, UIScreen.main.bounds.width / 4)
            
            Spacer()
        }
    }
}

struct PopoverSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverSettingsView().environmentObject(AppState())
    }
}
