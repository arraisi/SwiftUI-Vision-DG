//
//  DetailsTypeSavingView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI

struct DetailsTypeSavingView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Deposit Tabungan")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(hex: "#3756DF"))
                .padding(.top, 10)
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Keunggulan Tabungan :")
                .font(.footnote)
                .padding(.top, 10)
                .padding(.horizontal, 15)
                .foregroundColor(Color(hex: "#5A6876"))
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
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
            }
            .frame(height: 250)
            
            Button(action: {}) {
                Text("Pilih Tabungan ini")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .padding(.top, 10)
            
        }
        .padding(10)
        .background(Color.white)
    }
}

struct DetailsTypeSavingView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsTypeSavingView()
    }
}
