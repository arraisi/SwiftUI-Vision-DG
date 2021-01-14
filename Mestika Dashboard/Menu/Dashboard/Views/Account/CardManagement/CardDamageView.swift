//
//  DamageCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/11/20.
//

import SwiftUI

struct CardDamageView: View {
    
    var card: MyCard
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var marked = false
    @State var showConfirmationPIN = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    CardView(card: card, cardWidth: UIScreen.main.bounds.width - 60, cardHeight: 202, showContent: true)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    
                    
                    VStack(alignment: .leading, spacing: 25, content: {
                        
                        Text("Laporan / Aduan Kerusakan")
                            .font(.custom("Montserrat-SemiBold", size: 15))
                        
                        VStack(alignment: .leading) {
                            Text("Akan Diberikan Kartu Baru")
                                .font(.custom("Montserrat-Regular", size: 12))
                            
                            Button(action: {
                                self.marked.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 10) {
                                    
                                    Image(systemName: self.marked ? "checkmark.square" : "square")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 18, height: 18)
                                    
                                    HStack {
                                        Text("Biaya pengganti sebesar")
                                            .font(.custom("Montserrat-Regular", size: 10))
                                        Text("Rp. 20.000,-")
                                            .font(.custom("Montserrat-Bold", size: 10))
                                    }
                                    
                                    Spacer()
                                    
                                }
                            })
                            .foregroundColor(.black)
                        }
                        
                        NavigationLink(
                            destination: PINConfirmationView(key: "123456", pin: "", nextView: AnyView(CardDamageView(card: card, showingModal: true))),
                            isActive: $showConfirmationPIN,
                            label: {})
                        
                        Button(
                            action: {
                                if marked {
                                    self.showConfirmationPIN.toggle()
                                }
                            },
                            label: {
                                Text("LAPORKAN KERUSAKAN")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                            })
                            .frame(height: 50)
                            .background(Color(hex: "#2334D0"))
                            .cornerRadius(12)
                        
                    })
                    .padding(20)
                    .padding(.top, 20)
                    .background(Color.white)
                    .clipShape(PopupBubbleShape(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding(30)
                }
                .padding(.top, 30)
                
            }
            .background(Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Kartu Rusak", displayMode: .inline)
            .navigationBarItems(trailing:  NavigationLink(destination: CardManagementScreen(), label: {
                Text("Cancel")
            }))
            
            // Background Color When Modal Showing
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            createBottomFloater()
        }
    }
    
    // MARK: - BOTTOM FLOATER FOR MESSAGE
    func createBottomFloater() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ic_plane")
                    .resizable()
                    .frame(width: 80, height: 80)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                
                Text("Laporan / Aduan Kerusakan Kartu ATM Anda Telah Berhasil Kami Simpan")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            
            HStack {
                Text("Terimakasih telah mengirimkan informasi kerusakan kartu Anda kepada Kami. Silahkan tunggu beberapa saat, pihak Kami akan segera menghubungi Anda untuk menindak lanjutin laporan Anda.")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            NavigationLink(destination: BottomNavigationView()) {
                Text("KEMBALI")
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                
            }
            .frame(height: 50)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 25)
        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct CardDamageView_Previews: PreviewProvider {
    static var previews: some View {
        CardDamageView(card: myCardData[0])
    }
}
