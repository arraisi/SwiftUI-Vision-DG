//
//  SnapCarousellView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct SnapCarouselView: View {
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var op : CGFloat = 0
    
    let itemWidth:CGFloat
    let itemHeight:CGFloat
    let itemGapHeight:CGFloat
    
    @Binding var data:[Card]
    
    var callback: (Int) -> ()
    
    var body : some View{
        
        VStack{
            
            HStack(spacing: itemWidth * 0.09){
                
                ForEach(data){card in
                    Image(card.imageName)
                        .resizable()
                        .frame(width: itemWidth, height: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight))
                        .offset(x: self.x)
                        .highPriorityGesture(
                            
                            DragGesture()
                                .onChanged({ (value) in
                                    
                                    if value.translation.width > 0 {
                                        //                                        print("slide right")
                                        self.x = value.location.x
                                    }
                                    else{
                                        //                                        print("slide left")
                                        self.x = value.location.x - self.itemWidth
                                    }
                                    
                                })
                                .onEnded(onDragEnded)
                        )
                }
            }
            .frame(width: itemWidth)
            .offset(x: self.op)
        }
        .edgesIgnoringSafeArea(.bottom)
        .animation(.spring())
        .onAppear {
            
            self.op = ((self.itemWidth + (itemWidth*0.08)) * CGFloat(self.data.count / 2)) - (self.data.count % 2 == 0 ? ((self.itemWidth + (itemWidth*0.08)) / 2) : 0)
            
            self.data[0].isShow = true
        }
    }
    
    // MARK: - ON DRAG ENDED
    private func onDragEnded(value: DragGesture.Value) {
        if value.translation.width > 0 {
            // dragThreshold -> distance of drag to next item
            if value.translation.width > 5 && Int(self.count) != 0 {
                
                self.count -= 1
                self.updateHeight(value: Int(self.count))
                self.x = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            else{
                self.x = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            
        }
        else{
            // dragThreshold -> distance of drag to next item
            if -value.translation.width > 5 && Int(self.count) !=  (self.data.count - 1){
                
                self.count += 1
                self.updateHeight(value: Int(self.count))
                self.x = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            else{
                
                self.x = -((self.itemWidth + (itemWidth*0.08)) * self.count)
            }
            
        }
        
        self.callback(Int(self.count))
    }
    
    // MARK: - UPDATE HEIGHT
    private func updateHeight(value : Int){
        
        for i in 0..<data.count{
            data[i].isShow = false
        }
        
        data[value].isShow = true
    }
}

struct SnapCarousellView_Previews: PreviewProvider {
    static var previews: some View {
        SnapCarouselView(itemWidth: 236, itemHeight: 197, itemGapHeight: 15, data: Binding.constant([
            Card(id: 0, imageName: "rekening-card-3", name: "KARTU 1", description: "KARTU 1", activeStatus: false, isShow: false),
            Card(id: 1, imageName: "rekening-card-4", name: "KARTU 2", description: "KARTU 2", activeStatus: false, isShow: false)
        ])) { index in
        }
    }
}
