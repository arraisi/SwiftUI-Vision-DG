//
//  SidemenuView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/10/20.
//

import SwiftUI


struct SidemenuView: View {
    
    var sideMenu: [SideMenuContent] = sideMenuContent
    @State var menuSelected: SideMenuContent = sideMenuContent[0]
    
    var body: some View {
        ZStack {
            
            Color(hex: "#232175").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Mobile Banking Apps")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                    Image("logo_mestika")
                }
                .padding(.horizontal, 25)
                .padding([.bottom, .top], 30)
                
                ForEach(sideMenu) { menuItem in
                    SidemenuCell(sideItem: menuItem).onTapGesture {
                        self.menuSelected = menuItem
                    }
                }
                
                Spacer()
                
                Text("Copyright Multipolar Technology © 2020 \nAll Right Reserved")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .fontWeight(.light)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
            }
            
        }
    }
}

struct SidemenuView_Previews: PreviewProvider {
    static var previews: some View {
        SidemenuView()
    }
}
