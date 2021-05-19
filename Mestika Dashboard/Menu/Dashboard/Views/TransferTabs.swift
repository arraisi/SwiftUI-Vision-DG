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
    
    @State private var timeLogout = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var showAlertTimeout: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject private var authVM = AuthViewModel()
    
    var body: some View {
        
        let tap = TapGesture()
            .onEnded { _ in
                self.timeLogout = 300
                print("View tapped!")
            }
        
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
        .gesture(tap)
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
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
            
//            Button(action: {}, label: {
//                Image("ic_search")
//            })
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
//            .isDetailLink(false)
            
            // Link Transfer OFFUS
            NavigationLink(
                destination: TransferRtgsScreen(dest: .constant(""), type: .constant(""), destBank: .constant(""), nameCst: .constant(""), desc: .constant("")),
                isActive: self.$transferOffUsActive,
                label: {EmptyView()}
            )
//            .isDetailLink(false)
            
            Button(action: {
                print("ONUS")
                self.transferOnUsActive = true
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
                print("OFFUS")
                self.transferOffUsActive = true
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
}

struct TransferTabs_Previews: PreviewProvider {
    static var previews: some View {
        TransferTabs(cardNo: .constant(""), sourceNumber: .constant(""), transferOnUsActive: .constant(false), transferOffUsActive: .constant(false))
    }
}
