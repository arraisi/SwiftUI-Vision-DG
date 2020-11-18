//
//  ScanNPWPView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct ScanNPWPView: View {
    
    /*
     Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    
    @Binding var npwp: String
    @Binding var alreadyHaveNpwp: Bool
    @Binding var imageNPWP: Image?
    @Binding var shouldPresentActionScheet : Bool
    
    let onChange: ()->()
    let onCommit: ()->()
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Silahkan masukan Foto kartu NPWP Anda")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(.black)
                .padding([.vertical], 15)
                .padding(.horizontal, 20)
            
            ZStack {
                Image("ic_camera")
                VStack {
                    imageNPWP?
                        .resizable()
                        .frame(maxWidth: 350, maxHeight: 200)
                        .cornerRadius(10)
                }
                .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 200, maxHeight: 221)
            }
            .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 200, maxHeight: 221)
            .background(Color(hex: "#F5F5F5"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color(.gray).opacity(0.2))
            )
            
            Button(action: {
                self.shouldPresentActionScheet.toggle()
                self.onChange()
            }) {
                Text(imageNPWP == nil ? "Ambil Foto NPWP" : "Ganti Foto Lain")
                    .foregroundColor(imageNPWP == nil ? .white : Color(hex: "#2334D0"))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            }
            .foregroundColor(.black)
            .background(Color(hex: imageNPWP == nil ? "#2334D0" : "#FFFFFF"))
            .cornerRadius(12)
            .padding([.top, .bottom], 15)
            .disabled(alreadyHaveNpwp)
            
            VStack(alignment: .leading) {
                
                Text("Nomor NPWP")
                    .multilineTextAlignment(.leading)
                    .font(.custom("Montserrat-SemiBold", size: 10))
                    .foregroundColor(.black)
                
                TextField("No. NPWP", text: $npwp)
                    .frame(height: 10)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    .onReceive(npwp.publisher.collect()) {
                        self.npwp = String($0.prefix(15))
                    }
                    .disabled(alreadyHaveNpwp)
                
                Button(action: toggleHasNpwp) {
                    HStack(alignment: .top) {
                        Image(systemName: alreadyHaveNpwp ? "checkmark.square": "square")
                        Text("* Saya Menyatakan belum memiliki kartu NPWP.\n Lewati tahapan ini")
                            .font(.custom("Montserrat-Regular", size: 8))
                            .foregroundColor(Color(hex: "#707070"))
                    }
                    .padding(.top, 5)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 15)
                
                if (imageNPWP != nil) {
                    
                    Button(action: {
                        //                        self.formShowed.toggle()
                        self.onCommit()
                        self.registerData.fotoNPWP = self.imageNPWP!
                        self.registerData.npwp = npwp
                        
                        print("REGISTER DATA NPWP : \(self.registerData.npwp)")
                    }) {
                        Text("Simpan")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 15)
                    
                } else { EmptyView() }
                
            }.navigationBarHidden(true)
            
        }
        
    }
    
    /*
     Fungsi untuk Toggle Mempunyai NPWP
     */
    func toggleHasNpwp() {
        self.alreadyHaveNpwp.toggle()
        if self.alreadyHaveNpwp {
            self.npwp = ""
            self.imageNPWP = nil
        }
    }
}

struct ScanNPWPView_Previews: PreviewProvider {
    static var previews: some View {
        ScanNPWPView(npwp: Binding.constant(""), alreadyHaveNpwp: Binding.constant(false), imageNPWP: Binding.constant(nil), shouldPresentActionScheet: Binding.constant(false)) {
            
        } onCommit: {
            
        }
    }
}
