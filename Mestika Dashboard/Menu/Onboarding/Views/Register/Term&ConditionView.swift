//
//  Term&ConditionView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct Term_ConditionView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    
    @State var scrollPosition: CGFloat = 0.0
    
    @State var isCheckedWni: Bool = false
    @State var isCheckedAgree: Bool = false
    @State var isCheckedShareData: Bool = false
    @State var showingAlert: Bool = false
    @State var disableAgree = true
    
    @State var isShowDataVerification: Bool = false
    
    @State var readFinished = false
    @State var showingBadge: Bool = true
    
    func toggleIsWni() {
        isCheckedWni = !isCheckedWni
        self.disableAgree.toggle()
        self.registerData.isWni = isCheckedWni
    }
    
    func toggleIsAgree() {
        isCheckedAgree = !isCheckedAgree
        self.registerData.isAgree = isCheckedWni
        
    }
    func toggleIsShareData() {
        isCheckedShareData = !isCheckedShareData
        self.registerData.isShareData = isCheckedShareData
    }
    
    var disableForm: Bool {
        isCheckedWni && isCheckedAgree
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: UIScreen.main.bounds.height*0.5)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                
                AppBarLogo(light: false, showCancel: true, onCancel: {
                    self.showingAlert = true
                })
                
                VStack {
                    Text("TERMS AND CONDITIONS".localized(language))
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading) {
                        ZStack {
                            WebView(readed: self.$readFinished, urlString: Bundle.main.url(forResource: LocalizationService.shared.language != .english_us ? "term" : "term-english", withExtension: "html")?.absoluteString)
                                .padding(.horizontal, 12)
                            
//                            if showingBadge {
//                                BadgeView(text: "Silahkan scroll kebawah")
//                                    .animation(.easeIn)
//                                    .onAppear{
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                            withAnimation {
//                                                showingBadge = false
//                                            }
//                                        }
//                                    }
//                            }
                            
                        }
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        Spacer()
                        
                        Button(action: toggleIsWni) {
                            HStack(alignment: .top) {
                                Image(systemName: isCheckedWni ? "checkmark.square": "square")
                                Text("* I am an Indonesian citizen and do not have tax obligations in other countries".localized(language))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                        .disabled(!readFinished)
                        
                        Button(action: toggleIsAgree) {
                            HStack(alignment: .top) {
                                Image(systemName: isCheckedAgree ? "checkmark.square": "square")
                                Text("* I agree".localized(language))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                        .disabled(!readFinished)
                        
                        Button(action: toggleIsShareData) {
                            HStack(alignment: .top) {
                                Image(systemName: isCheckedShareData ? "checkmark.square": "square")
                                Text("I give the right to Bank Mestika to provide data to third parties that cooperate with Bank Mestika".localized(language))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        
                        NavigationLink(destination: RegisterSummaryView(deviceModel: DeviceTraceModel()).environmentObject(registerData), isActive: self.$isShowDataVerification) {EmptyView()}
                        
                        Button(action: {
                            self.isShowDataVerification = true
                        }) {
                            Text("Next".localized(language))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                        .background(Color(hex: !disableForm ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .disabled(!disableForm)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 30)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Do you want to cancel registration?".localized(language)),
                primaryButton: .default(Text("YES".localized(language)), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text("NO".localized(language))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.showingAlert = true
            }
        }))
    }
}

struct Term_ConditionView_Previews: PreviewProvider {
    static var previews: some View {
        Term_ConditionView().environmentObject(RegistrasiModel())
    }
}
