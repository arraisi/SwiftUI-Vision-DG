//
//  HistoryTabs.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 18/02/21.
//

import SwiftUI

struct HistoryTabs: View {
    var body: some View {
        ZStack {
            Image("ic_favorite")
                .resizable()
                .scaledToFill()
                .padding(5)
        }
        .background(Color.green)
        .frame(width: 40, height: 40)
        .cornerRadius(5)
        .shadow(radius: 2)
        
    }
}

struct HistoryTabs_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTabs()
    }
}
