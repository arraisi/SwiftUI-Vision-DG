//
//  BlockCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/11/20.
//

import SwiftUI

struct CardBlockView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var card: KartuKuDesignViewModel
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showConfirmationPIN = false
    
    // Observable Object
    @State var brokenData = BrokenKartuKuModel()
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    CardView(card: card, cardWidth: UIScreen.main.bounds.width - 60, cardHeight: 202, showContent: true)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        Image("credit-card-locked")
                            .resizable()
                            .frame(width: 75.48, height: 60)
                        
                        Text("Are You Sure To Block Your Card?".localized(language))
                            .font(.custom("Montserrat-Bold", size: 18))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        Text("Blocking the Card may result in the Card not being used at an ATM machine and also not being used for transactions at the Online Shop through the GPN (National Payment Gateway)".localized(language))
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#232175"))
                            .lineSpacing(10)
                        
                        NavigationLink(
                            destination: CardBlockAddressInputView().environmentObject(brokenData),
                            isActive: $showConfirmationPIN,
                            label: {}
                        )
                        .isDetailLink(false)
                        
                        
                        Button (action: {
                            self.showConfirmationPIN = true
//                            card.blocked ? self.showConfirmationPIN.toggle() : self.showingModal.toggle()
//                            self.showingModal.toggle()
                            
                        }, label: {
                            Text("Block Card".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        })
                        .frame(height: 50)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(12)
//                        .hidden()
                    }
                    .padding(20)
                    .padding(.top, 20)
                    .background(Color.white)
                    .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding(30)
                }
                .padding(.top, 30)
            }
            .background(Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Block Card".localized(language), displayMode: .inline)
            .navigationBarItems(trailing:  NavigationLink(destination: CardManagementScreen(), label: {
                Text("Cancel")
            }))
            .onAppear {
                self.brokenData.cardNo = card.cardNo ?? ""
                self.brokenData.nameOnCard = card.nameOnCard
                self.brokenData.cardDesign = card.cardDesign?.absoluteString ?? "http://eagle.visiondg.xyz:8765/image/b5fb9a649b2c3670120343eb8dd85d03.png"
            }
            
            // Background Color When Modal Showing
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            createBottomFloater()
        }
    }
    
    // MARK: - BOTTOM FLOATER FOR MESSAGE
    func createBottomFloater() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ic_check")
                    .resizable()
                    .frame(width: 80, height: 80)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                
                Text("Success, Your ATM Card Is Back Active".localized(language))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            NavigationLink(destination: BottomNavigationView()) {
                Text("BACK".localized(language))
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                
            }
            .frame(height: 50)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 25)
        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
}
