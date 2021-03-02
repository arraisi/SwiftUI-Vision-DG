//
//  VerificationCVVCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

class TextFieldManager: ObservableObject {
    let limit = 3
    @Published var text = "" {
        didSet {
            if text.count > limit {
                text = String(text.prefix(limit))
                print(text)
            }
        }
    }
}

struct CardCVVVerificationView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @ObservedObject var cvv = TextFieldManager()
    
    var card: MyCard
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    @State var falseCount = 0
    @State var nextView = false
    @State var backView = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "largecircle.fill.circle")
                            .foregroundColor(.blue)
                        
                        Text(NSLocalizedString("CVV Code".localized(language), comment: ""))
                    }
                    
                    VStack(alignment: .leading) {
                        
                        HStack (spacing: 0) {
                            TextField(NSLocalizedString("ENTER PASSWORD".localized(language), comment: ""), text: $cvv.text, onEditingChanged: { changed in
                                print("input \($cvv.text)")
                            })
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundColor(Color(hex: "#232175"))
                            .keyboardType(.phonePad)
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        Text(NSLocalizedString("Enter the 3 digit number on the back of your ATM card".localized(language), comment: ""))
                            .font(.system(size: 12))
                    }
                    .padding(.vertical, 25)
                    .padding(.horizontal, 15)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 0.5).foregroundColor(.gray))
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                
                Button(action: {
                    
                    self.hideKeyboard()
                    
                    if cvv.text != "123" {
                        falseCount += 1
                    } 
                    
                    self.showingModal.toggle()
                    
                }, label: {
                    Text(NSLocalizedString("Activate Card".localized(language), comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .frame(height: 50)
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.vertical, 30)
                .padding(.bottom, 30)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 35)
            
            // Background Color When Modal Showing
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle(NSLocalizedString("Activate Card".localized(language), comment: ""))
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            createBottomFloater()
        }
    }
    
    // MARK: -BOTTOM FLOATER FOR MESSAGE
    func createBottomFloater() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(!backView ? "ic_check" : "ic_attention")
                    .resizable()
                    .frame(width: !backView ? 80 : 95, height: !backView ? 80 : 95)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                Text(
                    !backView ? NSLocalizedString("Your ATM Card Activation Is Successful".localized(language), comment: "") : falseCount < 3 ? NSLocalizedString("WRONG CVV CODE".localized(language), comment: "") : NSLocalizedString("WRONG 3 TIMES CVV CODE".localized(language), comment: ""))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(!backView ? Color(hex: "#2334D0") : Color(hex: "#F32424"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            HStack {
                Text(!backView ? "" : falseCount < 3 ? NSLocalizedString("The last 3 digit number on the back of your ATM card does not match the registered card number.".localized(language), comment: "") : NSLocalizedString("The CVV code you entered is incorrect. Your chance has expired. Please try again Tomorrow.".localized(language), comment: ""))
                    .font(.custom("Montserrat-Light", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            NavigationLink(destination: BottomNavigationView(), isActive: $backView) {
                Text("")
            }
            
            NavigationLink(destination: CardManagementScreen(), isActive: $nextView) {
                Text("")
            }
            
            Button(action: {
                if !backView {
                    self.nextView.toggle()
                } else {
                    if falseCount < 3 {
                        self.showingModal.toggle()
                    } else {
                        self.backView = true
                    }
                }
            }) {
                Text(!backView ? NSLocalizedString("BACK TO MY CARD".localized(language), comment: "") : falseCount < 3 ? NSLocalizedString("RETURN THE CARD NUMBER".localized(language), comment: ""):NSLocalizedString("Back to Main Page".localized(language), comment: ""))
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 15)
        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct CardCVVVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        CardCVVVerificationView(card: myCardData[0])
    }
}
