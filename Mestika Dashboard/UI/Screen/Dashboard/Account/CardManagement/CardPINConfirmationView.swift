//
//  ConfirmationPINView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/11/20.
//

import SwiftUI

struct CardPINConfirmationView: View {
    
    @AppStorage("lock_Password") var key = "123456"
    
    @State var pin = ""
    @State var unLocked = false
    @State var wrongPin = false
    
    var nextView: AnyView
    
    /* Boolean for Show Modal */
    @State var showingModal = false
//    @State var falseCount = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 0)
                
                Text("MASUKKAN PIN ATM")
                    .font(.custom("Montserrat-SemiBold", size: 24))
                    .foregroundColor(Color(hex: "#2334D0"))
                
                Text("Silahkan masukkan PIN ATM Anda")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#002251"))
                    .padding(.top, 5)
                
                HStack(spacing: 10){
                    ForEach(0..<6, id: \.self){index in
                        PinView(index: index, password: $pin, emptyColor: .constant(Color(hex: "#ADAEB0")), fillColor: .constant(Color(hex: "#2334D0")))
                    }
                }
                .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                
                Text(wrongPin ? "Incorrect Pin" : "")
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
                    .padding()
                
                NavigationLink(
                    destination: AnyView(nextView),
                    isActive: $unLocked,
                    label: {
                        Text("")
                    })
                
                Spacer(minLength: 0)
                
                NumbersPadView(previousPIN: key, currentPIN: $pin, unLocked: $unLocked, wrongPin: $wrongPin) { falseCount in
                    print("callbak and falsecount is : \(falseCount)")
                    if falseCount == 3 {
                        self.showingModal.toggle()
                    }
                }
            }
            
            // Background Color When Modal Showing
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
            
        }
        .navigationBarTitle("Reset PIN Transaksi", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: CardManagementScreen(), label: {
            Text("Cancel")
        }))
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            createBottomFloater()
        }
    }
    
    // MARK: - BOTTOM FLOATER FOR MESSAGE
    func createBottomFloater() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(Color(hex: "#F32424"))
                
                
                Text("PIN ATM Salah")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#F32424"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            HStack {
                Text("PIN ATM Anda telah salah 3 kali, silahkan ulangi lagi minggu depan.")
                    .font(.custom("Montserrat-Light", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            NavigationLink(destination: BottomNavigationView()) {
                Text("Kembali ke Halaman Utama")
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 15)
        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct CardPINConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        CardPINConfirmationView(key: "", pin: "", nextView: AnyView(CardManagementScreen()))
    }
}
