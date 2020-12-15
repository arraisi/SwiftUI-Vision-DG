//
//  JenisTabunganV2.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 02/12/20.
//

import SwiftUI

struct JenisTabunganRegisterNasabahView: View {
    
    /* Carousel Variables */
    @State var data = savingTypeData
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 170 // 100 is amount padding left and right
    let itemHeight:CGFloat = 150
    let itemGapHeight:CGFloat = 10
    
    @GestureState private var dragOffset = CGSize.zero
    
    @Binding var shouldPopToRootView : Bool
    
    @State var showingModal = false
    @EnvironmentObject var registerData: RegistrasiModel
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 100)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                VStack() {
                    
                    Text("Pilih Jenis Tabungan Anda")
                        .font(.custom("Montserrat-SemiBold", size: 15))
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.horizontal, 15)
                        .padding(.top, 20)
                    
                    // MARK: - CAROUSEL
                    VStack{
                        
                        HStack(spacing: itemWidth * 0.08){
                            
                            ForEach(data, id: \.id){ card in
                                CardTypeSavingView(image: Image(card.imageName), cardWidth: itemWidth, cardHeight: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight))
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
                    .padding(.vertical, 25)
                    .onAppear {
                        refreshCarousel()
                    }
                    
                    if self.data.count > Int(self.count) {
                        DetailsTypeSavingView(data: self.data[Int(self.count)], isShowModal: $showingModal)
                            .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    }
                    Spacer()
                }
                .padding(.vertical, 30)
            }
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
//        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in

            if(value.startLocation.x < 20 && value.translation.width > 100) {
                self.shouldPopToRootView = false
            }

        }))
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
    }
    
    // MARK: - REFRESH THE CARD ITEM OFFSET
    private func refreshCarousel() {
        let offsetFirstItem = ((self.itemWidth + (itemWidth*0.08)) * CGFloat(self.data.count / 2))
        let offsetMiddleItem = (self.data.count % 2 == 0 ? ((self.itemWidth + (UIScreen.main.bounds.width*0.15)) / 2) : 0)
        self.firstOffset = offsetFirstItem - offsetMiddleItem
        
        if data.count > 0 {
            self.data[0].isShow = true
        }
    }
    
    var detailsTypeSaving: some View {
        VStack(alignment: .leading) {
            Text("Deposit Tabungan")
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#3756DF"))
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Keunggulan Tabungan :")
                .font(.custom("Montserrat-Regular", size: 12))
                .padding(.vertical, 10)
                .foregroundColor(Color(hex: "#5A6876"))
            
            EmptyView()
                .frame(height: 150)
            
//            NavigationLink(destination: FormIdentitasDiriRegisterNasabahView().environmentObject(registerData)) {
//                
//                Text("Pilih Tabungan ini")
//                    .foregroundColor(.white)
//                    .font(.custom("Montserrat-SemiBold", size: 14))
//                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
//                
//            }
//            .background(Color(hex: "#2334D0"))
//            .cornerRadius(12)
//            .padding(.bottom, 10)
//            .padding(.top, 10)
            
        }
        .padding(.bottom, 15)
        .padding([.horizontal, .top], 25)
        .background(Color.white)
    }
    
    // MARK: -Function Create Bottom Loader
    private func createBottomFloater() -> some View {
        SavingSelectionModalView(data: self.data[Int(self.count)], isShowModal: $showingModal)
            .environmentObject(registerData)
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 150)
            .background(Color(.white))
            .cornerRadius(30)
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
            if -value.translation.width > self.itemWidth / 4 && Int(self.count) !=  (self.data.count - 1){
                
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

struct JenisTabunganRegisterNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        JenisTabunganRegisterNasabahView(shouldPopToRootView: .constant(false)).environmentObject(RegistrasiModel())
    }
}
