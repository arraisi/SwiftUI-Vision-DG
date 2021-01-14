//
//  ChooseTypeSavingScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI
import PopupView

struct FormPilihJenisTabunganView: View {
    
    /* Carousel Variables */
    @State var data = savingTypeData
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    @State var goToNextPage: Bool = false
    
    @State var referenceCode: String = ""
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 170 // 100 is amount padding left and right
    let itemHeight:CGFloat = 150
    let itemGapHeight:CGFloat = 10
    
    @GestureState private var dragOffset = CGSize.zero
    
    @Binding var shouldPopToRootView : Bool
    
    @State var showingModal = false
    @State var showingReferralCodeModal = false
    @State var showingModalDetail = false
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var atmData: AddProductATM
    
    var disableSubmitReferralCodeBtn: Bool {
        atmData.atmAddresspostalReferral == ""
    }
    
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
                    
                    Text(NSLocalizedString("Pilih Jenis Tabungan Anda", comment: ""))
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
                        DetailsTypeSavingView(data: self.data[Int(self.count)], isShowModal: $showingModal, isShowModalDetail: $showingModalDetail)
                            .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    }
                    Spacer()
                }
                .padding(.vertical, 30)
            }
            
            if self.showingModalDetail {
                ModalOverlay(tapAction: { withAnimation {
                    self.showingModalDetail = false
                } })
                .edgesIgnoringSafeArea(.all)
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation {
                    self.showingModal = false
                    
                } })
                .edgesIgnoringSafeArea(.all)
            }
            if self.showingReferralCodeModal {
                ModalOverlay(tapAction: { withAnimation {
                    
                    self.showingReferralCodeModal = false
                    
                } })
                .edgesIgnoringSafeArea(.all)
            }
            
            NavigationLink(destination: FormIdentitasDiriView().environmentObject(registerData), isActive: $goToNextPage) {
                EmptyView()
            }
        }
        .edgesIgnoringSafeArea(.all)
        //        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
//        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
//
//            if(value.startLocation.x < 20 && value.translation.width > 100) {
//                self.shouldPopToRootView = false
//            }
//
//        }))
        .popup(isPresented: $showingModal, type: .`default`, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
        .popup(isPresented: $showingModalDetail, type: .`default`, animation: Animation.spring(), closeOnTapOutside: true) {
            popupDetailSaving()
        }
        .popup(isPresented: $showingReferralCodeModal, type: .floater(), position: .top, animation: Animation.spring(), closeOnTapOutside: true) {
            referralCodeModal()
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
            Text(NSLocalizedString("Deposit Tabungan", comment: ""))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#3756DF"))
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(NSLocalizedString("Keunggulan Tabungan :", comment: ""))
                .font(.custom("Montserrat-Regular", size: 12))
                .padding(.vertical, 10)
                .foregroundColor(Color(hex: "#5A6876"))
            
            EmptyView()
                .frame(height: 150)
            
            NavigationLink(destination: FormIdentitasDiriView().environmentObject(registerData)) {
                
                Text(NSLocalizedString("Pilih Tabungan ini", comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 10)
            .padding(.top, 10)
            
        }
        .padding(.bottom, 15)
        .padding([.horizontal, .top], 25)
        .background(Color.white)
    }
    
    private func popupDetailSaving() -> some View {
        SavingDetailModalView(data: self.data[Int(self.count)], isShowModalDetail: $showingModalDetail)
            .environmentObject(registerData)
            .environmentObject(atmData)
            .frame(width: UIScreen.main.bounds.width - 40)
            .background(Color(.white))
            .cornerRadius(15)
    }
    
    // MARK: -Function Create Bottom Loader
    private func createBottomFloater() -> some View {
        SavingSelectionModalView(data: self.data[Int(self.count)], isShowModal: $showingModal, showingReferralCodeModal: $showingReferralCodeModal, goToNextPage: $goToNextPage)
            .environmentObject(registerData)
            .environmentObject(atmData)
            .frame(width: UIScreen.main.bounds.width - 40)
            .background(Color(.white))
            .cornerRadius(15)
    }
    
    private func referralCodeModal() -> some View {
        VStack {
            VStack {
                Text(NSLocalizedString("Do you have a referral code?", comment: ""))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 16))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 25, leading: 15, bottom: 10, trailing: 15))
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    
                    TextField(NSLocalizedString("Masukkan kode referal", comment: ""), text: $atmData.atmAddresspostalReferral) { changed in
                        
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 50)
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                NavigationLink(
                    destination: FormIdentitasDiriView().environmentObject(registerData)
                ){
                    Text(NSLocalizedString("Yes I do, Submit now", comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .background(Color(hex: disableSubmitReferralCodeBtn ? "#CBD1D9" : "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 5)
                .padding(.top, 10)
                .disabled(disableSubmitReferralCodeBtn)
                
                NavigationLink(
                    destination: FormIdentitasDiriView().environmentObject(registerData)
                ){
                    Text(NSLocalizedString("No, I don't", comment: ""))
                        .foregroundColor(.gray)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .cornerRadius(12)
                
            }
            .padding(EdgeInsets(top: 0, leading: 25, bottom: 20, trailing: 25))
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.vertical, 20)
        
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
        FormPilihJenisTabunganView(shouldPopToRootView: .constant(false)).environmentObject(RegistrasiModel())
            .environmentObject(AddProductATM())
    }
}
