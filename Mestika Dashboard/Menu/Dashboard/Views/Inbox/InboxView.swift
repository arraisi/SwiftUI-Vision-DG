//
//  InboxView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 22/04/21.
//

import SwiftUI
import Indicators

struct InboxView: View {
    
    @ObservedObject private var authVM = AuthViewModel()
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var selected: Int = 0
    @State var isLoading: Bool = false
    
    @State private var timeLogout = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var showAlertTimeout: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            
            let tap = TapGesture()
                .onEnded { _ in
                    self.timeLogout = 300
                    print("View tapped!")
                }
            
            if (self.isLoading) {
                LinearWaitingIndicator()
                    .animated(true)
                    .foregroundColor(.green)
                    .frame(height: 1)
            }
            
            HStack(spacing: 0){
                UnderlineButton(active: self.selected == 0 ? true : false, label: "History") {
                    print("History")
                    self.selected = 0
                }
                
                UnderlineButton(active: self.selected == 1 ? true : false, label: "Pesan") {
                    print("Pesan")
                    self.selected = 1
                }
            }
            .padding(.top, 30)
            
            if selected == 0 {
                HistoryView(isLoading: self.$isLoading)
            }
            
            if selected == 1 {
                PesanView()
            }
            
            Spacer()
            
        }
        .navigationBarTitle("Inbox", displayMode: .inline)
//        .onReceive(timer) { time in
////            print(self.timeLogout)
//            if self.timeLogout > 0 {
//                self.timeLogout -= 1
//            }
//
//            if self.timeLogout == 1 {
//                showAlertTimeout = true
//            }
//        }
//        .alert(isPresented: $showAlertTimeout) {
//            return Alert(title: Text("Session Expired"), message: Text("You have to re-login"), dismissButton: .default(Text("OK".localized(language)), action: {
//                self.authVM.postLogout { success in
//                    if success {
//                        print("SUCCESS LOGOUT")
//                        DispatchQueue.main.async {
//                            self.appState.moveToWelcomeView = true
//                        }
//                    }
//                }
//            }))
//        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InboxView()
                .navigationBarTitle("Inbox", displayMode: .inline)
        }
    }
}
