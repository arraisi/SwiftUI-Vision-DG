//
//  MyCardDashboardView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/03/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyCardDashboardView: View {
    
    /* Carousel Variables */
    @Binding var cards: KartuKuDesignViewModel
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 140 // 100 is amount padding left and right
    let itemHeight:CGFloat = 197
    let itemGapHeight:CGFloat = 10
    let itemGapWidth:CGFloat = 0.14
    
    /* Loading and Data Variable */
    @State var isLoading : Bool = false
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
                                CardView(card: cards, cardWidth: itemWidth, cardHeight: cards.isShow == true ? itemHeight:(itemHeight-itemGapHeight), showContent: true)
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
                                    )
                            }
                            .frame(width: itemWidth)
                            .offset(x: self.firstOffset)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                        .animation(.spring())
                        .padding(.vertical, 25)
                        
                        if cards.status == "ACTIVE" {
                            DetailKartuAktifView(card: cards)
                                .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                                .frame(width: UIScreen.main.bounds.width - 60)
                                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                        } else {
                            DetailKartuTidakAktifView(card: cards)
                                .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
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
    }
}
