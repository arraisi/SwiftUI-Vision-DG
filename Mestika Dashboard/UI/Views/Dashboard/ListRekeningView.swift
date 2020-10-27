//
//  ListRekeningView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct ListRekeningView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Rekening")
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
                    VStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image("ic_btn_add_rekening")
                        })
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image("ic_rekening_list")
                        })
                    }
                    Image("rekening-card-1")
                        .padding(.trailing, 10)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    Image("rekening-card-2")
                        .padding(.trailing, 15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
            })
        }
    }
}

struct ListRekeningView_Previews: PreviewProvider {
    static var previews: some View {
        ListRekeningView()
    }
}
