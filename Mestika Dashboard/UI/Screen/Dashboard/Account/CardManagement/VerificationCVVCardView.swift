//
//  VerificationCVVCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

class TextFieldManager: ObservableObject {
    let limit = 3
    @Published var text = "" {
        didSet {
            if text.count > limit {
                text = String(text.prefix(limit))
                print(text)
            }
        }
    }
}

struct VerificationCVVCardView: View {
    
    @ObservedObject var cvv = TextFieldManager()
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    @State var falseCount = 0
    @State var showDashboard = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "largecircle.fill.circle")
                            .foregroundColor(.blue)
                        
                        Text("Kode CVV")
                    }
                    
                    VStack(alignment: .leading) {
                        
                        HStack (spacing: 0) {
                            TextField("Masukan Password", text: $cvv.text, onEditingChanged: { changed in
                                print("input \($cvv.text)")
                            })
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundColor(Color(hex: "#232175"))
                            .keyboardType(.phonePad)
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        Text("Masukkan 3 digit angka dibelakang kartu ATM Anda")
                            .font(.system(size: 10))
                    }
                    .padding(.vertical, 25)
                    .padding(.horizontal, 15)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 0.5).foregroundColor(.gray))
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                
                Button(action: {
                    print(cvv.text)
                    if cvv.text != "123" {
                        self.showingModal.toggle()
                        falseCount += 1
                    }
                }, label: {
                    Text("AKTIFKAN KARTU")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .frame(height: 50)
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.vertical, 30)
                .padding(.bottom, 30)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 35)
            
            // Background Color When Modal Showing
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("Aktifkan Kartu")
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            createBottomFloater()
        }
    }
    
    // MARK: -BOTTOM FLOATER FOR MESSAGE
    func createBottomFloater() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ic_attention")
                    .resizable()
                    .frame(width: 95, height: 95)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                Text(falseCount < 3 ? "KODE CVV SALAH":"KODE CVV SALAH 3 KALI")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#F32424"))
                Spacer()
            }
            
            HStack {
                Text(falseCount < 3 ? "3 digit nomor terakhir dibelakang kartu ATM Anda tidak sesuai dengan nomor kartu yang terdaftar." : "Kode CVV yang Anda masukkan salah, Kesempatan Anda telah habis, Silahkan kembali mencoba lagi Besok.")
                    .font(.custom("Montserrat-Light", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            NavigationLink(destination: BottomNavigationView(), isActive: $showDashboard) {
                Text("")
            }
            
            Button(action: {
                if falseCount < 3 {
                    self.showingModal.toggle()
                } else {
                    self.showDashboard = true
                }
            }) {
                Text(falseCount < 3 ? "MASUKAN KEMBALI NOMOR KARTU":"KEMBALI KE HALAMAN UTAMA")
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

struct VerificationCVVCardView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCVVCardView()
    }
}
