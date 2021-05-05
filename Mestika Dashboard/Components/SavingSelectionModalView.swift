//
//  SavingSelectionModalView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 25/09/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SavingSelectionModalView: View {
    
    // TODO: TRANSLATE
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var atmData: AddProductATM
    var data: JenisTabunganViewModel
    
    @Binding var editMode: EditMode
    @Binding var isShowModal: Bool
    @Binding var showingReferralCodeModal: Bool
    @Binding var goToNextPage: Bool
    @Binding var backToSummary: Bool
    @State var referralCode: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: data.image)
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .placeholder {
                    Rectangle().foregroundColor(.gray).opacity(0.5)
                }
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            VStack(alignment: .center, spacing: 10) {
                Text("You have chosen".localized(language))
                    .font(.custom("Montserrat-Regular", size: 14))
                    .padding(.horizontal, 20)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(data.name)
                    .font(.custom("Montserrat-Regular", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2334D0"))
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Have a referral code?".localized(language))
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("Enter Referral Code".localized(language), text: $referralCode, onEditingChanged: { changed in
                    print("on change code referal")
                }, onCommit: {
                    atmData.atmAddresspostalReferral = self.referralCode
                    print("on commit code referal")
                })
                .frame(height: 20)
                .font(.custom("Montserrat-Regular", size: 14))
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .multilineTextAlignment(TextAlignment.center)
                
                Text("Make sure you enter the referral code correctly.".localized(language))
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(TextAlignment.center)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            .padding(.bottom, 15)
            
            VStack(alignment: .center, spacing: 10) {
                Button(action: {
                    
                    atmData.atmAddresspostalReferral = self.referralCode
                    atmData.atmNumberReferral = self.referralCode
                    registerData.atmNumberReferral = self.referralCode
                    
                    registerData.jenisTabungan = data.name
                    registerData.planCodeTabungan = data.codePlan
                    
                    withAnimation {
                        self.isShowModal.toggle()
                    }
                    
                    //                self.showingReferralCodeModal = true
                    if (editMode == .inactive) {
                        goToNextPage = true
                    } else {
                        backToSummary = true
                    }
                    
                }) {
                    Text("Choose This Savings".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                Button(action: {
                    
                    withAnimation {
                        self.isShowModal.toggle()
                    }
                    
                }) {
                    Text("Choose another savings".localized(language))
                        .foregroundColor(Color(hex: "#5A6876"))
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 15)
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        //        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height * 0.8)
    }
}
