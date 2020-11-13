//
//  IncomingVideoCallView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 08/10/20.
//

import SwiftUI

struct IncomingVideoCallView: View {
    
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
                    Text("Incoming Video Call")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text("Call Center Mestika Bank")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(true)
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
                Button(action: {}) {
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
        IncomingVideoCallView()
    }
}
