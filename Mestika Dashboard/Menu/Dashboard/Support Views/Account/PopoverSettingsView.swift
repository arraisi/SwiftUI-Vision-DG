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
        SettingMenu(id: 1, namaMenu: NSLocalizedString("Card Management".localized(LocalizationService.shared.language), comment: "")),
        SettingMenu(id: 2, namaMenu: "e-Statement"),
        SettingMenu(id: 3, namaMenu: NSLocalizedString("Transaction Fee".localized(LocalizationService.shared.language), comment: "")),
        SettingMenu(id: 4, namaMenu: NSLocalizedString("Fingerprint Activation".localized(LocalizationService.shared.language), comment: "")),
        SettingMenu(id: 5, namaMenu: NSLocalizedString("Language setting".localized(LocalizationService.shared.language), comment: "")),
        SettingMenu(id: 6, namaMenu: NSLocalizedString("Change Password / PIN".localized(LocalizationService.shared.language), comment: "")),
        SettingMenu(id: 7, namaMenu: "Sign Out"),
    ]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    NavigationLink(destination: CardManagementScreen(), label: {
                        Text(NSLocalizedString("Card Management".localized(language), comment: ""))
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
                        Text(NSLocalizedString("Transaction Fee".localized(language), comment: ""))
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
                        Text(NSLocalizedString("Fingerprint Activation".localized(language), comment: ""))
                            .fontWeight(.light)
                            .frame(height: CGFloat(self.textHeight))
                            .foregroundColor(Color(hex: "#002251"))
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    NavigationLink(destination: LanguageSettingScreen(), label: {
                        Text(NSLocalizedString("Language setting".localized(language), comment: ""))
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
                        Text(NSLocalizedString("Change Password / PIN".localized(language), comment: ""))
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
