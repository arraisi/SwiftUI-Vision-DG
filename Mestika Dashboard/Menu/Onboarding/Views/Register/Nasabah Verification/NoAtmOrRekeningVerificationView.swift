//
//  RegisterRekeningCardView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 23/09/20.
//

import SwiftUI
import PopupView

struct JenisNoKartu {
    var jenis: String
}

struct NoAtmOrRekeningVerificationView: View {
    
    let jenisKartuList:[JenisNoKartu] = [
        .init(jenis: "Kartu ATM"),
        .init(jenis: "Rekening"),
    ]
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var jenisKartuCtrl: String = ""
    @State var noKartuCtrl: String = ""
    
    /* Root Binding */
    @State var isActive : Bool = false
    @Binding var rootIsActive : Bool
    
    /* Disabled Form */
    var disableForm: Bool {
        noKartuCtrl.count < 6
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: UIScreen.main.bounds.height*0.5)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                AppBarLogo(light: false) {
                    
                }
                
                VStack(alignment: .center) {
                    Text("No. Kartu ATM atau Rekening")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.bold)
                        .padding(.top, 30)
                        .multilineTextAlignment(.center)
                    
                    Text("Silahkan masukan no kartu ATM atau Rekening anda")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#5A6876"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                    
                    HStack {
                        TextField("Pilih jenis no kartu yang diinput", text: $jenisKartuCtrl)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<jenisKartuList.count, id: \.self) { i in
                                Button(action: {
                                    print(jenisKartuList[i])
                                    jenisKartuCtrl = jenisKartuList[i].jenis
                                }) {
                                    Text(jenisKartuList[i].jenis)
                                        .font(.custom("Montserrat-Regular", size: 10))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.vertical, 5)
                    
                    TextField("Masukan no kartu", text: $noKartuCtrl, onEditingChanged: { changed in
                        if (jenisKartuCtrl == "Kartu ATM") {
                            self.registerData.atmOrRekening = "ATM"
                            self.registerData.noAtm = self.noKartuCtrl
                            
                            self.registerData.accType = "ATM"
                            self.registerData.accNo = self.noKartuCtrl
                        } else {
                            self.registerData.atmOrRekening = "REKENING"
                            self.registerData.noRekening = self.noKartuCtrl
                            
                            self.registerData.accType = "REKENING"
                            self.registerData.accNo = self.noKartuCtrl
                        }
                    })
                    .font(.custom("Montserrat-Regular", size: 12))
                    .keyboardType(.numberPad)
                    .padding(15)
                    .background(Color.gray.opacity(0.1))
                    .frame(height: 50)
                    .cornerRadius(20)
                    .onReceive(noKartuCtrl.publisher.collect()) {
                        if (jenisKartuCtrl == "Kartu ATM") {
                            self.noKartuCtrl = String($0.prefix(16))
                        } else {
                            self.noKartuCtrl = String($0.prefix(8))
                        }
                    }
                    
                    Text("*Pastikan kartu ATM atau Rekening Anda telah aktif, jika belum aktifasi kartu ATM silahkan kunjungi Kantor Bank Mestika terdekat.")
                        .font(.custom("Montserrat-Regular", size: 10))
                        .foregroundColor(Color(hex: "#5A6876"))
                        .padding(.top, 5)
                        .padding(.bottom, 30)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    NavigationLink(
                        destination: PhoneOTPRegisterNasabahView(rootIsActive: self.$rootIsActive, root2IsActive: self.$isActive).environmentObject(registerData),
                        isActive: self.$isActive,
                        label: {
                            Text("Verifikasi No. Kartu")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        })
                        .isDetailLink(false)
                        .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.bottom, 30)
                        .disabled(disableForm)
                    
                }
                .padding(.horizontal,30)
                .frame(width: UIScreen.main.bounds.width - 40)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
                .padding(.vertical, 25)
            }
            .padding(.horizontal, 30)
        }
        .edgesIgnoringSafeArea(.all)
        //        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarHidden(true)
        .onAppear{
            //            self.registerData.noTelepon = "85359117336"
            self.registerData.isNasabahmestika = true
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct RegisterRekeningCardView_Previews: PreviewProvider {
    static var previews: some View {
        NoAtmOrRekeningVerificationView(rootIsActive: .constant(false)).environmentObject(RegistrasiModel())
    }
}
