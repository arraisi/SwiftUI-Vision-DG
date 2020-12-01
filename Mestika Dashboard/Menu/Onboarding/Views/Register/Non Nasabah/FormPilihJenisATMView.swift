//
//  PilihATMView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/11/20.
//

import SwiftUI
import JGProgressHUD_SwiftUI

struct FormPilihJenisATMView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    @ObservedObject private var productVM = ATMProductViewModel()
    
    /* Carousel Variables */
    @State var cards: [ATMCard] = []
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 100 // 100 is amount padding left and right
    let itemHeight:CGFloat = 190
    let itemGapHeight:CGFloat = 10
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#F6F8FB")
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                AppBarLogo(onCancel: {})
                
                ScrollView(.vertical, showsIndicators: false) {
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
                    .padding(.vertical,25)
                    .onAppear {
                        refreshCarousel()
                    }
                    
                    if cards.count > Int(count) {
                        DetailLimitKartuAtmView(card: cards[Int(count)])
                            .shadow(color: Color(hex: "#2334D0").opacity(0.5), radius: 15, y: 4)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 50)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear() {
            self.fetchATMList()
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
    }
    
    // MARK: - UPDATE HEIGHT
    private func updateHeight(value : Int){
        
        for i in 0..<3 {
            cards[i].isShow = false
        }
        
        cards[value].isShow = true
    }
    
    // MARK: - LOADING HANDLER
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    private func showIndeterminate() {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.3)
            hud.vibrancyEnabled = false
            
            hud.textLabel.text = "Loading"
            
            if !self.productVM.isLoading {
                hud.dismiss(afterDelay: 1)
            }
            
            return hud
        }
    }
    
    // MARK: - FETCH ATM LIST DATA FROM API
    private func fetchATMList() {
        productVM.getListATM() { (success: Bool) in
            if success {
                self.cards = productVM.listATM
                self.refreshCarousel()
            }
        }
    }
}

struct PilihATMView_Previews: PreviewProvider {
    static var previews: some View {
        FormPilihJenisATMView().environmentObject(AddProductATM())
    }
}
