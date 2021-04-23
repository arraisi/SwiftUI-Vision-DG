//
//  PemberitahuanView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 23/04/21.
//

import SwiftUI

struct PemberitahuanView: View {
    
    private var inbox = PemberitahuanModel.all()
    
    var body: some View {
        List {
            
            ForEach(inbox, id: \.self) { data in
                
                Section(header: Text(data.date)) {
                    
                    ForEach(data.contents, id: \.self){ p in
                        Image(p.content)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width-40, height: 400, alignment: .center)
                            .clipped()
                    }
                    
                }
                
            }
            
        }
        .listStyle(GroupedListStyle())
    }
}

struct PemberitahuanView_Previews: PreviewProvider {
    static var previews: some View {
        PemberitahuanView()
    }
}
