//
//  DashboardScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct DashboardTabs: View {
    
    @ObservedObject private var authVM = AuthViewModel()
    
    @State private var timeLogout = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var showAlertTimeout: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Carousel Variables */
    @State var cards: [KartuKuDesignViewModel] = []
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    @State var itemIndex : CGFloat = 0
    @State var firstItemPosition : CGFloat = 0
    @State var currentItemPosition : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 150 // 100 is amount padding left and right
    let itemHeight:CGFloat = 170
    let itemGapHeight:CGFloat = 10
    let itemGapWidth:CGFloat = 0.14
    
    @State var listSourceNumber: [String] = []
    @State var listTypeAccount: [String] = []
    @State var listCreditDebit: [String] = []
    
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
    @State var isHiddenInformationReStore: Bool = true
    
    @State var routingManagementCard: Bool = false
    @State var routingMyCardDashboard: Bool = false
    @State var routingAccountDeposit: Bool = false
    
    @State var isRouteHistoryAcc: Bool = false
    
    var body: some View {
        
        let tap = TapGesture()
            .onEnded { _ in
                self.timeLogout = 300
                print("View tapped!")
            }
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            GeometryReader { geometry in
                Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                    .frame(height: 0)
            }
            
            VStack {
                usernameInfo
                menuGrid
                
                GridMenuView(cardNo: $cardNo, sourceNumber: $sourceNumber)
                
                NavigationLink(
                    destination: HistoryByAccountView(cardNo: self.$cardNo, sourceNumber: self.$sourceNumber),
                    isActive: self.$isRouteHistoryAcc,
                    label: {}
                )
                
                VStack {
                    HStack {
                        Text("Information")
                            .font(.title3)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding([.leading, .trailing], 15)
                    
                    if isHiddenInformationReStore {
                        EmptyView()
                    } else {
                        HStack {
                            
                            NavigationLink(
                                destination: DepositAccountView(),
                                isActive: self.$routingAccountDeposit,
                                label: {}
                            )
                            .isDetailLink(false)
                            
                            Button(action: {
                                
                                if (self.balanceStatus == "D") {
                                    
                                } else {
                                    self.routingAccountDeposit = true
                                }
                            }, label: {
                                Image("ic_notif_rekening")
                                    .resizable()// Fade Transition with duration
                                    .scaledToFill()
                                    .frame(width: itemWidth, height: itemHeight)
                            })
                        }
                    }
                }
                .padding(.bottom, 15)
                
                VStack {
                    HStack {
                        Text("My Card".localized(language))
                            .font(.title3)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: CardManagementScreen(),
                            isActive: self.$routingManagementCard,
                            label: {}
                        )
                        .isDetailLink(false)
                        
                        Button(
                            action: {
                                self.routingManagementCard = true
                            },
                            label: {
                                Text("See All")
                                    .bold()
                                    .foregroundColor(Color(hex: "#2334D0"))
                            }
                        )
                    }
                    .padding([.leading, .trailing], 15)
                    
                    HStack(spacing: itemWidth * itemGapWidth) {
                        
                        if (self.cards.count < 1) {
                            EmptyView()
                        } else {
                            
                            NavigationLink(
                                destination: MyCardDashboardView(cards: .constant(cards[0])),
                                isActive: self.$routingMyCardDashboard,
                                label: {}
                            )
                            .isDetailLink(false)
                            
                            Button(
                                action: {
                                    self.routingMyCardDashboard = true
                                },
                                label: {
                                    CardView(card: cards[0], cardWidth: itemWidth, cardHeight: itemHeight, showContent: true)
                                }
                            )
                        }
                    }
                }
                .onReceive(self.appState.$moveToDashboard) { value in
                    if value {
                        print("Move to Dashboard: \(value)")
                        
                        self.routingAccountDeposit = false
                        self.routingManagementCard = false
                        self.routingMyCardDashboard = false
                        self.appState.moveToDashboard = false
                    }
                }
                
                ListEwalletView()
                    .padding(.top, 30)
            }
        })
        .gesture(tap)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.top)
        .onReceive(timer) { time in
            print(self.timeLogout)
            if self.timeLogout > 0 {
                self.timeLogout -= 1
            }
            
            if self.timeLogout < 1 {
                showAlertTimeout = true
            }
        }
        .onAppear {
            print("GET")
            self.listSourceNumber.removeAll()
            self.listTypeAccount.removeAll()
            self.isHiddenInformationReStore = true
            self.isLoadingCard = true
            
            getUserInfo()
            getProfile()
            getListKartuKu()
            getAccountBalance()
            
            self.savingAccountVM.getAccounts { success in
                
                if success {
                    self.isLoadingCard = false
                    self.savingAccountVM.accounts.forEach { e in
                        print(e.accountNumber)
                        self.listSourceNumber.append(e.accountNumber)
                        self.listTypeAccount.append(e.accountType ?? "")
                    }
                    
                    self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { (success) in
                        
                        if self.savingAccountVM.balanceAccount.contains(where: { $0.creditDebit == "D" }) {
                            print("ADA TYPE D")
                            self.isHiddenInformationReStore = false
                        }
                        
                    }
                }
                
                if !success {
                    self.isLoadingCard = false
                    if (self.savingAccountVM.errorCode == "401") {
                        self.appState.moveToWelcomeView = true
                    }
                }

            }
        }
        .alert(isPresented: $showAlertTimeout) {
            return Alert(title: Text("Session Expired"), message: Text("You have to re-login"), dismissButton: .default(Text("OK".localized(language)), action: {
                self.authVM.postLogout { success in
                    if success {
                        print("SUCCESS LOGOUT")
                        DispatchQueue.main.async {
                            self.appState.moveToWelcomeView = true
                        }
                    }
                }
            }))
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
            if isLoadingCard || self.savingAccountVM.accounts.isEmpty {
                ProgressView("Loading")
                    .padding(.vertical, 50)
            } else {
                
                TabView {
                    ForEach(0..<self.savingAccountVM.accounts.count) { index in
                        Button(
                            action: {
                                self.isRouteHistoryAcc = true
                            },
                            label: {
                                HStack {
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

        //                                            if (self.listTypeAccount.isEmpty) {
        //                                                ProgressView()
        //                                            } else {
        //                                                if (self.listTypeAccount[index] == "S" || self.listTypeAccount[index] == "D") {
        //                                                    HStack {
        //                                                        if (self.savingAccountVM.balanceAccount.count < 1) {
        //                                                            ProgressView()
        //                                                        } else {
        //
        //                                                            Text("Rp.")
        //                                                                .fontWeight(.light)
        //                                                                .foregroundColor(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? .red : Color(hex: "#2334D0"))
        //
        //                                                            if (self.savingAccountVM.balanceAccount[index].balance == "") {
        //                                                                Text("\(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? "-" : "")" +  "\("0")")
        //                                                                    .font(.title3)
        //                                                                    .bold()
        //                                                                    .foregroundColor(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? .red : Color(hex: "#2334D0"))
        //                                                            } else {
        //                                                                Text("\(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? "-" : "")" +  "\(self.savingAccountVM.balanceAccount[index].balance?.thousandSeparator() ?? "0")")
        //                                                                    .font(.title3)
        //                                                                    .bold()
        //                                                                    .foregroundColor(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? .red : Color(hex: "#2334D0"))
        //                                                            }
        //
        //
        //                                                        }
        //                                                    }
        //                                                    .padding(.top, 5)
        //                                                } else {
        //                                                    HStack {
        //                                                        if (self.savingAccountVM.balanceAccount.count < 1) {
        //                                                            ProgressView()
        //                                                        } else {
        //
        //                                                            Text("Rp.")
        //                                                                .fontWeight(.light)
        //                                                                .foregroundColor(.white)
        //
        //                                                            if (self.savingAccountVM.balanceAccount[index].balance == "") {
        //                                                                Text("\(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? "-" : "")" +  "\("0")")
        //                                                                    .font(.title3)
        //                                                                    .bold()
        //                                                                    .foregroundColor(.white)
        //                                                            } else {
        //                                                                Text("\(self.savingAccountVM.balanceAccount[index].creditDebit == "D" ? "-" : "")" +  "\(self.savingAccountVM.balanceAccount[index].balance?.thousandSeparator() ?? "0")")
        //                                                                    .font(.title3)
        //                                                                    .bold()
        //                                                                    .foregroundColor(.white)
        //                                                            }
        //                                                        }
        //                                                    }
        //                                                    .padding(.top, 5)
        //                                                }
        //                                            }
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
                                        .padding(.leading, 40)
                                    }
                                    .padding([.trailing, .leading], 25)
                                    .padding(.top, 25)
                                    .padding(.bottom, 20)
                                }
                                .padding(.bottom, 30)
                            }
                        )
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
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
                
                if (self.profileVM.statusCode == "401") {
                    self.appState.moveToWelcomeView = true
                }
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
