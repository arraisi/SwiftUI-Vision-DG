//
//  DetailKartuATMView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI

struct DetailKartuATMView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            AppBar
                .padding(.top, 45)
                .padding(.horizontal, 30)
            
            ScrollView {
                VStack(spacing: 25){
                    HStack {
                        Text("KARTU ATM ANDA \nAKAN SEGERA DIKIRIM")
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    
                    Image("atm_bromo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack {
                        Text("Selamat data kartu ATM baru Anda telah berhasil disimpan.")
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#1D2238"))
                        Spacer()
                    }
                    
                    VStack {
                        HStack{
                            Text("Nama")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#707070"))
                            
                            Spacer()
                            
                            TextField("Nama", text: Binding.constant("")) { (isChanged) in
                                
                            } onCommit: {
                                
                            }
                            .font(.custom("Montserrat-Regular", size: 12))
                            .frame(width: 200, height: 36)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        HStack{
                            Text("No. Kartu")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#707070"))
                            
                            Spacer()
                            
                            TextField("No. Kartu", text: Binding.constant("")) { (isChanged) in
                                
                            } onCommit: {
                                
                            }
                            .font(.custom("Montserrat-Regular", size: 12))
                            .frame(width: 200, height: 36)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        HStack{
                            Text("Expired")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#707070"))
                            
                            Spacer()
                            
                            TextField("Expired", text: Binding.constant("")) { (isChanged) in
                                
                            } onCommit: {
                                
                            }
                            .font(.custom("Montserrat-Regular", size: 12))
                            .frame(width: 200, height: 36)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    
                    HStack {
                        Text("Silahkan tunggu beberapa saat sampai kartu ATM Anda diterima.")
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#1D2238"))
                        Spacer()
                    }
                    
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("KEMBALI KE HALAMAN UTAMA")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    })
                    .frame(height: 50)
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    // MARK: - APP BAR
    var AppBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color(hex: "#232175"))
            }
            Spacer()
            logo
            Spacer()
        }
    }
    
    // MARK: - LOGO
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            Image("Logo M")
                .resizable()
                .frame(width: 25, height: 25)
            Text("BANK MESTIKA")
                .foregroundColor(Color(hex: "#232175"))
                .font(.system(size: 20))
                .bold()
        }
    }
}

struct DetailKartuATMView_Previews: PreviewProvider {
    static var previews: some View {
        DetailKartuATMView()
    }
}
