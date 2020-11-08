//
//  ListLastTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListLastTransactionView: View {
    
    @State var _listLast = [
        LastTransaction(id: 1, tanggalTransaksi: "08 September 2020", jenisTransaksi: "in", nilaiTransaksi: "240.000"),
        LastTransaction(id: 2, tanggalTransaksi: "28 September 2020", jenisTransaksi: "in", nilaiTransaksi: "40.000"),
        LastTransaction(id: 3, tanggalTransaksi: "1 Oktober 2020", jenisTransaksi: "out", nilaiTransaksi: "4.000.000"),
        LastTransaction(id: 4, tanggalTransaksi: "5 Oktober 2020", jenisTransaksi: "in", nilaiTransaksi: "1.000.000"),
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text("Transaksi Terakhir")
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                
                List(0..._listLast.count - 1, id: \.self) { index in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 30, height: 30)
                            
                            Text("B")
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(_listLast[index].tanggalTransaksi)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.caption)
                                .fontWeight(.ultraLight)
                            
                            if (_listLast[index].jenisTransaksi == "in") {
                                Text("Transfer Masuk")
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.subheadline)
                            } else {
                                Text("Transfer Keluar")
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                        
                        if (_listLast[index].jenisTransaksi == "in") {
                            HStack {
                                Text("- Rp.")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                
                                Text("\(_listLast[index].nilaiTransaksi)")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        } else {
                            HStack {
                                Text("- Rp.")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                
                                Text("\(_listLast[index].nilaiTransaksi)")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                .colorMultiply(Color(hex: "#F6F8FB"))
                .frame(height: 500)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
    }
}

struct ListLastTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListLastTransactionView()
    }
}
