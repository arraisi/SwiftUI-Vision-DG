//
//  InfiniteCarousellView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 03/11/20.
//

import SwiftUI

struct InfiniteCarousellView: View {
    @GestureState private var dragState = DragState.inactive
    @State var carouselLocation = 0
    
    var itemWidth:CGFloat
    var itemHeight:CGFloat
    var itemGapHeight:CGFloat
    var views:[Card]
    var callback: (Int) -> ()
    
    private func onDragEnded(drag: DragGesture.Value) {
        print("drag ended")
        let dragThreshold:CGFloat = itemWidth - 100
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold{
            carouselLocation =  carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)
        {
            carouselLocation =  carouselLocation + 1
        }
        callback(relativeLoc())
    }
    
    var body: some View {
        
        
        /* PRINT STATUS */
        
        //        ZStack{
        //                        VStack{
        //                            Text("\(dragState.translation.width)")
        //                            Text("Carousel Location = \(carouselLocation)")
        //                            Text("Relative Location = \(relativeLoc())")
        //                            Text("\(relativeLoc()) / \(views.count-1)")
        //                            Spacer()
        //                        }
        
        /* CONTENT VIEW */
        
        VStack{
            
            ZStack{
                ForEach(0..<views.count){i in
                    VStack{
                        Image(views[i].img)
                            .frame(width:236, height: self.getItemHeight(i))
                            .animation(.interpolatingSpring(stiffness: Double(itemWidth), damping: Double(itemWidth)/10, initialVelocity: 10.0))
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 3)
                            .opacity(self.getOpacity(i))
                            .animation(.interpolatingSpring(stiffness: Double(itemWidth), damping: Double(itemWidth)/10, initialVelocity: 10.0))
                            .offset(x: self.getOffset(i))
                            .animation(.interpolatingSpring(stiffness: Double(itemWidth), damping: Double(itemWidth)/10, initialVelocity: 10.0))
                    }
                }
                
            }
            .gesture(
                
                DragGesture()
                    .updating($dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation)
                    }
                    .onEnded(onDragEnded)
                
            )
        }
        
        /* PRINT PAGGING */
        
        //            VStack{
        //                Spacer()
        //                Spacer().frame(height:itemHeight + 50)
        //                Text("\(relativeLoc() + 1)/\(views.count)").padding()
        //                Spacer()
        //            }
        //        }
    }
    
    func relativeLoc() -> Int{
        return ((views.count * 10000) + carouselLocation) % views.count
    }
    
    func getItemHeight(_ i:Int) -> CGFloat{
        if i == relativeLoc(){
            return itemHeight
        } else {
            return itemHeight - itemGapHeight
        }
    }
    
    func getOpacity(_ i:Int) -> Double{
        
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - views.count == relativeLoc()
            || (i - 1) + views.count == relativeLoc()
            || (i + 2) - views.count == relativeLoc()
            || (i - 2) + views.count == relativeLoc()
        {
            return 1
        } else {
            return 0
        }
    }
    
    func getOffset(_ i:Int) -> CGFloat{
        
        //This sets up the central offset
        if (i) == relativeLoc()
        {
            //Set offset of cental
            return self.dragState.translation.width
        }
        //These set up the offset +/- 1
        else if
            (i) == relativeLoc() + 1
                ||
                (relativeLoc() == views.count - 1 && i == 0)
        {
            //Set offset +1
            return self.dragState.translation.width + (236 + 20)
        }
        else if
            (i) == relativeLoc() - 1
                ||
                (relativeLoc() == 0 && (i) == views.count - 1)
        {
            //Set offset -1
            return self.dragState.translation.width - (236 + 20)
        }
        //These set up the offset +/- 2
        else if
            (i) == relativeLoc() + 2
                ||
                (relativeLoc() == views.count-1 && i == 1)
                ||
                (relativeLoc() == views.count-2 && i == 0)
        {
            return self.dragState.translation.width + (2*(236 + 20))
        }
        else if
            (i) == relativeLoc() - 2
                ||
                (relativeLoc() == 1 && i == views.count-1)
                ||
                (relativeLoc() == 0 && i == views.count-2)
        {
            //Set offset -2
            return self.dragState.translation.width - (2*(236 + 20))
        }
        //These set up the offset +/- 3
        else if
            (i) == relativeLoc() + 3
                ||
                (relativeLoc() == views.count-1 && i == 2)
                ||
                (relativeLoc() == views.count-2 && i == 1)
                ||
                (relativeLoc() == views.count-3 && i == 0)
        {
            return self.dragState.translation.width + (3*(236 + 20))
        }
        else if
            (i) == relativeLoc() - 3
                ||
                (relativeLoc() == 2 && i == views.count-1)
                ||
                (relativeLoc() == 1 && i == views.count-2)
                ||
                (relativeLoc() == 0 && i == views.count-3)
        {
            //Set offset -2
            return self.dragState.translation.width - (3*(236 + 20))
        }
        //This is the remainder
        else {
            return 10000
        }
    }
    
    
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
