//
//  SavingSelectionModalView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 25/09/20.
//

import SwiftUI

struct SavingSelectionModalView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Image("Saving Landscape")
                    .resizable()
                    .frame(height: 200)
                
                Text("Anda Telah memilih Tabungan")
                    .font(.caption)
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                    .foregroundColor(Color(hex: "#5A6876"))
                
                Text("Deposit Tabungan")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(hex: "#232175"))
                    .padding(.horizontal, 15)
                
                Text("Keunggulan Tabungan :")
                    .font(.footnote)
                    .padding(.top, 10)
                    .padding(.horizontal, 15)
                    .foregroundColor(Color(hex: "#5A6876"))
                
                ScrollView {
                    HStack(alignment: .top) {
                        Text("01")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#5A6876"))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 15)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(alignment: .top) {
                        Text("02")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#5A6876"))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 15)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(alignment: .top) {
                        Text("03")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#5A6876"))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 15)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(alignment: .top) {
                        Text("04")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#5A6876"))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 15)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(alignment: .top) {
                        Text("05")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#5A6876"))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 15)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .frame(height: 250)
            }
            
            NavigationLink(destination: FormIdentitasDiriView().environmentObject(registerData)) {
                Text("Pilih Tabungan ini")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Button(action: {}) {
                Text("Pilih Tabungan lain")
                    .foregroundColor(Color(hex: "#5A6876"))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .padding(.top, 5)
        }
        .frame(width: UIScreen.main.bounds.width - 40)
    }
}

struct SavingSelectionModalView_Previews: PreviewProvider {
    static var previews: some View {
        SavingSelectionModalView().environmentObject(RegistrasiModel())
    }
}
