//
//  DashboardScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct DashboardTabs: View {
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var username: String = ""
    @State var balance: String = ""
    
    @State var isHiddenBalance: Bool = false
    
    var body: some View {
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
            
            GeometryReader { geometry in
                Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                    .frame(height: 0)
            }
            
            VStack {
                usernameInfo
                menuGrid
                
                GridMenuView()
                    .padding(.top, 10)
                
                ListRekeningView()
                    .padding(.top, 10)
                
//                ListEwalletView()
//                    .padding(.top, 30)
//
//                ListContactTransferOnUs()
//                    .padding(.top, 30)
//
//                ListPromoForYouView()
//                    .padding(.top, 30)
//
//                ListPurchasePaymentView()
//                    .padding(.top, 30)
//
//                VoucherView()
//                    .padding(.top, 50)
            }
        })
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            print("GET")
            getUserInfo()
            getProfile()
        }
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
                    .frame(width: 3, height: isHiddenBalance ? 60 : 90)
                    .background(Color(hex: "#232175"))
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text("\(self.username)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.bottom, 5)
                    
                    if (isHiddenBalance) {
                        VStack(alignment: .leading) {
                            Text("Saldo disembunyikan")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("Saldo Rekening Utama")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                            
                            HStack {
                                Text("Rp.")
                                    .fontWeight(.light)
                                    .foregroundColor(Color(hex: "#2334D0"))
                                
                                Text(balance.thousandSeparator())
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color(hex: "#2334D0"))
                            }
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    self.isHiddenBalance.toggle()
                }, label: {
                    Image(systemName: isHiddenBalance ? "eye.fill" : "eye.slash")
                        .padding(.top, 5)
                })
            }
            .padding([.leading, .trailing], 15)
            .padding(.top, 25)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        
    }
    
    /* Function GET USER Status */
    @ObservedObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                self.username = self.profileVM.name
                self.balance = self.profileVM.balance
            }
        }
    }
    
    func getUserInfo() {
        self.user.forEach { (data) in
            self.username = data.namaLengkapFromNik!
        }
    }
}

struct DashboardTabs_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabs()
    }
}
