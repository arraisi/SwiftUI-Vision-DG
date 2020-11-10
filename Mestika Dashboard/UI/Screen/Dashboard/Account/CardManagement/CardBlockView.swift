//
//  BlockCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/11/20.
//

import SwiftUI

struct CardBlockView: View {
    
    var card: MyCard
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showConfirmationPIN = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    CardView(card: card, cardWidth: UIScreen.main.bounds.width - 60, cardHeight: 202)
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        Image("credit-card-locked")
                            .resizable()
                            .frame(width: 75.48, height: 60)
                        
                        Text(card.blocked ? "Kartu Rekening Terblokir" : "Apakah Anda Yakin Untuk Memblokir Kartu Anda")
                            .font(.custom("Montserrat-Bold", size: 18))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        Text(card.blocked ? "Kartu Anda terblokir sementara, Silahkan aktifkan kembali kartu Anda untuk menggunakannya." : "Pemblokiran Kartu dapat mengakibatkan Kartu tidak dapat digunakan pada mesin ATM dan juga tidak dapat digunakan untuk transaksi di Toko Online melalui GPN (Gerbang Pembayaran Nasional)")
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#232175"))
                            .lineSpacing(10)
                        
                        NavigationLink(
                            destination: CardPINConfirmationView(key: "123456", pin: "", nextView: AnyView(CardBlockView(card: card, showingModal: true))),
                            isActive: $showConfirmationPIN,
                            label: {})
                        
                        
                        Button (action: {
                            
                            card.blocked ? self.showConfirmationPIN.toggle() : self.showingModal.toggle()
                            
                        }, label: {
                            Text(card.blocked ? "BUKA BLOKIR KARTU" : "BLOKIR KARTU")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        })
                        .frame(height: 50)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(12)
                    }
                    .padding(20)
                    .padding(.top, 20)
                    .background(Color.white)
                    .clipShape(PopupBubble(cornerRadius: 25, arrowEdge: .leading, arrowHeight: 15))
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding(30)
                }
                .padding(.top, 30)
            }
            .background(Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Blokir Kartu", displayMode: .inline)
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
                Image("ic_check")
                    .resizable()
                    .frame(width: 80, height: 80)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                
                Text(card.blocked ? "Berhasil, Kartu ATM Anda Sudah Diblokir Untuk Sementara Waktu":"Berhasil, Kartu ATM Anda Sudah Kembali Aktif")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
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

struct CardBlockView_Previews: PreviewProvider {
    static var previews: some View {
        CardBlockView(card: myCardData[0])
    }
}
