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
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 100 // 100 is amount padding left and right
    let itemHeight:CGFloat = 170
    let itemGapHeight:CGFloat = 10
    let itemGapWidth:CGFloat = 0.14
    
    @State var listSourceNumber: [String] = []
    @State var listTypeAccount: [String] = []
    @State var listProductName: [String] = []
    @State var listCreditDebit: [String] = []
    
    @State var listSortedMyAccount: [DashboardAccountModel] = []
    @State var listMyAccount: [DashboardAccountModel] = []
    @State var listAllMyAccount: [DashboardAllModel] = []
    @State var listSorterAllMyAccount: [DashboardAllModel] = []
    @State var tmpMyAccount = DashboardAccountModel(sourceNumber: "", typeAccount: "", productName: "", description: "", categoryProduct: "")
    @State var tmpAllDataAccount = DashboardAllModel(sourceNumber: "", typeAccount: "", productName: "", description: "", categoryProduct: "", balance: "", debitType: "")
    
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
    @State var isHiddenInformationFreezeAccount: Bool = true
    
    @State var routingManagementCard: Bool = false
    @State var routingMyCardDashboard: Bool = false
    @State var routingAccountDeposit: Bool = false
    @State var addBalancesActive: Bool = false
    
    @State var isRouteHistoryAcc: Bool = false
    
    var body: some View {
        
        let tap = TapGesture()
            .onEnded { _ in
                getTimeoutParam()
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
                        .padding(.bottom, 10)
                    }
                    
                    NavigationLink(
                        destination: DestinationAccountAddBalanceView(),
                        isActive: $addBalancesActive,
                        label: { EmptyView() }
                    )
                    .isDetailLink(false)
                    
                    if isHiddenInformationFreezeAccount {
                        EmptyView()
                    } else {
                        Button(action: {
                            self.addBalancesActive = true
                        }, label: {
                            Image("ic_freeze_rekening")
                                .resizable()
                                .scaledToFill()
                                .frame(width: itemWidth, height: itemHeight)
                        })
                        .padding(.top, 10)
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
                            .padding(.trailing, 40)
                        }
                    }
                }
                .onReceive(self.appState.$moveToDashboard) { value in
                    if value {
                        print("Move to Dashboard: \(value)")
                        
                        self.listMyAccount.removeAll()
                        self.listSourceNumber.removeAll()
                        self.listSortedMyAccount.removeAll()
                        self.listAllMyAccount.removeAll()
                        self.listSorterAllMyAccount.removeAll()
                        self.isHiddenInformationFreezeAccount = true
                        
                        self.checkFreezeAccount()
                        
                        self.routingAccountDeposit = false
                        self.routingManagementCard = false
                        self.routingMyCardDashboard = false
                        self.addBalancesActive = false
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
            
            if self.timeLogout == 1 {
                showAlertTimeout = true
            }
        }
        .onAppear {
            print("GET")
            self.listMyAccount.removeAll()
            self.listSourceNumber.removeAll()
            self.listSortedMyAccount.removeAll()
            self.listAllMyAccount.removeAll()
            self.listSorterAllMyAccount.removeAll()
            
            self.isHiddenInformationReStore = true
            self.isHiddenInformationFreezeAccount = true
            self.isLoadingCard = true
            
            getTimeoutParam()
            getUserInfo()
            getProfile()
            getListKartuKu()
            getAccountBalance()
            checkFreezeAccount()
            
            self.savingAccountVM.getAccounts { success in
                
                if success {
                    self.isLoadingCard = false
                    self.savingAccountVM.accounts.forEach { e in
                        
                        self.tmpMyAccount.sourceNumber = e.accountNumber
                        self.tmpMyAccount.typeAccount = e.accountType ?? ""
                        self.tmpMyAccount.productName = e.productName ?? "Tabungan Mestika"
                        self.tmpMyAccount.description = e.accountTypeDescription
                        self.tmpMyAccount.categoryProduct = e.categoryProduct
                        self.listMyAccount.append(tmpMyAccount)
                        
                    }
                    
                    
                    let sourceFilteredM = listMyAccount.filter { word in
                        return word.categoryProduct == "M"
                    }
                    let sourceFilteredS = listMyAccount.filter { word in
                      return word.categoryProduct == "S"
                    }
                    let sourceFilteredBlankOrNil = listMyAccount.filter { word in
                      return word.categoryProduct != "M" && word.categoryProduct != "S"
                    }

                    listSortedMyAccount.append(contentsOf: sourceFilteredM)
                    listSortedMyAccount.append(contentsOf: sourceFilteredS)
                    listSortedMyAccount.append(contentsOf: sourceFilteredBlankOrNil)
                    
                    listSortedMyAccount.forEach { a in
//                        self.listSourceNumber.append(a.sourceNumber ?? "")
                        if (a.typeAccount == "S" || a.typeAccount == "D") {
                            self.listSourceNumber.append(a.sourceNumber ?? "")
                        }
                    }

                    print("COUNT MY ACCOUNT")
                    print(self.listMyAccount.count)
                    self.savingAccountVM.getBalanceAccounts(listSourceNumber: listSourceNumber) { (success) in
                        
                        listMyAccount.forEach { acc in

                            self.tmpAllDataAccount.sourceNumber = acc.sourceNumber
                            self.tmpAllDataAccount.typeAccount = acc.typeAccount
                            self.tmpAllDataAccount.productName = acc.productName
                            self.tmpAllDataAccount.description = acc.description
                            self.tmpAllDataAccount.categoryProduct = acc.categoryProduct
                            
                            self.savingAccountVM.balanceAccount.forEach { balance in
                                if (acc.sourceNumber == balance.sourceNumber) {
                                    self.tmpAllDataAccount.balance = balance.balance
                                    self.tmpAllDataAccount.debitType = balance.creditDebit ?? ""
                                }
                            }
                            
                            self.listAllMyAccount.append(tmpAllDataAccount)
                        }
                        
                        print("COUNT ALL MY ACCOUNT")
                        print(self.listAllMyAccount.count)
                        
                        let filterM = listAllMyAccount.filter { word in
                            return word.categoryProduct == "M"
                        }
                        let filterS = listAllMyAccount.filter { word in
                          return word.categoryProduct == "S"
                        }
                        let filterBlankOrNil = listAllMyAccount.filter { word in
                          return word.categoryProduct != "M" && word.categoryProduct != "S"
                        }

                        listSorterAllMyAccount.append(contentsOf: filterM)
                        listSorterAllMyAccount.append(contentsOf: filterS)
                        listSorterAllMyAccount.append(contentsOf: filterBlankOrNil)
                        
                        if self.savingAccountVM.balanceAccount.contains(where: { $0.creditDebit == "D" }) {
                            print("ADA TYPE D")
                            self.isHiddenInformationReStore = false
                        }
                        
                    }
                }
                
                if !success {
                    self.isLoadingCard = false
                    if (self.savingAccountVM.errorCode == "401") {
                        self.showAlertTimeout = true
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
                    ShimmerView()
                        .frame(width: 100, height: 20)
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
            if isLoadingCard || self.listSorterAllMyAccount.isEmpty {
                
                ProgressView("Loading")
                    .padding(.vertical, 50)
                
            } else {
                
                TabView {
                    ForEach(0..<self.listSorterAllMyAccount.count) { index in
                        Button(
                            action: {
                                self.isRouteHistoryAcc = true
                            },
                            label: {
                                VStack {
                                    HStack(alignment: .top) {
                                        Divider()
                                            .frame(width: 3, height: isHiddenBalance ? 70 : 100)
                                            .background(Color(hex: "#232175"))
                                            .padding(.trailing, 5)
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(self.listSorterAllMyAccount[index].description ?? "")")
                                                .font(.headline)
                                                .bold()
                                                .padding(.bottom, 5)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            VStack(alignment: .leading) {
                                                
                                                Text("\(self.listSorterAllMyAccount[index].productName ?? "Tabungan Mestika")")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundColor(Color(hex: "#232175"))
                                                    .fontWeight(.ultraLight)
                                                
                                                Text("\(self.listSorterAllMyAccount[index].sourceNumber ?? "-")")
                                                    .font(.caption)
                                                    .fontWeight(.ultraLight)
                                                
                                                if isHiddenBalance {
                                                    
                                                    EmptyView()
                                                    
                                                } else {
                                                    if (self.listSorterAllMyAccount[index].typeAccount != "M" && self.listSorterAllMyAccount[index].typeAccount != "S") {
                                                        
                                                        HStack {
                                                            Text("Rp.")
                                                                .fontWeight(.light)
                                                                .foregroundColor(Color(hex: "#2334D0"))
                                                            
                                                            Text("-")
                                                                .font(.title3)
                                                                .bold()
                                                                .foregroundColor(Color(hex: "#2334D0"))
                                                        }
                                                        .padding(.top, 5)
                                                        
                                                    } else {
                                                        HStack {
                                                            Text("Rp.")
                                                                .fontWeight(.light)
                                                                .foregroundColor(self.listSorterAllMyAccount[index].debitType == "D" ? .red : Color(hex: "#2334D0"))
                                                            
                                                            Text("\(self.listSorterAllMyAccount[index].debitType == "D" ? "-" : "")" +  "\(self.listSorterAllMyAccount[index].balance?.thousandSeparator() ?? "0")")
                                                                .font(.title3)
                                                                .bold()
                                                                .foregroundColor(self.listSorterAllMyAccount[index].debitType == "D" ? .red : Color(hex: "#2334D0"))
                                                        }
                                                        .padding(.top, 5)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            self.isHiddenBalance.toggle()
                                        }, label: {
                                            Image(systemName: isHiddenBalance ? "eye.slash" : "eye.fill")
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
        .frame(width: UIScreen.main.bounds.width - 30, height: itemHeight)
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
                    self.showAlertTimeout = true
                }
            }
        }
    }
    
    func checkFreezeAccount() {
        self.profileVM.getAccountFreeze { success in
            
            if success {
                
                if profileVM.freezeAccount {
                    self.isHiddenInformationFreezeAccount = false
                } else {
                    self.isHiddenInformationFreezeAccount = true
                }
            }
            
        }
    }
    
    /* Function GET Balance */
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
    
    /* Function GET Info */
    func getUserInfo() {
        self.user.forEach { (data) in
            self.username = data.namaLengkapFromNik!
        }
    }
    
    /* Function GET Kartu-Ku */
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
    
    func getTimeoutParam() {
        print("GET PARAM")
        self.authVM.passwordParam() { success in
            if success {
                print(self.authVM.maxIdleTime)
                self.timeLogout = self.authVM.maxIdleTime
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

struct DashboardAccountModel {
    var sourceNumber: String?
    var typeAccount: String?
    var productName: String?
    var description: String?
    var categoryProduct: String?
}

struct DashboardAllModel {
    var sourceNumber: String?
    var typeAccount: String?
    var productName: String?
    var description: String?
    var categoryProduct: String?
    var balance: String?
    var debitType: String?
}
