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
                        .foregroundColor(self.selected == 0 ? Color(hex: "#2334D0") : .gray)
                    
                    Text("Dashboard")
                        .font(.system(size: 10))
                        .foregroundColor(selected == 0 ? Color(hex: "#2334D0") : .white)
                }
                
            }
            
            Spacer(minLength: 12)
            
            
            Button(action: {
                self.selected = 1
                
            }) {
                VStack {
                    Image("ic_transfer")
                        .renderingMode(.template)
                        .foregroundColor(self.selected == 1 ? Color(hex: "#2334D0") : .gray)
                    
                    Text("Transfer")
                        .font(.system(size: 10))
                        .foregroundColor(self.selected == 1 ? Color(hex: "#2334D0") : .white)
                }
                
            }
            
            Spacer().frame(width: 120)
            
            Button(action: {
                self.selected = 2
            }) {
                //                EmptyView()
                VStack {
                    Image("ic_history")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(self.selected == 2 ? Color(hex: "#2334D0") : .gray)
                    
                    Text("History")
                        .font(.system(size: 10))
                        .foregroundColor(self.selected == 2 ? Color(hex: "#2334D0") : .white)
                }
                
            }
            //            .offset(x: -10)
            
            
            Spacer(minLength: 12)
            
            Button(action: {
                self.selected = 3
            }) {
                
                VStack {
                    Image("ic_akun")
                        .renderingMode(.template)
                        .foregroundColor(self.selected == 3 ? Color(hex: "#2334D0") : .gray)
                    
                    Text("Account")
                        .font(.system(size: 10))
                        .foregroundColor(self.selected == 3 ? Color(hex: "#2334D0") : .white)
                }
                
            }
        }
    }
}

struct CustomBottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomNavigationView(selected: .constant(0))
    }
}
