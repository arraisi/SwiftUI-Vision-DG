//
//  CarouselWelcomeView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 25/11/20.
//

import SwiftUI

struct WelcomeViewCarousel: View {
    
    /* Carousel Variables */
    @Binding var data: [String]
    
    let screen = UIScreen.main.bounds.width - 30
    let spacing: CGFloat = 20
    
    @State var itemIndex : CGFloat = 0
    @State var firstItemPosition : CGFloat = 0
    @State var currentItemPosition : CGFloat = 0
    
    let callback:(Int)->()
    
    var body: some View {
        VStack{
            
            HStack(spacing: 20){
                
                ForEach(0..<data.count) { i in
                    
                    Image(data[i])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.screen)
                        .offset(x: self.currentItemPosition)
                        .highPriorityGesture(
                            
                            DragGesture()
                                .onChanged({ (value) in
                                    
                                    if value.translation.width > 0 {
                                        self.currentItemPosition = value.location.x
                                    }
                                    else {
                                        self.currentItemPosition = value.location.x - self.screen
                                    }
                                    
                                })
                                .onEnded(onDragEnded)
                        )
                }
            }
            .frame(width: self.screen)
            .offset(x: self.firstItemPosition)
            
        }
        .animation(.spring())
        .onAppear {
            let offsetFirstItem = ((self.screen + self.spacing) * CGFloat(self.data.count / 2))
            let offsetMiddleItem = (self.data.count % 2 == 0 ? ((self.screen + self.spacing) / 2) : 0)
            self.firstItemPosition = offsetFirstItem - offsetMiddleItem
        }
    }
    
    // MARK: - ON DRAG ENDED
    private func onDragEnded(value: DragGesture.Value) {
        
        if value.translation.width > 0 {
            
            if value.translation.width > ((self.screen - 80) / 2) && Int(self.itemIndex) != 0 {
                
                self.itemIndex -= 1
                self.currentItemPosition = -((self.screen + self.spacing) * self.itemIndex)
            }
            else{
                self.currentItemPosition = -((self.screen + self.spacing) * self.itemIndex)
            }
            
        }
        else{
            
            if -value.translation.width > ((self.screen - 80) / 2) && Int(self.itemIndex) !=  (self.data.count - 1){
                
                self.itemIndex += 1
                self.currentItemPosition = -((self.screen + self.spacing) * self.itemIndex)
            }
            else{
                
                self.currentItemPosition = -((self.screen + self.spacing) * self.itemIndex)
            }
            
        }
        
        self.callback(Int(self.itemIndex))
    }
}

struct CarouselWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeViewCarousel(data: Binding.constant(["slider_pic_1", "slider_pic_2", "slider_pic_3"]
        )) { itemIndex in
            
        }
    }
}
