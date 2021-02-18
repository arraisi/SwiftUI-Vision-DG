//
//  CustomBottomNavigationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/11/20.
//

import SwiftUI

struct CustomBottomNavigationView: View {
    
    @Binding var selected : Int
    
    var body: some View {
        HStack{
            Button(action: {
                
                self.selected = 0
                
            }) {
                VStack {
                    Image("ic_dashboard")
                        .renderingMode(.template)
//                    Text("Dashboard")
//                        .font(.caption2)
                }
                
            }.foregroundColor(self.selected == 0 ? .blue : .gray)
            
            Spacer(minLength: 12)
            
            
            Button(action: {
                self.selected = 1
                
            }) {
                VStack {
                    Image("ic_transfer")
                        .renderingMode(.template)
//                    Text("Transfer")
//                        .font(.caption2)
                }
                
            }.foregroundColor(self.selected == 1 ? .blue : .gray)
            
            
            Spacer().frame(width: 120)
            
            Button(action: {
                self.selected = 4
                
            }) {
//                EmptyView()
                VStack {
                    Image("ic_favorit")
                        .renderingMode(.template)
//                    Text("Favorit")
//                        .font(.caption2)
                }
                
            }.foregroundColor(self.selected == 2 ? .blue : .gray)
            .offset(x: -10)
            
            
            Spacer(minLength: 12)
            
            Button(action: {
                self.selected = 3
            }) {
                
                VStack {
                    Image("ic_akun")
                        .renderingMode(.template)
//                    Text("Akun")
//                        .font(.caption2)
                }
                
            }.foregroundColor(self.selected == 3 ? .blue : .gray)
        }
    }
}

struct CustomBottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomNavigationView(selected: .constant(0))
    }
}

struct CurvedShape : View {
    var body : some View{
        
        Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 55))
            
            path.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2, y: 55), radius: 30, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
            
            path.addLine(to: CGPoint(x: 0, y: 55))
            
        }.fill(Color.white)
        .rotationEffect(.init(degrees: 180))
    }
}
