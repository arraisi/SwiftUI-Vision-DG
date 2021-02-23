//
//  CardPINConfiguration.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 10/11/20.
//

import SwiftUI

struct CardPINConfigurationView: View {
    
    var card: KartuKuDesignViewModel
    
    @AppStorage("lock_Password") var key = "123456"
    
    @State var pin = ""
    @State var unLocked = false
    @State var wrongPin = false
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    var body: some View {
        ZStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    CardView(card: card, cardWidth: UIScreen.main.bounds.width - 60, cardHeight: 202, showContent: true)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    
                    VStack(alignment: .leading, spacing: 15, content: {
                        
                        NavigationLink(destination: PINConfirmationView(key: "123456", pin: "", nextView: AnyView(FormNewPinAtmView())), label: {
                            HStack{
                                Text("Ubah PIN ATM Anda")
                                    .font(.custom("Montserrat-Medium", size: 15))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "greaterthan.circle")
                                    .foregroundColor(Color.gray.opacity(0.5))
                            }
                        })
                        
                        Divider()
                        
                        NavigationLink(destination: FormInputOldPinScreen(unLocked: unLocked), label: {
                            HStack{
                                Text("Ubah PIN Transaksi Anda")
                                    .font(.custom("Montserrat-Medium", size: 15))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "greaterthan.circle")
                                    .foregroundColor(Color.gray.opacity(0.5))
                            }
                        })
                        
                        Divider()
                        
                        NavigationLink(destination: PINConfirmationView(key: "123456", pin: "", nextView: AnyView(OtpResetPinScreen())), label: {
                            HStack{
                                Text("Lupa PIN Transaksi Anda")
                                    .font(.custom("Montserrat-Medium", size: 15))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "greaterthan.circle")
                                    .foregroundColor(Color.gray.opacity(0.5))
                            }
                        })
                        
                        Divider()
                        
                    })
                    .padding(20)
                    .padding(.top, 30)
                    .padding(.bottom, 50)
                    .background(Color.white)
                    .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding(30)
                }
                .padding(.top, 30)
                .animation(.spring())
                
            }
            .background(Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Limit Kartu", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: CardManagementScreen(), label: {
                Text("Cancel")
            }))
            
        }
    }
}

//struct CardPINConfiguration_Previews: PreviewProvider {
//    static var previews: some View {
//        CardPINConfigurationView(card: myCardData[0])
//    }
//}
