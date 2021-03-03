//
//  DashboardScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct DashboardTabs: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var username: String = ""
    @State var balance: String = ""
    @State var productName: String = "-"
    @State var accountNumber: String = "-"
    
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 140 // 100 is amount padding left and right
    let itemHeight:CGFloat = 197
    
    @Binding var cardNo: String
    @State var cardName: String = "-"
    @Binding var sourceNumber: String
    
    @State var isHiddenBalance: Bool = false
    @State var isLoading: Bool = true
    
    var body: some View {
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
            
            GeometryReader { geometry in
                Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                    .frame(height: 0)
            }
            
            VStack {
                usernameInfo
                menuGrid
                
                GridMenuView(cardNo: $cardNo, sourceNumber: $sourceNumber)
                
                VStack {
                    HStack {
                        Text(NSLocalizedString("My Card".localized(language), comment: ""))
                            .font(.title3)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                        
                        NavigationLink(destination: CardManagementScreen(), label: {
                            Text("See All")
                                .bold()
                                .foregroundColor(Color(hex: "#2334D0"))
                        })
                    }
                    .padding([.leading, .trailing], 15)
                    
                    ZStack {
                        
                        WebImage(url: URL(string: "http://eagle-dev.apps.visiondg.bankmestika.co.id/image/ecdd770829c5d1d75a27d45bccea1121.png"))
                            .onSuccess { image, data, cacheType in
                                // Success
                            }
                            .placeholder {
                                Rectangle().foregroundColor(.gray).opacity(0.5)
                                    .frame(width: itemWidth, height: itemHeight)
                            }
                            .resizable()
                            .indicator(.activity) // Activity Indicator
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .scaledToFill()
                            .frame(width: itemWidth, height: itemHeight)
                        
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Text("GOLD")
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                
                                Text(self.accountNumber)
                                    .font(.caption2)
                                    .foregroundColor(Color.white)
                                    .padding(.top, 15)
                                
                                Text(self.cardNo)
                                    .font(.caption2)
                                    .foregroundColor(Color.white)
                                    .padding(.top, 10)
                                
                                Text(self.cardName)
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                            }
                            .padding(.leading, 60)
                            
                            Spacer()
                        }
                    }
                }
                
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
                
                if isLoading {
                    ProgressView()
                } else {
                    Text("Hi, \(self.username)")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                
                Text(NSLocalizedString("Is there anything I can help you with?".localized(language), comment: ""))
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
            if isLoading {
                ProgressView("Loading")
                    .padding(.vertical, 50)
            } else {
                HStack(alignment: .top) {
                    Divider()
                        .frame(width: 3, height: isHiddenBalance ? 60 : 90)
                        .background(Color(hex: "#232175"))
                        .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text("\(self.productName)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color(hex: "#232175"))
                            .padding(.bottom, 5)
                        
                        if (isHiddenBalance) {
                            VStack(alignment: .leading) {
                                Text(NSLocalizedString("Balance hidden".localized(language), comment: ""))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                Text(NSLocalizedString("Main Account Balance".localized(language), comment: ""))
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
                self.isLoading = false
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                self.username = self.profileVM.name
                self.balance = self.profileVM.balance
                self.productName = self.profileVM.nameOnCard
                self.accountNumber = self.profileVM.accountNumber
                
                self.cardNo = self.profileVM.cardNo
                self.cardName = self.profileVM.cardName
            }
            
            if !success {
                self.isLoading = false
            }
        }
    }
    
    func getUserInfo() {
        self.user.forEach { (data) in
            self.username = data.namaLengkapFromNik!
        }
    }
}
