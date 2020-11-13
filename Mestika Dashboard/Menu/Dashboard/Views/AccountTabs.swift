//
//  AccountTabs.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct AccountTabs: View {
    
    @Binding var showingSettingMenu : Bool
    @State var username: String = "Example User"
    
    var body: some View {
        ZStack {
//            Color(hex: "#F6F8FB")
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
                
                GeometryReader { geometry in
                    Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                        .frame(height: 0)
                }
                
                ZStack {
                    VStack {
                        profileInfo
                        menuGrid
                            .padding(.bottom)
                        
                        ListHistoryTransferView()
                        ListHistoryTransactionView()
                    }
                }
            })
            .navigationBarHidden(true)
        }
    }
    
    var profileInfo: some View {
        VStack {
            HStack(alignment: .top) {
                Image("foryou-card-1")
                    .resizable()
                    .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeIn) {
                        self.showingSettingMenu = true
                    }
                }, label: {
                    Image("ic_settings")
                })
            }
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("\(self.username)")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2334D0"))
                
                Text("+62 858 7507 4351")
                    .font(.caption)
                    .fontWeight(.light)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    // MARK: -MENU GRID VIEW
    var menuGrid: some View {
        VStack {
            HStack(alignment: .top) {
                Divider()
                    .frame(width: 3, height: 90)
                    .background(Color(hex: "#232175"))
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text("\(self.username)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.bottom, 5)
                    
                    VStack(alignment: .leading) {
                        Text("Total Saldo")
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        HStack {
                            Text("Rp.")
                                .fontWeight(.light)
                                .foregroundColor(Color(hex: "#2334D0"))
                            
                            Text("750.000")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Color(hex: "#2334D0"))
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("ic_more")
                        .padding(.top, 5)
                })
            }
            .padding([.leading, .trailing], 15)
            .padding(.top, 25)
            .padding(.bottom, 20)
            
            GridMenuView()
                
                .padding(.bottom, 15)
            
            ListMySavingsView()
                .padding(.bottom, 25)
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)

    }
}

struct AccountTabs_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabs(showingSettingMenu: .constant(false))
    }
}
