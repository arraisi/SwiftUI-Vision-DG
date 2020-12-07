//
//  VerificationAddressView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct VerificationAddressView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @State var alamat: String = ""
    
    let verificationAddress: [MasterModel] = load("verificationAddress.json")
    
    var disableForm: Bool {
        
        if (registerData.verificationAddressId != 1) {
            if (registerData.alamatKtpFromNik.isEmpty || registerData.rtFromNik.isEmpty || registerData.kelurahanFromNik.isEmpty || registerData.kecamatanFromNik.isEmpty || registerData.kodePosKeluarga.isEmpty) {
                return true
            }
        }
        
        return false
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                ScrollView {
                    VStack {
                        Text("PASTIKAN INFORMASI ANDA BENAR")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .center) {
                            Text("Apakah Alamat Surat Menyurat Anda Sesuai KTP?")
                                .font(.title2)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                            
                            ZStack {

                                RadioButtonGroup(
                                    items: verificationAddress,
                                    selectedId: $registerData.verificationAddressId) { selected in
                                    print("Selected is: \(selected)")
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 15)
                                .padding(.bottom, 20)
                                
                            }
                            
                            if (registerData.verificationAddressId == 1) {
                                EmptyView()
                            } else {
                                
                                Group {
                                    Divider()
                                        .padding(.horizontal, 20)
                                    
                                    LabelTextField(value: $registerData.alamatKtpFromNik, label: "Alamat", placeHolder: "Alamat", onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                        .padding(.horizontal, 20)
                                    
                                    LabelTextField(value: $registerData.rtFromNik, label: "RT/RW", placeHolder: "RT/RW", onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                        .padding(.horizontal, 20)
                                    
                                    LabelTextField(value: $registerData.kelurahanFromNik, label: "Kelurahan", placeHolder: "Kelurahan", onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                        .padding(.horizontal, 20)
                                    
                                    LabelTextField(value: $registerData.kecamatanFromNik, label: "Kecamatan", placeHolder: "Kecamatan", onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                        .padding(.horizontal, 20)
                                    
                                    LabelTextField(value: $registerData.kodePosKeluarga, label: "Kode Pos", placeHolder: "Kode Pos", onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 30)
                                }
                            }
                        
                        }
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 70)
                }
                
                VStack {
                    NavigationLink(destination: PasswordView().environmentObject(registerData)) {
                        Text("Submit Data")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    }
                    .disabled(disableForm)
                    .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 100)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct VerificationAddressView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationAddressView().environmentObject(RegistrasiModel())
    }
}
