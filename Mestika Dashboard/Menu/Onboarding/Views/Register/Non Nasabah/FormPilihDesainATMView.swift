//
//  PilihDesainATMView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI
import NavigationStack
import JGProgressHUD_SwiftUI

struct FormPilihDesainATMView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    @ObservedObject private var productVM = ATMProductViewModel()
    
    @State var cards: [ATMDesignViewModel] = []
    @State private var selectedTab = 0
    @State private var titleCard = "THE CARD"
    @State private var isLoading = false
    
    var body: some View {
        
        LoadingView(isShowing: $isLoading) {
            
            ZStack(alignment: .top) {
                
                VStack {
                    Color(hex: "#F6F8FB")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    AppBarLogo(onCancel: {})
                    
                    ScrollView {
                        
                        Text("Pilih Desain Kartu ATM Anda")
                            .font(.custom("Montserrat-SemiBold", size: 18))
                            .foregroundColor(Color(hex: "#232175"))
                            .padding(.top, 25)
                            .padding(.bottom, 10)
                        
                        TabView(selection: $selectedTab) {
                            ForEach(cards, id: \.id) {
                                TabItemView(card: $0) {card in
                                    print(card)
                                }
                            }
                        }
                        .shadow(color: Color(hex: "#2334D0").opacity(0.5), radius: 15, y: 4)
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .tabViewStyle(PageTabViewStyle(
                                        indexDisplayMode: .always))
                        .padding(.bottom, 25)
                        .onAppear(perform: {
                            setupAppearance()
                        })
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                            if value.translation.width < 0 {
                                                print("left")
                                                withAnimation(.easeOut) {
                                                    if selectedTab != cards.count-1 {
                                                        selectedTab += 1
                                                    }
                                                }
                                                selectCard(selected: selectedTab)
                                            }
                                            if value.translation.width > 0 {
                                                print("right")
                                                withAnimation(.easeOut) {
                                                    if selectedTab != 0 {
                                                        selectedTab -= 1
                                                    }
                                                }
                                                selectCard(selected: selectedTab)
                                            }})
                        )
                        
                        if cards.count > selectedTab {
                            VStack {
                                HStack {
                                    Text(cards[selectedTab].title)
                                        .font(.custom("Montserrat-SemiBold", size: 15))
                                    
                                    Spacer()
                                }
                                .padding()
                                
                                HStack{
                                    Text(cards[selectedTab].description)
                                        .font(.custom("Montserrat-Light", size: 10))
                                    Spacer()
                                }
                                .padding(.horizontal)
                                
                                NavigationLink(destination: FormCompletionKartuATMView().environmentObject(atmData)) {
                                    Text("PILIH DESAIN KARTU")
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                }
                                .frame(height: 50)
                                .background(Color(hex: "#2334D0"))
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .padding(.vertical, 20)
                                
                            }
                            .animation(nil)
                            //                .transition(.flipFromLeft)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color(.white))
                                    .shadow(color: Color(hex: "#2334D0").opacity(0.5), radius: 15, y: 4))
                            .padding(.leading, 25)
                            .padding(.trailing, 25)
                            .padding(.bottom)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .onAppear() {
                self.fetchATMDesignList()
            }
        }
    }
    
    func selectCard(selected: Int) {
        if cards.count > selectedTab {
            let card = cards[selected]
            print(card)
            atmData.atmDesignType = card.key
        }
    }
    
    // MARK: - PAGES APPEARANCE
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        UIPageControl.appearance().pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.1968375428)
    }
    
    // MARK: - FETCH ATM LIST DATA FROM API
    private func fetchATMDesignList() {
        if cards.count == 0 {
            isLoading = true
            productVM.getListATMDesign(type: atmData.productType) { (success: Bool) in
                isLoading = false
                if success {
                    self.cards = productVM.listATMDesign
                    if cards.count > 0 {
                        self.selectCard(selected: 0)
                    }
                }
            }
        }
    }
}

struct PilihDesainATMView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormPilihDesainATMView().environmentObject(AddProductATM())
        }
    }
}
