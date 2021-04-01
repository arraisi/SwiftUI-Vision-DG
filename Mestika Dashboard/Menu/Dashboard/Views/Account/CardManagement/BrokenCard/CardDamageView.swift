//
//  DamageCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/11/20.
//

import SwiftUI

struct CardDamageView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var kartKuVM = KartuKuViewModel()
    var card: KartuKuDesignViewModel
    
    // Observable Object
    @State var brokenData = BrokenKartuKuModel()
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showingModalError = false
    @State var marked = false
    @State var showConfirmationPIN = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    CardView(card: card, cardWidth: UIScreen.main.bounds.width - 60, cardHeight: 202, showContent: true)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    
                    
                    VStack(alignment: .leading, spacing: 25, content: {
                        
                        Text("Damage Report / Complaint".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 15))
                        
                        VStack(alignment: .leading) {
                            Text("A New Card Will Be Given".localized(language))
                                .font(.custom("Montserrat-Regular", size: 12))
                            
                            Button(action: {
                                self.marked.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 10) {
                                    
                                    Image(systemName: self.marked ? "checkmark.square" : "square")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 18, height: 18)
                                    
                                    HStack {
                                        Text("Replacement fee of".localized(language))
                                            .font(.custom("Montserrat-Regular", size: 10))
                                        Text("Rp. 20.000,-")
                                            .font(.custom("Montserrat-Bold", size: 10))
                                    }
                                    
                                    Spacer()
                                    
                                }
                            })
                            .foregroundColor(.black)
                        }
                        
                        NavigationLink(
                            destination: CardDamageAddressInputView().environmentObject(brokenData),
                            isActive: $showConfirmationPIN,
                            label: {}
                        )
                        .isDetailLink(false)
                        
                        Button(
                            action: {
                                if marked {
                                    self.showConfirmationPIN.toggle()
                                }
                            },
                            label: {
                                Text("REPORT DAMAGE".localized(language))
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                            })
                            .disabled(marked ? false : true)
                            .frame(height: 50)
                            .background(marked ? Color(hex: "#2334D0") : Color.gray.opacity(0.3))
                            .cornerRadius(12)
                        
                    })
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
            .navigationBarTitle("Broken Card".localized(language), displayMode: .inline)
            .onAppear {
                self.showConfirmationPIN = false
                self.brokenData.cardNo = card.cardNo
                self.brokenData.nameOnCard = card.nameOnCard
                self.brokenData.cardDesign = "http://eagle.visiondg.xyz:8765/image/b5fb9a649b2c3670120343eb8dd85d03.png"
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("Broken My Card".localized(language)))) { obj in
                print("ON RESUME")
                
                if let pinTrx = obj.userInfo, let info = pinTrx["pinTrx"] {
                    print(info)
                    self.brokenData.pin = info as! String
                }
                
                print(self.brokenData.cardNo)
                print(self.brokenData.pin)
                
                brokenKartuKu()
            }
            
            // Background Color When Modal Showing
            if self.showingModal || self.showingModalError {
                ModalOverlay(tapAction: { withAnimation { } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            popUpSucess()
        }
        .popup(isPresented: $showingModalError, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            popUpWrongPin()
        }
    }
    
    // MARK: - BOTTOM FLOATER FOR SUCCESS
    func popUpSucess() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ic_plane")
                    .resizable()
                    .frame(width: 80, height: 80)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                
                Text("We have successfully kept your ATM card damage report / complaint".localized(language))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            
            HStack {
                Text("Thank you for sending information about the damage to your card to us. Please wait a few moments, we will immediately contact you to follow up on your report.".localized(language))
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
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
    
    // MARK: - BOTTOM FLOATER FOR WRONG PIN
    func popUpWrongPin() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(Color(hex: "#F32424"))
                
                
                Text("Wrong ATM PIN".localized(language))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#F32424"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            HStack {
                Text("The ATM PIN you entered is wrong.".localized(language))
                    .font(.custom("Montserrat-Light", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            Button(
                action: {
                    self.presentationMode.wrappedValue.dismiss()
                },
                label: {
                    Text("Back to Main Page".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 15)

        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func brokenKartuKu() {
        self.kartKuVM.brokenKartuKu(data: brokenData) { success in
            if success {
                print("SUCCESS")
                self.showingModal = true
            }
            
            if !success {
                print("!SUCCESS")
                self.showingModalError = true
            }
        }
    }
}

//struct CardDamageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardDamageView(card: myCardData[0])
//    }
//}
