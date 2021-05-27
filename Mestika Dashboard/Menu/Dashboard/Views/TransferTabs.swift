//
//  TransferScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct TransferTabs: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var cardNo: String
    @Binding var sourceNumber: String
    
    @Binding var transferOnUsActive: Bool
    @Binding var transferOffUsActive: Bool
    
    @State var showPopup: Bool = false
    
    @State private var timeLogout = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var showAlertTimeout: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject private var authVM = AuthViewModel()
    @ObservedObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        
        let tap = TapGesture()
            .onEnded { _ in
                self.timeLogout = 300
                print("View tapped!")
            }
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                GeometryReader { geometry in
                    Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                        .frame(height: 0)
                }
                
                VStack {
                    titleInfo
                    buttonLink
                    
                    ListLastTransactionView(sourceNumber: sourceNumber)
                }
            })
            
            if self.showPopup {
                ModalOverlay(tapAction: { withAnimation { self.showPopup = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .gesture(tap)
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            checkFreezeAccount()
//        }
        .popup(isPresented: $showPopup, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageError()
                .padding(.bottom, 90)
        }
//        .onReceive(timer) { time in
////            print(self.timeLogout)
//            if self.timeLogout > 0 {
//                self.timeLogout -= 1
//            }
//
//            if self.timeLogout < 1 {
//                showAlertTimeout = true
//            }
//        }
//        .alert(isPresented: $showAlertTimeout) {
//            return Alert(title: Text("Session Expired"), message: Text("You have to re-login"), dismissButton: .default(Text("OK".localized(language)), action: {
//                self.authVM.postLogout { success in
//                    if success {
//                        print("SUCCESS LOGOUT")
//                        DispatchQueue.main.async {
//                            self.appState.moveToWelcomeView = true
//                        }
//                    }
//                }
//            }))
//        }
    }
    
    // MARK: -USERNAME INFO VIEW
    var titleInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Transfer")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Please select the type of transaction to be used".localized(language))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
    }
    
    var buttonLink: some View {
        VStack {
            
            // Link Transfer ONUS
            NavigationLink(
                destination: TransferOnUsScreen(dest: .constant("")),
                isActive: self.$transferOnUsActive) {
                EmptyView()
            }
            .isDetailLink(false)
            
            // Link Transfer OFFUS
            NavigationLink(
                destination: TransferRtgsScreen(dest: .constant(""), type: .constant(""), destBank: .constant(""), nameCst: .constant(""), desc: .constant("")),
                isActive: self.$transferOffUsActive,
                label: {EmptyView()}
            )
            .isDetailLink(false)
            
            Button(action: {
                
                if (self.profileVM.freezeAccount) {
                    print("Freeze Account")
                    self.showPopup = true
                } else {
                    print("ONUS")
                    self.transferOnUsActive = true
                }
                
            }, label: {
                Text("FELLOW BANK MESTIKA".localized(language))
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                
            })
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Spacer(minLength: 10)
            
            Button(action: {
                
                if (self.profileVM.freezeAccount) {
                    print("Freeze Account")
                    self.showPopup = true
                } else {
                    print("OFFUS")
                    self.transferOffUsActive = true
                }
        
            }, label: {
                Text("Transfer to Other Bank".localized(language))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                
            })
            .background(Color.white)
            .cornerRadius(12)
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .padding([.bottom, .top], 20)
    }
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Akun anda telah dibekukan".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {}) {
                Text("Back".localized(language))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Text("")
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func checkFreezeAccount() {
        self.profileVM.getAccountFreeze { sucess in }
    }
}

struct TransferTabs_Previews: PreviewProvider {
    static var previews: some View {
        TransferTabs(cardNo: .constant(""), sourceNumber: .constant(""), transferOnUsActive: .constant(false), transferOffUsActive: .constant(false))
    }
}
