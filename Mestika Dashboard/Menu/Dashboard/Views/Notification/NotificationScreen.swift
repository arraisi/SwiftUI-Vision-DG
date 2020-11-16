//
//  Notification.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 16/11/20.
//

import SwiftUI
import SlidingTabView

struct NotificationScreen: View {
    @State private var selectedTabIndex = 0
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.backgroundImage = UIImage()
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1369999945, green: 0.1289999932, blue: 0.4589999914, alpha: 1)
        ]
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.1369999945, green: 0.1289999932, blue: 0.4589999914, alpha: 1)
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
    var body: some View {
        VStack(spacing: 0) {
            SlidingTabView(selection: self.$selectedTabIndex, tabs: ["Pesan", "Pemberitahuan"],
                           font: .caption, activeAccentColor: .primary, selectionBarColor: .primary,
                           selectionBarHeight: 2)
            if selectedTabIndex == 0 {
                ListNotificationView()
            } else {
                ListAnnouncementView()
            }
        }
        .navigationBarTitle("Inbox", displayMode: .inline)
        .animation(.none)
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen()
    }
}
