//
//  SuccessPaymentQrisView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/03/21.
//

import SwiftUI

struct SuccessPaymentQrisView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            
            VStack(spacing: 15) {
                
                Image("ic_check")
                    .resizable()
                    .frame(width: 69, height: 69)
                
                
                Text("Pembayaran Berhasil")
                    .font(.custom("Montserrat-Bold", size: 14))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .multilineTextAlignment(.center)
                
                HStack{
                    Text("REF : 123456789")
                    Spacer()
                    Text("2020/09/12 19:00:00")
                }
                .font(.custom("Montserrat-Bold", size: 10))
                .foregroundColor(Color("DarkStaleBlue"))
                
                Divider()
                
                VStack(spacing: 5) {
                    
                    HStack(alignment: .top) {
                        
                        Text("Rekening Sumber".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            
                            Text("Yovi Eka Putra".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 12))
                            
                            Text("xxxxxxx1234".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 10))
                        }
                        
                    }
                    
                    HStack(alignment: .top) {
                        Text("Merchant".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundColor(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            
                            Text("GRAMEDIA".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 12))
                            
                            Text("Karawaci Kelapa Dua".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 10))
                            
                            Text("TERMA00001".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 10))
                        }
                    }
                    
                }
                
                VStack(spacing: 5) {
                    
                    Text("Total Bayar")
                        .font(.custom("Montserrat-Bold", size: 12))
                    
                    HStack(alignment: .top, spacing: 2) {
                        Text("IDR")
                            .font(.custom("Montserrat-Bold", size: 12))
                        
                        Text("200000".thousandSeparator())
                            .font(.custom("Montserrat-Bold", size: 24))
                    }
                    .foregroundColor(Color("DarkStaleBlue"))
                    
                }
                .padding([.horizontal, .top])
                
                VStack {
                    
                    Text("Rincian")
                        .font(.custom("Montserrat-Bold", size: 12))
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Transaksi")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                            Spacer()
                            Text("Pembayan QRIS")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                        }
                        HStack {
                            Text("Jumlah Nominal")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                            Spacer()
                            Text("IDR 200.0000")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                        }
                        HStack {
                            Text("Tips")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                            Spacer()
                            Text("IDR 2.000")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                        }
                        HStack {
                            Text("Invoice Number")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                            Spacer()
                            Text("0123456789")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                        }
                    }
                    .foregroundColor(Color("DarkStaleBlue"))
                    
                }
                .padding([.horizontal, .bottom])
                
                Divider()
                
                Text("*Bukti transaksi ini akan dikirim ke email Anda")
                    .font(.custom("Montserrat-SemiBold", size: 10))
                    .foregroundColor(.gray)
                
                Button(action: {
                    self.appState.moveToDashboard = true
                }) {
                    Text("Done".localized(language))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                
            }
            .padding(25) // padding content
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color("DarkStaleBlue").opacity(0.2), radius: 10)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            
            Spacer()
        }
        .navigationBarTitle("Pembayaran QRIS", displayMode: .inline)

    }
}

struct SuccessPaymentQrisView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessPaymentQrisView()
    }
}
