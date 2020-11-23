//
//  ChooseTypeSavingScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI
import PopupView
import NavigationStack

struct FormPilihJenisTabunganView: View {
    
    @State var isShowNextView : Bool = false
    
    /* Carousel Variables */
    @State var data = savingTypeData
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    /* Card Variables */
    let itemWidth:CGFloat = 170
    let itemHeight:CGFloat = 150
    let itemGapHeight:CGFloat = 10
    
    @State var showingModal = false
    @EnvironmentObject var registerData: RegistrasiModel
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                Text("Pilih Jenis Tabungan Anda")
                    .font(.subheadline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(hex: "#232175"))
                    .padding(.horizontal, 15)
                    .padding(.top, 40)
                
                // MARK: - CAROUSEL
                VStack{
                    
                    HStack(spacing: itemWidth * 0.08){
                        
                        ForEach(data){card in
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
                .padding(.vertical,25)
                .onAppear {
                    
                    self.firstOffset = ((self.itemWidth + (itemWidth*0.01)) * CGFloat(self.data.count / 2)) - (self.data.count % 2 == 0 ? ((self.itemWidth + (itemWidth*0.2)) / 2) : 0)
                    
                    self.data[0].isShow = true
                }
                
                detailsTypeSaving
                    .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                    .frame(width: UIScreen.main.bounds.width - 60)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                
                Spacer()
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
    }
    
    var detailsTypeSaving: some View {
        VStack(alignment: .leading) {
            Text("Deposit Tabungan")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(hex: "#3756DF"))
                .padding(.top, 10)
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Keunggulan Tabungan :")
                .font(.footnote)
                .padding(.top, 10)
                .padding(.horizontal, 15)
                .foregroundColor(Color(hex: "#5A6876"))
            
            EmptyView()
                .frame(height: 150)
            
            PushView(destination:
                        FormIdentitasDiriView().environmentObject(registerData), isActive: $isShowNextView) {
                
                Button(action: {
                    self.isShowNextView.toggle()
                }, label: {
                    Text("Pilih Tabungan ini")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                })
                
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .padding(.top, 10)
            
        }
        .padding(10)
        .background(Color.white)
    }
    
    // MARK: -Function Create Bottom Loader
    private func createBottomFloater() -> some View {
        SavingSelectionModalView()
            .environmentObject(registerData)
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 220)
            .background(Color(.white))
            .cornerRadius(50)
            .shadow(radius: 60)
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

struct ChooseTypeSavingScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormPilihJenisTabunganView().environmentObject(RegistrasiModel())
    }
}
