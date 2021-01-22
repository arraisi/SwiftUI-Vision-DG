//
//  ChooseTypeSavingScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI
import JGProgressHUD_SwiftUI

struct FormPilihJenisTabunganView: View {
    
    @EnvironmentObject var appState: AppState
    
    /* Carousel Variables */
//    @State var data = savingTypeData
    @State var firstOffset : CGFloat = 0
    @State var offset : CGFloat = 0
    @State var count : CGFloat = 0
    
    @State var goToNextPage: Bool = false
    @State var backToSummary: Bool = false
    
    @State var referenceCode: String = ""
    
    @State var scale: CGFloat = 0
    
    @ObservedObject private var productVM = ATMProductViewModel()
    @State var cards: [JenisTabunganViewModel] = []
    @State private var isLoading = false
    
    /* Card Variables */
    let itemWidth:CGFloat = UIScreen.main.bounds.width - 100 // 100 is amount padding left and right
    let itemHeight:CGFloat = (160.0/290.0 * (UIScreen.main.bounds.width - 100))
    let itemGapHeight:CGFloat = 10
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
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
    
    // Routing variables
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        LoadingView(isShowing: self.$isLoading) {
            ZStack(alignment: .top) {
                
                VStack {
                    Color(hex: "#232175")
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    AppBarLogo(light: false, onCancel: {})
                    
                    Text(NSLocalizedString("Pilih Jenis Tabungan Anda", comment: ""))
                        .font(.custom("Montserrat-SemiBold", size: 15))
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.horizontal, 15)
                        .padding(.top, 20)
                    
                    // MARK: - CAROUSEL
                    VStack{
                        
                        HStack(spacing: itemWidth * 0.08){
                            
                            ForEach(cards, id: \.id){ card in
                                CardTypeSavingView(card: card, cardWidth: itemWidth, cardHeight: card.isShow == true ? itemHeight:(itemHeight-itemGapHeight))
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
                    .padding(.vertical,10)
                    .onAppear {
                        refreshCarousel()
                    }
                    
                    if self.cards.count > Int(self.count) {
                        DetailsTypeSavingView(data: self.cards[Int(self.count)], isShowModal: $showingModal, isShowModalDetail: $showingModalDetail)
                            .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                            .padding(.bottom, 30)
                    }
                    Spacer()
                }
                
                if self.showingModalDetail {
                    ZStack {
                        
                        ModalOverlay(tapAction: { withAnimation {
                            self.showingModalDetail = false
                        } })
                        .edgesIgnoringSafeArea(.all)
                        
                        
                        popupDetailSaving()
                    }
                    .transition(.asymmetric(insertion: .opacity, removal: .fade))
                }
                
                if self.showingModal {
                    ZStack {
                        ModalOverlay(tapAction: { withAnimation {
                            self.showingModal = false
                            
                        } })
                        .edgesIgnoringSafeArea(.all)
                        
                        createBottomFloater()
                        
                    }
                    .transition(.asymmetric(insertion: .opacity, removal: .fade))
                }
                
                NavigationLink(destination: FormIdentitasDiriView().environmentObject(registerData), isActive: $goToNextPage) {
                    EmptyView()
                }
                
                NavigationLink(destination: VerificationRegisterDataView().environmentObject(registerData), isActive: $backToSummary) {
                    EmptyView()
                }
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchJenisTabunganList()
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Apakah ingin membatalkan registrasi ?", comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YA", comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("Tidak", comment: ""))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.showingAlert = true
            }
        }))
    }
    
    // MARK: - REFRESH THE CARD ITEM OFFSET
    private func refreshCarousel() {
        let offsetFirstItem = ((self.itemWidth + (itemWidth*0.08)) * CGFloat(self.cards.count / 2))
        let offsetMiddleItem = (self.cards.count % 2 == 0 ? ((self.itemWidth + (UIScreen.main.bounds.width*0.15)) / 2) : 0)
        self.firstOffset = offsetFirstItem - offsetMiddleItem
        
        if cards.count > 0 {
            self.cards[0].isShow = true
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
        SavingDetailModalView(data: self.cards[Int(self.count)], isShowModalDetail: $showingModalDetail)
            .environmentObject(registerData)
            .environmentObject(atmData)
            .background(Color(.white))
            .cornerRadius(15)
    }
    
    // MARK: -Function Create Bottom Loader
    private func createBottomFloater() -> some View {
        SavingSelectionModalView(data: self.cards[Int(self.count)], editMode: $editMode, isShowModal: $showingModal, showingReferralCodeModal: $showingReferralCodeModal, goToNextPage: $goToNextPage, backToSummary: $backToSummary)
            .environmentObject(registerData)
            .environmentObject(atmData)
            .background(Color(.white))
            .cornerRadius(15)
        
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
        
        for i in 0..<cards.count{
            cards[i].isShow = false
        }
        
        cards[value].isShow = true
    }
    
    // MARK: - FETCH JENIS TABUNGAN LIST DATA FROM API
    private func fetchJenisTabunganList() {
        if cards.count == 0 {
            isLoading = true
            productVM.getListJenisTabungan { (success: Bool) in
                isLoading = false
                if success {
                    self.cards = productVM.listJenisTabungan
                    self.refreshCarousel()
                    //                    if cards.count > 0 {
                    //                        self.selectCard(selected: 0)
                    //                    }
                }
            }
        }
    }
}

struct ChooseTypeSavingScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormPilihJenisTabunganView(shouldPopToRootView: .constant(false)).environmentObject(RegistrasiModel())
            .environmentObject(AddProductATM())
    }
}
