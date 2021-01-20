//
//  PilihATMView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/11/20.
//

import SwiftUI

struct FormPilihJenisATMView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @ObservedObject private var productVM = ATMProductViewModel()
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    
    /* Carousel Variables */
    @State var cards: [ATMViewModel] = []
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    @State var isLoading : Bool = false
    var isAllowBack: Bool = true
    @State var isShowingAlert: Bool = false
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 60 // 100 is amount padding left and right
    let itemHeight:CGFloat = 160
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
                    
                    Text(NSLocalizedString("Pilih Jenis Kartu ATM Anda", comment: ""))
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.top, 15)
                        .padding(.bottom, 0)
                    
                    // MARK: - CAROUSEL
                    VStack{
                        
                        HStack(spacing: itemWidth * 0.08){
                            
                            ForEach(cards, id: \.id){card in
                                ATMCardView(card: card, cardWidth: itemWidth, cardHeight: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight), showContent: false)
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
                        DetailLimitKartuAtmView(card: cards[Int(count)])
                            .shadow(color: Color(hex: "#2334D0").opacity(0.5), radius: 15, y: 4)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 20)
                    }
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear() {
                self.fetchATMList()
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
        
        let card = cards[Int(self.count)]
        selectCard(card: card)
    }
    
    // MARK: - SELECT CARD HANDLER
    func selectCard(card: ATMViewModel) {
        atmData.productType = card.key
    }
    
    // MARK: - UPDATE HEIGHT
    private func updateHeight(value : Int){
        
        for i in 0..<cards.count {
            cards[i].isShow = false
        }
        
        cards[value].isShow = true
    }
    
    // MARK: - FETCH ATM LIST DATA FROM API
    private func fetchATMList() {
        if cards.count == 0 {
            isLoading = true
            productVM.getListATM() { (success: Bool) in
                isLoading = false
                if success {
                    self.cards = productVM.listATM
                    self.refreshCarousel()
                    if cards.count > 0 {
                        self.selectCard(card: self.cards[0])
                    }
                }
            }
        }
    }
}

struct PilihATMView_Previews: PreviewProvider {
    static var previews: some View {
        FormPilihJenisATMView().environmentObject(AddProductATM()).environmentObject(RegistrasiModel())
    }
}
