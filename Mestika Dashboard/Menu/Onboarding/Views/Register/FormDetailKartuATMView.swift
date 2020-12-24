//
//  DetailKartuATMView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI
import NavigationStack
import SDWebImageSwiftUI

struct FormDetailKartuATMView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @ObservedObject private var productVM = ATMProductViewModel()
    
    @State private var is_video_call = UserDefaults.standard.string(forKey: "register_nasabah_video_call")
    @State private var is_register_nasabah = UserDefaults.standard.string(forKey: "register_nasabah")
    
    var body: some View {
        VStack {
            AppBarLogo(onCancel: {})
            
            ScrollView {
                VStack(spacing: 25){
                    HStack {
                        Text("KARTU ATM ANDA \nAKAN SEGERA DIKIRIM")
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    
//                    Image("atm_bromo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                    
                    WebImage(url: registerData.desainKartuATMImage)
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        .placeholder {
                            Rectangle().foregroundColor(.gray).opacity(0.5)
                        }
                        .resizable()
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFill()
                        .cornerRadius(10)
                    
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
                            
                            TextField("Nama", text: $atmData.atmName) { (isChanged) in
                                
                            } onCommit: {
                                
                            }
                            .disabled(true)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .frame(width: 200, height: 36)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        if (is_video_call == "true" || is_register_nasabah == "true") {
                            EmptyView()
                        } else {
                            Group {
                                HStack {
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
                                    .disabled(true)
                                }
                                
                                HStack {
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
                                    .disabled(true)
                                }
                            }
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
                        self.appState.moveToWelcomeView = true
                    }) {
                        Text("KEMBALI KE HALAMAN UTAMA")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
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
}

struct DetailKartuATMView_Previews: PreviewProvider {
    static var previews: some View {
        FormDetailKartuATMView()
    }
}
