//
//  PaymentPLNScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI

struct PaymentPLNScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            appbar
            ScrollView(.vertical, showsIndicators: false, content: {
                titleInfo
                buttonLink
                
                ListLastPaymentPlnView()
            })
        }
        .navigationBarHidden(true)
    }
    
    // MARK: -APP BAR
    var appbar: some View {
        VStack {
            HStack {
                HStack {
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color(hex: "#232175"))
                        })
                        .padding(.horizontal)
                    
                    Text(NSLocalizedString("Payment".localized(language), comment: ""))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#232175"))
                }
                Spacer()
                navBarItem
            }
        }
        .padding(.top, 50)
        .padding(.bottom, 10)
    }
    
    var navBarItem: some View {
        HStack(spacing: 30) {
            Button(action: {}, label: {
                Image("ic_qrcode")
            })
        }
        .padding(.horizontal)
    }
    
    // MARK: -USERNAME INFO VIEW
    var titleInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("PLN")
                    .font(.title)
                    .fontWeight(.heavy)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(NSLocalizedString("Make bill payments and purchase electricity easily, quickly and in a planned manner".localized(language), comment: ""))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 40)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("ic_search")
            })
        }
        .padding()
    }
    
    var buttonLink: some View {
        VStack {
            
            Button(
                action: {},
                label: {
                    
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                        
                        Text(NSLocalizedString("Add Another PLN ID".localized(language), comment: ""))
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                    }
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.leading, 20)
                .padding(.trailing, 10)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .padding([.bottom, .top], 20)
    }
}

struct PaymentPLNScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPLNScreen()
    }
}
