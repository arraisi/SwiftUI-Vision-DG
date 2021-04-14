//
//  DashboardScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct DashboardTabs: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Carousel Variables */
    @State var cards: [KartuKuDesignViewModel] = []
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 140 // 100 is amount padding left and right
    let itemHeight:CGFloat = 197
    let itemGapHeight:CGFloat = 10
    let itemGapWidth:CGFloat = 0.14
    
    @State var listSourceNumber: [String] = []
    @State var listTypeAccount: [String] = []
    
    /* Loading and Data Variable */
    @State var isLoading : Bool = true
    @State var isLoadingCard : Bool = true
    @State var kartkuKu = KartuKuResponse()
    
    @StateObject var savingAccountVM = SavingAccountViewModel()
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var username: String = ""
    @State var balance: String = ""
    @State var balanceStatus: String = ""
    @State var productName: String = "-"
    @State var accountNumber: String = "-"
    
    @Binding var cardNo: String
    @State var cardName: String = "-"
    @Binding var sourceNumber: String
    
    @State var isDetailCard: Bool = false
    
    @State var isHiddenBalance: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            
            GeometryReader { geometry in
                Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                    .frame(height: 0)
            }
            
            VStack {
                usernameInfo
                menuGrid
                
                GridMenuView(cardNo: $cardNo, sourceNumber: $sourceNumber)
                    .onReceive(self.appState.$moveToDashboard) { value in
                        self.isLoadingCard = true
                        
                        self.savingAccountVM.getAccounts { (success) in
                            self.isLoadingCard = false

                            self.savingAccountVM.accounts.forEach { e in

                                print(e.accountNumber)
                                self.listSourceNumber.append(e.accountNumber)
                                self.listTypeAccount.append(e.accountType ?? "")
                            }

                            self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { (success) in

                            }
                        }
                    }
                
                VStack {
                    HStack {
                        Text("Information")
                            .font(.title3)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding([.leading, .trailing], 15)
                    
                    HStack(spacing: itemWidth * itemGapWidth) {
                        
                        Image("ic_notif_rekening")
                            .padding(.leading, 15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10)
                        
                    }
                }
                
                VStack {
                    HStack {
                        Text("My Card".localized(language))
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
                    
                    HStack(spacing: itemWidth * itemGapWidth) {
                        
                        if (self.cards.count < 1) {
                            EmptyView()
                        } else {
                            NavigationLink(
                                destination: MyCardDashboardView(cards: .constant(cards[0]))) {
                                CardView(card: cards[0], cardWidth: itemWidth, cardHeight: itemHeight, showContent: true)
                            }
                        }
                    }
                }
                
                ListEwalletView()
                    .padding(.top, 30)
            }
        })
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            print("GET")
//            getAccountBalance()
            getUserInfo()
            getProfile()
            getListKartuKu()
            
            self.savingAccountVM.getAccounts { (success) in
                self.isLoadingCard = false
                self.savingAccountVM.accounts.forEach { e in
                    
//                    if (e.accountType == "S" || e.accountType == "D") {
//                        print(e.accountNumber)
//                        self.listSourceNumber.append(e.accountNumber)
//                    }
                    print(e.accountNumber)
                    self.listSourceNumber.append(e.accountNumber)
                    self.listTypeAccount.append(e.accountType ?? "")
                }
                
                self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { (success) in
                    
                }
            }
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
                
                Text("Is there anything I can help you with?".localized(language))
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
            if isLoadingCard {
                ProgressView("Loading")
                    .padding(.vertical, 50)
            } else {
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack {
                        ForEach(0..<self.savingAccountVM.accounts.reversed().count) { index in
                            HStack(alignment: .top) {
                                Divider()
                                    .frame(width: 3, height: isHiddenBalance ? 70 : 100)
                                    .background(Color(hex: "#232175"))
                                    .padding(.trailing, 5)
                                
                                VStack(alignment: .leading) {
                                    Text("\(self.savingAccountVM.accounts[index].accountTypeDescription ?? "")")
                                        .font(.headline)
                                        .bold()
                                        .padding(.bottom, 5)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text("\(self.savingAccountVM.accounts[index].productName ?? "Tabungan Mestika")")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(Color(hex: "#232175"))
                                            .fontWeight(.ultraLight)
                                        
                                        if (self.savingAccountVM.accounts[index].accountNumber == "") {
                                            Text("-")
                                                .font(.caption)
                                                .fontWeight(.ultraLight)
                                        } else {
                                            Text("\(self.savingAccountVM.accounts[index].accountNumber)")
                                                .font(.caption)
                                                .fontWeight(.ultraLight)
                                        }
                                        
                                        if isHiddenBalance {
                                            EmptyView()
                                        } else {
                                            
                                            if (self.listTypeAccount.count < 1) {
                                                ProgressView()
                                            } else {
                                                if (self.listTypeAccount[index] == "S" || self.listTypeAccount[index] == "D") {
                                                    HStack {
                                                        if (self.savingAccountVM.balanceAccount.count < 1) {
                                                            ProgressView()
                                                        } else {
                                                            
                                                            Text("Rp.")
                                                                .fontWeight(.light)
                                                                .foregroundColor(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? .red : Color(hex: "#2334D0"))
                                                            
                                                            if (self.savingAccountVM.balanceAccount[index].balance == "") {
                                                                Text("\(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? "-" : "")" +  "\("0")")
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .foregroundColor(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? .red : Color(hex: "#2334D0"))
                                                            } else {
                                                                Text("\(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? "-" : "")" +  "\(self.savingAccountVM.balanceAccount[index].balance?.thousandSeparator() ?? "0")")
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .foregroundColor(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? .red : Color(hex: "#2334D0"))
                                                            }
                                                            

                                                        }
                                                    }
                                                    .padding(.top, 5)
                                                } else {
                                                    EmptyView()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    self.isHiddenBalance.toggle()
                                }, label: {
                                    Image(systemName: isHiddenBalance ? "eye.fill" : "eye.slash")
                                        .padding(.top, 5)
                                })
                                .padding(.leading, 30)
                            }
                            .padding([.leading, .trailing], 15)
                            .padding(.top, 25)
                            .padding(.bottom, 20)
                        }
                    }
                })
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
    
    func getAccountBalance() {
        self.profileVM.getAccountBalance { success in
            if success {
                self.isLoading = false
                self.balance = self.profileVM.balance
                self.balanceStatus = self.profileVM.creditDebit
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
    
    @ObservedObject var kartuKuVM = KartuKuViewModel()
    private func getListKartuKu() {
        self.kartuKuVM.getListKartuKu { success in
            if success {
                self.isLoading = false
                self.cards = self.kartuKuVM.listKartuKu
                self.refreshCarousel()
            }
            
            if !success {
                self.isLoading = false
            }
        }
    }
    
    // MARK: - REFRESH THE CARD ITEM OFFSET
    private func refreshCarousel() {
        let offsetFirstItem = ((self.itemWidth + (itemWidth*0.08)) * CGFloat(self.cards.count / 2))
        let offsetMiddleItem = (self.cards.count % 2 == 0 ? ((self.itemWidth + (UIScreen.main.bounds.width*0.15)) / 2) : 0)
        self.firstOffset = offsetFirstItem - offsetMiddleItem
        
        if cards.count > 0 {
            self.cards[0].isShow = true
        }
    }
    
    // MARK: - ON DRAG ENDED
    private func onDragEnded(value: DragGesture.Value) {
        if value.translation.width > 0 {
            // dragThreshold -> distance of drag to next item
            if value.translation.width > self.itemWidth / 4 && Int(self.count) != 0 {
                
                self.count -= 1
                self.updateHeight(value: Int(self.count))
                self.offset = -((self.itemWidth + (itemWidth*itemGapWidth)) * self.count)
            }
            else{
                self.offset = -((self.itemWidth + (itemWidth*itemGapWidth)) * self.count)
            }
            
        }
        else{
            // dragThreshold -> distance of drag to next item
            if -value.translation.width > self.itemWidth / 4 && Int(self.count) !=  (self.cards.count - 1){
                
                self.count += 1
                self.updateHeight(value: Int(self.count))
                self.offset = -((self.itemWidth + (itemWidth*itemGapWidth)) * self.count)
            }
            else{
                
                self.offset = -((self.itemWidth + (itemWidth*itemGapWidth)) * self.count)
            }
            
        }
    }
    
    // MARK: - UPDATE HEIGHT
    private func updateHeight(value : Int){
        
        for i in 0..<cards.count{
            cards[i].isShow = false
        }
        
        cards[value].isShow = true
    }
}
