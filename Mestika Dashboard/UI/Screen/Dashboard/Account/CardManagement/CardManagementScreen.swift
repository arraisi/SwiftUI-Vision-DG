//
//  CardManagementScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct CardManagementScreen: View {
    
    /* Carousel Variables */
    @State var cards = myCardData
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = 236
    let itemHeight:CGFloat = 197
    let itemGapHeight:CGFloat = 10
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                Color(hex: "#F6F8FB")
                
                VStack() {
                    // MARK: - CAROUSEL
                    VStack{
                        
                        HStack(spacing: itemWidth * 0.08){
                            
                            ForEach(cards){card in
                                CardView(background: Image("card_bg"), rekeningName: card.rekeningName, saldo: card.saldo, rekeningNumber: card.rekeningNumber, activeStatus: card.activeStatus, cardWidth: itemWidth, cardHeight: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight))
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
                        
                        self.firstOffset = ((self.itemWidth + (itemWidth*0.01)) * CGFloat(self.cards.count / 2)) - (self.cards.count % 2 == 0 ? ((self.itemWidth + (itemWidth*0.2)) / 2) : 0)
                        
                        self.cards[0].isShow = true
                    }
                    if !cards[Int(self.count)].activeStatus {
                        DetailKartuTidakAktifView(card: cards[Int(self.count)])
                            .clipShape(PopupBubble(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                            .frame(width: UIScreen.main.bounds.width - 60)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    }
                    else {
                        DetailKartuAktifView(card: cards[Int(self.count)])
                            .clipShape(PopupBubble(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                            .frame(width: UIScreen.main.bounds.width - 60)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Kartu-Ku", displayMode: .inline)
        }
        .background(Color(hex: "#F6F8FB")
                        .edgesIgnoringSafeArea(.all))
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
        
        for i in 0..<data.count{
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
