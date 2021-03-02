//
//  DetailKartuATMView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct FormDetailKartuATMView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @ObservedObject private var productVM = ATMProductViewModel()
    
    var isAllowBack: Bool = true
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 100)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                    .frame(height: 100)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25){
                        HStack {
                            Text(NSLocalizedString("YOUR ATM CARD WILL BE SENT IMMEDIATELY".localized(language), comment: ""))
                                .font(.custom("Montserrat-Bold", size: 24))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.top, 10)
                        
                        WebImage(url: URL(string: atmData.imageDesign))
                            .onSuccess { image, data, cacheType in
                                // Success
                            }
                            .placeholder {
                                Rectangle().foregroundColor(.gray).opacity(0.5)
                            }
                            .resizable()
                            .indicator(.activity) // Activity Indicator
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .scaledToFill()
                            .cornerRadius(10)
                        
                        //                        Image(uiImage: registerData.desainKartuATMImage)
                        //                            .resizable()
                        //                            .aspectRatio(contentMode: .fit)
                        //                            .background(Color.clear)
                        
                        HStack {
                            Text(NSLocalizedString("Congratulations, your new ATM card data has been successfully saved.".localized(language), comment: ""))
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#1D2238"))
                            Spacer()
                        }
                        
                        VStack {
                            HStack{
                                Text(NSLocalizedString("Name".localized(language), comment: ""))
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .foregroundColor(Color(hex: "#707070"))
                                
                                Spacer()
                                
                                TextField(NSLocalizedString("Name".localized(language), comment: ""), text: $atmData.atmName) { (isChanged) in
                                    
                                } onCommit: {
                                    
                                }
                                .disabled(true)
                                .font(.custom("Montserrat-Regular", size: 12))
                                .frame(width: 200, height: 36)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        
                        HStack {
                            Text(NSLocalizedString("Please wait a few moments until your ATM card is accepted.".localized(language), comment: ""))
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#1D2238"))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        if (self.user.last?.isNasabahMestika == true) {
                            NavigationLink(
                                destination: VerificationPINView().environmentObject(registerData).environmentObject(atmData),
                                label: {
                                    Text(NSLocalizedString("NEXT".localized(language), comment: ""))
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                }
                            )
                            .frame(height: 50)
                            .background(Color(hex: "#2334D0"))
                            .cornerRadius(12)
                        } else {
                            NavigationLink(
                                destination: SuccessRegisterView().environmentObject(registerData).environmentObject(atmData),
                                label: {
                                    Text(NSLocalizedString("NEXT".localized(language), comment: ""))
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                }
                            )
                            .frame(height: 50)
                            .background(Color(hex: "#2334D0"))
                            .cornerRadius(12)
                            //                            Button(action: {
                            //                                self.appState.moveToWelcomeView = true
                            //                            }) {
                            //                                Text(NSLocalizedString("SELANJUTNYA", comment: ""))
                            //                                    .font(.custom("Montserrat-SemiBold", size: 14))
                            //                                    .foregroundColor(.white)
                            //                                    .frame(maxWidth: .infinity)
                            //                            }
                            //                            .frame(height: 50)
                            //                            .background(Color(hex: "#2334D0"))
                            //                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 25)
                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Do you want to cancel registration?".localized(language), comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YES".localized(language), comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("NO".localized(language), comment: ""))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.isShowingAlert = true
            }
        }))
    }
}

struct DetailKartuATMView_Previews: PreviewProvider {
    static var previews: some View {
        FormDetailKartuATMView().environmentObject(AddProductATM()).environmentObject(RegistrasiModel())
    }
}
