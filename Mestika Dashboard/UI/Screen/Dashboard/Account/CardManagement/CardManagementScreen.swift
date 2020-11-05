//
//  CardManagementScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct CardManagementScreen: View {
    @State var data = myCardData
    
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    let itemWidth:CGFloat = 236
    let itemHeight:CGFloat = 197
    let itemGapHeight:CGFloat = 15
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack() {
                // MARK: - CAROUSEL
                VStack{
                    
                    HStack(spacing: itemWidth * 0.09){
                        
                        ForEach(data){card in
                            Image(card.imageName)
                                .resizable()
                                .frame(width: itemWidth, height: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight))
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
                .padding(.vertical,40)
                .animation(.spring())
                .onAppear {
                    
                    self.firstOffset = ((self.itemWidth + (itemWidth*0.08)) * CGFloat(self.data.count / 2)) - (self.data.count % 2 == 0 ? ((self.itemWidth + (itemWidth*0.08)) / 2) : 0)
                    
                    self.data[0].isShow = true
                }
                
                if !data[Int(self.count)].activeStatus {
                    DetailKartuTidakAktifView()
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                }
                else {
                    DetailKartuAktifView(data: data[Int(self.count)])
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                }
                
                Spacer()
                
            }
            .padding(.vertical, 100)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Kartu-Ku", displayMode: .inline)
    }
    
    // MARK: - ON DRAG ENDED
    private func onDragEnded(value: DragGesture.Value) {
        if value.translation.width > 0 {
            // dragThreshold -> distance of drag to next item
            if value.translation.width > 5 && Int(self.count) != 0 {
                
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
            if -value.translation.width > 5 && Int(self.count) !=  (self.data.count - 1){
                
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
            data[i].isShow = false
        }
        
        data[value].isShow = true
    }
}

struct CardManagementScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardManagementScreen()
    }
}
