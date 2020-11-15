//
//  PilihJenisATMView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI

struct UnusedPilihJenisATMView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    /* Carousel Variables */
    @State var cards = myCardData
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 100 // 100 is amount padding left and right
    let itemHeight:CGFloat = 190
    let itemGapHeight:CGFloat = 10
    
    var body: some View {
        VStack {
            AppBar
                .padding(.top, 45)
                .padding(.horizontal, 30)
            
            ScrollView{
                
                Text("Pilih Desain Kartu ATM Anda")
                    .font(.custom("Montserrat-SemiBold", size: 18))
                    .foregroundColor(Color(hex: "#232175"))
                    .padding(.top, 25)
                    .padding(.bottom, 10)
                
                // MARK: - CAROUSEL
                VStack{
                    
                    HStack(spacing: itemWidth * 0.08){
                        
                        ForEach(cards){card in
                            CardView(card: card, cardWidth: itemWidth, cardHeight: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight), showContent: false)
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
                    
                    self.firstOffset = ((self.itemWidth + (itemWidth*0.08)) * CGFloat(self.cards.count / 2)) - (self.cards.count % 2 == 0 ? ((self.itemWidth + (UIScreen.main.bounds.width*0.15)) / 2) : 0)
                    
                    self.cards[0].isShow = true
                }
                
                DetailLimitKartuAtmView(card: cards[Int(self.count)])
                    .shadow(color: Color(hex: "#2334D0").opacity(0.5), radius: 15, y: 4)
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(true)
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
    
    // MARK: - APP BAR
    var AppBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color(hex: "#232175"))
            }
            Spacer()
            logo
            Spacer()
        }
    }
    
    // MARK: - LOGO
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            Image("Logo M")
                .resizable()
                .frame(width: 25, height: 25)
            Text("BANK MESTIKA")
                .foregroundColor(Color(hex: "#232175"))
                .font(.system(size: 20))
                .bold()
        }
    }
    
    // MARK: - PAGES APPEARANCE
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        UIPageControl.appearance().pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.1968375428)
    }
    
}

// MARK: - ROW DETAIL ATM
struct RowDetailATM: View {
    var title: String = ""
    var value: String = ""
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Text(title)
                        .font(.custom("Montserrat-Light", size: 10))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Text(value)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .foregroundColor(Color(hex: "#232175"))
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
            }
            
            
        }
    }
}

struct PilihJenisATMView_Previews: PreviewProvider {
    static var previews: some View {
        UnusedPilihJenisATMView()
    }
}
