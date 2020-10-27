//
//  DashboardScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct DashboardTabs: View {
    
    @State var username: String = "Example User"
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
                VStack {
                    usernameInfo
                    menuGrid
                    
                    ListRekeningView()
                        .padding(.top, 30)
                    
                    ListEwalletView()
                        .padding(.top, 30)
                    
                    ListContactTransferOnUs()
                        .padding(.top, 30)
                    
                    ListPromoForYouView()
                        .padding(.top, 30)
                    
                    ListPurchasePaymentView()
                        .padding(.top, 30)
                    
                    VoucherView()
                        .padding(.top, 30)
                    Spacer()
                }
            })
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // MARK: -USERNAME INFO VIEW
    var usernameInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hi, \(self.username)")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Apakah ada yang bisa bantu?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
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
                
                .padding(.bottom, 25)
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)

    }
}

struct DashboardTabs_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabs()
    }
}
