//
//  ActivationATMView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct CardActivationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var kartKuVM = KartuKuViewModel()
    
    // Observable Object
    @State var activateData = ActivateKartuKuModel()
    
    @State var nextView: Bool = false
    
    var card: KartuKuDesignViewModel
    
    // Variable NoRekening
    @State private var noAtmCtrl: String = "0"
    
    // Variable CVV Code
    @State private var noCvvCtrl: String = ""
    
    // Variable New PIN
    @State private var pinCtrl: String = ""
    @State private var cPinCtrl: String = ""
    @State private var disableIncorrectPin: Bool = true
    
    // Variable POPUP
    @State private var isShowingWrongCvv: Bool = false
    @State private var isShowingWrong3TimeCvv: Bool = false
    @State private var isShowingSuccess: Bool = false
    
    var disableForm: Bool {
        noCvvCtrl.count < 3 || pinCtrl.count < 6 || cPinCtrl.count < 6
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#F6F8FB")
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        noAtmAndCvvCard
                        createNewPinCard
                        
                        NavigationLink(
                            destination: CardPinVerificationView(unLocked: false).environmentObject(activateData),
                            isActive: self.$nextView,
                            label: {
                                EmptyView()
                            })
                        
                        Button(action: {
                            self.activateData.cvv = self.noCvvCtrl
                            self.activateData.newPin = self.pinCtrl
                            
                            if (pinCtrl != cPinCtrl) {
                                disableIncorrectPin = false
                            } else  {
                                self.nextView = true
                            }
                        }, label: {
                            Text("AKTIVASI KARTU ATM")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disableForm)
                        .background(disableForm ? Color.gray : Color(hex: "#232175"))
                        .cornerRadius(12)
                        .padding(.top, 30)
                        .padding(.horizontal)
                    }
                })
            }
            
            if self.isShowingSuccess || self.isShowingWrongCvv || self.isShowingWrong3TimeCvv {
                ModalOverlay(tapAction: { withAnimation {} })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("Aktivasi Kartu", displayMode: .inline)
        .onAppear {
            self.noAtmCtrl = card.cardNo
            self.activateData.cardNo = card.cardNo
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ActivatedKartuKu"))) { obj in
            print("ON RESUME")
            
            if let pinTrx = obj.userInfo, let info = pinTrx["pinTrx"] {
                print(info)
                self.activateData.pinTrx = info as! String
            }
            
            print(self.activateData.cardNo)
            print(self.activateData.cvv)
            print(self.activateData.pinTrx)
            
            activateKartuKu()
        }
        .popup(isPresented: $isShowingWrongCvv, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalCodeCVVWrong()
        }
        .popup(isPresented: $isShowingWrong3TimeCvv, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalCodeCVVWrong3Time()
        }
        .popup(isPresented: $isShowingSuccess, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalSuccessActivation()
        }
    }
    
    var noAtmAndCvvCard: some View {
        VStack {
            
            // Field No ATM
            VStack {
                HStack {
                    Text("No. Kartu ATM")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 15)
                
                HStack {
                    TextField("Rekening", text: self.$noAtmCtrl, onEditingChanged: { changed in
                    })
                    .disabled(true)
                    .keyboardType(.numberPad)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .onReceive(noAtmCtrl.publisher.collect()) {
                        self.noAtmCtrl = String($0.prefix(16))
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
            }
            
            // Field CVV Code
            VStack {
                HStack {
                    Text("Masukkan Kode CVV")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    SecureField("Kode CVV", text: self.$noCvvCtrl)
                        .keyboardType(.numberPad)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        .onReceive(noCvvCtrl.publisher.collect()) {
                            self.noCvvCtrl = String($0.prefix(3))
                        }
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    Text("Masukkan 3 digit angka dibelakang kartu ATM Anda")
                        .font(.system(size: 12))
                        .padding(.bottom, 10)
                }
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.bottom, 25)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding(.vertical)
        .padding(.top, 15)
    }
    
    var createNewPinCard: some View {
        VStack {
            
            // Field No ATM
            VStack {
                HStack {
                    Text("Pembuatan PIN ATM baru")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 15)
                
                HStack {
                    SecureField("PIN ATM baru", text: self.$pinCtrl)
                        .keyboardType(.numberPad)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding()
                        .onReceive(pinCtrl.publisher.collect()) {
                            self.pinCtrl = String($0.prefix(6))
                        }
                }
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
            }
            
            // Field CVV Code
            VStack {
                HStack {
                    Text("Masukkan kembali PIN ATM")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    SecureField("Konfirmasi PIN ATM baru", text: self.$cPinCtrl)
                        .keyboardType(.numberPad)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding()
                        .onReceive(cPinCtrl.publisher.collect()) {
                            self.cPinCtrl = String($0.prefix(6))
                        }
                }
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                
                if disableIncorrectPin {
                    Text("")
                } else {
                    HStack {
                        Text("PIN ATM yang Anda masukkan tidak sesuai.")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding(.bottom)
    }
    
    // MARK: -Bottom modal for error
    func modalCodeCVVWrong() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("KODE CVV SALAH")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(.red)
                .padding([.bottom, .top], 20)
            
            Text("3 digit nomor terakhir dibelakang kartu ATM Anda tidak sesuai dengan nomor kartu yang terdaftar.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {}) {
                Text("MASUKKAN KEMBALI KODE CVV")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
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
    
    // MARK: -Bottom modal for success
    func modalSuccessActivation() -> some View {
        VStack(alignment: .leading) {
            Image("ic_check")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("AKTIVASI KARTU ATM ANDA TELAH BERHASIL")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(.red)
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("KEMBALI KE HALAMAN UTAMA")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
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
    
    // MARK: -Bottom modal for error
    func modalCodeCVVWrong3Time() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("KODE CVV SALAH 3 KALI")
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(.red)
                .padding([.bottom, .top], 20)
            
            Text("Kode CVV yang Anda masukkan salah. Kesempatan Anda telah habis. Silahkan kembali mencoba Besok.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("KEMBALI KE HALAMAN UTAMA")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
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
    
    func activateKartuKu() {
        self.kartKuVM.activateKartuKu(data: activateData) { success in
            if success {
                print("SUCCESS")
                self.isShowingSuccess = true
            }
            
            if !success {
                print("!SUCCESS")
                
                if (self.kartKuVM.code == "400") {
                    self.isShowingWrongCvv = true
                }
            }
        }
    }
}

//struct CardActivationView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardActivationView(card: myCardData[0])
//    }
//}
