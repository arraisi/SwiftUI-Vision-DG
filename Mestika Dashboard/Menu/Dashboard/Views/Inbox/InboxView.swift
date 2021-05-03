//
//  InboxView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 22/04/21.
//

import SwiftUI
import Indicators

struct InboxView: View {
    
    @State var selected: Int = 0
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
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
                
                //                UnderlineButton(active: self.selected == 1 ? true : false, label: "Pemberitahuan") {
                //                    print("Pemberitahuan")
                //                    self.selected = 1
                //                }
            }
            .padding(.top, 30)
            
            if selected == 0 {
                HistoryView(isLoading: self.$isLoading)
            }
            
            if selected == 1 {
                PesanView()
            }
            
            //            if selected == 1 {
            //                PemberitahuanView()
            //            }
            
            Spacer()
            
        }
        .navigationTitle("Inbox")
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
