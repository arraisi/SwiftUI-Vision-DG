//
//  CardManagementScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct CardManagementScreen: View {
    @State var data = kartuKuData
    @State var kartuIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack() {
                SnapCarouselView(itemWidth: 236, itemHeight: 197, itemGapHeight: 15, data: $data) { (index) in
                    
                    kartuIndex = index
                }
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                .padding(.vertical,40)
                
                if !kartuKuData[kartuIndex].activeStatus {
                    DetailKartuTidakAktifView(kartu: kartuKuData[kartuIndex])
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                }
                else {
                    DetailKartuAktifView()
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                }
                
                Spacer()
                
            }
            .padding(.vertical, 100)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Kartu-Ku", displayMode: .inline)
    }
}

struct CardManagementScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardManagementScreen()
    }
}
