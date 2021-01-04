//
//  IncomingVideoCallView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 08/10/20.
//

import SwiftUI
import JitsiMeet

struct IncomingVideoCallView: View {
    
    var jitsiMeetView: JitsiMeetView?
    @State var isShowJitsi: Bool = false
    
    @Binding var jitsiRoom: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Color(hex: "#232175")
            
            VStack(alignment: .center) {
                header
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                Image("ic_incoming")
                    .padding(.bottom, 50)
                
                VStack {
                    Text(NSLocalizedString("Incoming Video Call", comment: ""))
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text(NSLocalizedString("Call Center Mestika Bank", comment: ""))
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                footerBtn
                    .padding(.top, 20)
                    .padding(.bottom, 65)
                    .padding(.horizontal, 80)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .leading
            )
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear(perform: {
            let defaultOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
                builder.serverURL = URL(string: "https://meet.jit.si")
                builder.welcomePageEnabled = false
            }
            
            JitsiMeet.sharedInstance().defaultConferenceOptions = defaultOptions
        })
        .onAppear() {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("Detail"), object: nil, queue: .main) { (_) in
                
            }
        }
        .fullScreenCover(isPresented: $isShowJitsi) {
            JitsiView(jitsi_room: self.$jitsiRoom)
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center, spacing: .none) {
                Image("Logo M")
                    .resizable()
                    .frame(width: 35, height: 35)
                Text("BANK MESTIKA")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .bold()
            }.padding(.top, -5)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .center
        )
        .padding(.top, 30)
    }
    
    var footerBtn: some View {
        HStack {
            VStack {
                Button(action: {
                    self.isShowJitsi = true
                }) {
                    Image("ic_call")
                }
                Text("Accept")
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("ic_hangup")
                }
                Text("Hang Up")
                    .foregroundColor(.white)
            }
        }
    }
}

struct IncomingVideoCallView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingVideoCallView(jitsiRoom: .constant("123456"))
    }
}
