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
    
    var body: some View {
        ZStack {
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
                
                Button(action: {}, label: {
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
            .padding(.top, 140)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Aktifkan Kartu")
    }
    
    // MARK: -BOTTOM FLOATER FOR MESSAGE
    func createBottomFloater() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bell")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            Text("KODE CVV SALAH")
                .font(.custom("Montserrat-Bold", size: 12))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            Text("3 Digit terakhir kartu ATM ")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)

//            NavigationLink(destination: ForgotPasswordATMPINView(), label: {
//                Text("Tidak, Saya Tidak Ingat")
//                    .font(.custom("Montserrat-SemiBold", size: 14))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, maxHeight: 50)
//            })
//            .background(Color(hex: "#2334D0"))
//            .cornerRadius(12)
//            .padding(.bottom, 30)
        }
        .frame(width: UIScreen.main.bounds.width - 100)
        .padding(.horizontal, 30)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct VerificationCVVCardView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCVVCardView()
    }
}
