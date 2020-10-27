//
//  ListEwalletView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct ListEwalletView: View {
    var body: some View {
        VStack {
            HStack {
                Text("E-Wallet")
                    .font(.title3)
                    .fontWeight(.ultraLight)
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("See All")
                        .bold()
                        .foregroundColor(Color(hex: "#2334D0"))
                })
            }
            .padding([.leading, .trailing], 15)
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack{
                    Image("ewallet-card-1")
                        .padding(.leading, 15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    
                    Image("ewallet-card-2")
                        .padding(.trailing, 15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
            })
        }
    }
}

struct ListEwalletView_Previews: PreviewProvider {
    static var previews: some View {
        ListEwalletView()
    }
}
