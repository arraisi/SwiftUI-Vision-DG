//
//  PilihDesainATMView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI
import NavigationStack
import JGProgressHUD_SwiftUI
import SystemConfiguration

struct FormPilihDesainATMView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    @ObservedObject private var productVM = ATMProductViewModel()
    @EnvironmentObject var appState: AppState
    
    @State var nextRoute: Bool = false
    
    @State var cards: [ATMDesignViewModel] = []
    @State private var titleCard = "THE CARD"
    @State private var isLoading = false
    
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    @State var isShowingAlert: Bool = false
    @State var isShowAlertInternetConnection = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 100 // 100 is amount padding left and right
    let itemHeight:CGFloat = (160.0/290.0 * (UIScreen.main.bounds.width - 100))
    let itemGapHeight:CGFloat = 10
    
    var body: some View {
        
        LoadingView(isShowing: $isLoading) {
            
            ZStack(alignment: .top) {
                
                VStack {
                    Color(hex: "#F6F8FB")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    Color(hex: "#232175")
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    AppBarLogo(light: false, onCancel: {})
                    
                    Text(NSLocalizedString("Pilih Desain Kartu ATM Anda", comment: ""))
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.top, 25)
                        .padding(.bottom, 10)
                    
                    // MARK: - CAROUSEL
                    VStack{
                        
                        HStack(spacing: itemWidth * 0.08){
                            
                            ForEach(cards, id: \.id){ card in
                                ATMCardDesignView(card: card, cardWidth: itemWidth, cardHeight: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight), showContent: false)
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
                        .frame(width: itemWidth)
                        .offset(x: self.firstOffset)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .animation(.spring())
                    .padding(.vertical,10)
                    .onAppear {
                        refreshCarousel()
                    }
                    
                    if cards.count > Int(count) {
                        VStack {
                            VStack {
                                HStack {
                                    Text(cards[Int(count)].title)
                                        .font(.custom("Montserrat-SemiBold", size: 15))
                                    
                                    Spacer()
                                }
                                .padding()
                                .padding(.top, 30)
                                
                                ScrollView {
                                    HStack{
                                        Text(cards[Int(count)].description)
                                            .font(.custom("Montserrat-Light", size: 12))
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                
                                NavigationLink(
                                    destination: FormCompletionKartuATMView().environmentObject(atmData).environmentObject(registerData),
                                    isActive: self.$nextRoute
                                ) {
                                    EmptyView()
                                }
                                
                                Button {
                                    self.registerData.desainKartuATMImage = cards[Int(count)].cardImageBase64!
                                    self.nextRoute = true
                                } label: {
                                    Text(NSLocalizedString("PILIH DESAIN KARTU", comment: ""))
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                }
                                .frame(height: 50)
                                .background(Color(hex: "#2334D0"))
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .padding(.vertical, 20)
                                
                            }
                            .animation(nil)
                            //                .transition(.flipFromLeft)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color(.white)))
                            .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                            .shadow(color: Color(hex: "#2334D0").opacity(0.5), radius: 15, y: 4)
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 50)
                        .padding(.vertical)
                    }
                }
                if (self.isShowAlertInternetConnection) {
                    ModalOverlay(tapAction: { withAnimation {
                    self.isShowAlertInternetConnection = false
                    } })
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                if self.isNetworkReachability(with: flags) {
                    self.fetchATMDesignList()
                    print("\(itemWidth):\(itemHeight)")
                } else {
                    self.isShowAlertInternetConnection = true
                }
                
            }
            .popup(isPresented: $isShowAlertInternetConnection, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                PopupNoInternetConnection()
            }
            .alert(isPresented: $isShowingAlert) {
                return Alert(
                    title: Text(NSLocalizedString("Apakah ingin membatalkan registrasi ?", comment: "")),
                    primaryButton: .default(Text(NSLocalizedString("YA", comment: "")), action: {
                        self.appState.moveToWelcomeView = true
                    }),
                    secondaryButton: .cancel(Text(NSLocalizedString("Tidak", comment: ""))))
            }
            .gesture(DragGesture().onEnded({ value in
                if(value.startLocation.x < 20 &&
                    value.translation.width > 100) {
                    self.isShowingAlert = true
                }
            }))
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
                self.offset = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            else{
                self.offset = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            
        }
        else{
            // dragThreshold -> distance of drag to next item
            if -value.translation.width > self.itemWidth / 4 && Int(self.count) !=  (self.cards.count - 1){
                
                self.count += 1
                self.updateHeight(value: Int(self.count))
                self.offset = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            else{
                
                self.offset = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            
        }
        
        selectCard(selected: Int(self.count))
    }
    
    func selectCard(selected: Int) {
        if cards.count > selected {
            let card = cards[selected]
            print(card)
            atmData.atmDesignType = card.key
            atmData.imageDesign = card.cardImage?.absoluteString ?? ""
        }
    }
    
    // MARK: - PAGES APPEARANCE
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        UIPageControl.appearance().pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.1968375428)
    }
    
    // MARK: - UPDATE HEIGHT
    private func updateHeight(value : Int){
        
        for i in 0..<cards.count {
            cards[i].isShow = false
        }
        
        cards[value].isShow = true
    }
    
    // MARK: - FETCH ATM LIST DATA FROM API
    private func fetchATMDesignList() {
        if cards.count == 0 {
            isLoading = true
            productVM.getListATMDesign(type: atmData.productType) { (success: Bool) in
                isLoading = false
                if success {
                    self.cards = productVM.listATMDesign
                    self.refreshCarousel()
                    if cards.count > 0 {
                        self.selectCard(selected: 0)
                    }
                }
            }
        }
    }
    
    func PopupNoInternetConnection() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Please check your internet connection")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.isShowAlertInternetConnection = false
                    appState.moveToWelcomeView = true
                },
                label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    func isNetworkReachability(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }
}

struct PilihDesainATMView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormPilihDesainATMView().environmentObject(AddProductATM()).environmentObject(RegistrasiModel())
        }
    }
}
