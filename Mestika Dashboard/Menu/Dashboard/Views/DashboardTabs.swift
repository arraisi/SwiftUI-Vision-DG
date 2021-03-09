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
    
    /* Loading and Data Variable */
    @State var isLoading : Bool = true
    @State var kartkuKu = KartuKuResponse()
    
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var username: String = ""
    @State var balance: String = ""
    @State var productName: String = "-"
    @State var accountNumber: String = "-"
    
    @Binding var cardNo: String
    @State var cardName: String = "-"
    @Binding var sourceNumber: String
    
    @State var isDetailCard: Bool = false
    
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
                
                GridMenuView(cardNo: $cardNo, sourceNumber: $sourceNumber)
                
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
                        
                        ForEach(self.cards, id: \.id) { card in
                            
                            NavigationLink(
                                destination: MyCardDashboardView(cards: .constant(card))) {
                                CardView(card: card, cardWidth: itemWidth, cardHeight: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight), showContent: true)
                                    .offset(x: self.offset)
                                    .highPriorityGesture(
                                        
                                        DragGesture()
                                            .onChanged({ (value) in
                                                
                                                if value.translation.width > 0 {
                                                    self.offset = value.location.x
                                                }
                                                else{
                                                    self.offset = value.location.x - self.itemWidth
                                                }
                                                
                                            })
                                            .onEnded(onDragEnded)
                                    )
                            }
                        }
                    }
                    .animation(.spring())
                    .frame(width: itemWidth)
                    .offset(x: self.firstOffset)
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
            getListKartuKu()
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
                                Text("Balance hidden".localized(language))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                Text("Main Account Balance".localized(language))
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
