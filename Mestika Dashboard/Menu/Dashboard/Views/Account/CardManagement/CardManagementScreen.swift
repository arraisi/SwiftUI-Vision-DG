//
//  CardManagementScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct CardManagementScreen: View {
    
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
    
    var body: some View {
        LoadingView(isShowing: self.$isLoading) {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    Color(hex: "#F6F8FB")
                    
                    VStack() {
                        // MARK: - CAROUSEL
                        VStack{
                            
                            HStack(spacing: itemWidth * itemGapWidth){
                                
                                ForEach(self.cards, id: \.id){ card in
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
                            if cards[Int(self.count)].status == "ACTIVE" {
                                DetailKartuAktifView(card: cards[Int(self.count)])
                                    .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                                    .frame(width: UIScreen.main.bounds.width - 60)
                                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            } else {
                                DetailKartuTidakAktifView(card: cards[Int(self.count)])
                                    .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                                    .frame(width: UIScreen.main.bounds.width - 60)
                                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .navigationBarTitle("Kartu-Ku", displayMode: .inline)
                .onAppear {
                    getListKartuKu()
                }
            }
            .background(Color(hex: "#F6F8FB")
                            .edgesIgnoringSafeArea(.all))
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

struct CardManagementScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardManagementScreen()
    }
}
