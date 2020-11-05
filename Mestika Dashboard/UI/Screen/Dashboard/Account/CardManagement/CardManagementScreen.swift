//
//  CardManagementScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct CardManagementScreen: View {
    @State var data = [
    Card(id: 0, imageName: "rekening-card-3", name: "KARTU 1", description: "KARTU 1", activeStatus: false, isShow: false),
    Card(id: 1, imageName: "rekening-card-4", name: "KARTU 2", description: "KARTU 2", activeStatus: true, isShow: false),
    Card(id: 2, imageName: "rekening-card-5", name: "KARTU 3", description: "KARTU 1", activeStatus: false, isShow: false),
    Card(id: 3, imageName: "rekening-card-6", name: "KARTU 4", description: "KARTU 2", activeStatus: false, isShow: false)
]

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
                    DetailKartuTidakAktifView(kartu: data[kartuIndex])
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
