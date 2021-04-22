//
//  InboxView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 22/04/21.
//

import SwiftUI

struct InboxView: View {
    
    @State var selected: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 0){
                UnderlineButton(active: self.selected == 0 ? true : false, label: "Pesan") {
                    print("Pesan")
                    self.selected = 0
                }
                
                UnderlineButton(active: self.selected == 1 ? true : false, label: "Pemberitahuan") {
                    print("Pemberitahuan")
                    self.selected = 1
                }
            }
            .padding(.top, 30)
            
            if selected == 0 {
                PesanView()
            }
            
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


struct UnderlineButton: View {
    
    var active: Bool
    var label: String
    var action: ()->()
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack{
                Text(label)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(active ? Color("StaleBlue") : Color.gray)
                Group {
                    Rectangle()
                }
                .frame(height: 3)
                .foregroundColor(active ? Color("StaleBlue") : Color.gray)
            }
        })
    }
}
