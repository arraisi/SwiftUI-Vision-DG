//
//  TransferOnUsDetailsInformation.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct TransferOnUsDetailsInformation: View {
    
    @State private var jenisRekeningCtrl = "Antar Sesama Bank"
    @State private var penerimaCtrl = "Prima Jatnika"
    @State private var rekeningPenerimaCtrl = "20091289812"
    @State private var nominalTransferCtrl = "200.000"
    @State private var rekeningCtrl = "Rekening Utama / 01"
    @State private var waktuTransaksiCtrl = "20 Oktober 2020"
    @State private var frekuensiCtrl = "Sekali Pengiriman"
    @State private var voucherCtrl = "VCR-100K"
    @State private var catatanCtrl = "-"

    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack {
//                Color(hex: "#2334D0")
//                    .edgesIgnoringSafeArea(.top)
//                    .frame(height: 0)
                
                ScrollView {
                    VStack {
                        formCard
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 35)
                    .padding(.bottom, 35)
                }
            }
        }
    }
    
    var formCard: some View {
        VStack(alignment: .leading) {
            
            Text("Transfer Berhasil")
                .font(.title2)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)
                .padding(.top, 40)
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Group {
                // Jenis Transfer Form
                HStack(spacing: 20) {
                    Text("Jenis Transfer")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Jenis Rekening", text: $jenisRekeningCtrl, onEditingChanged: { changed in
                        print("\($jenisRekeningCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Penerima Form
                HStack(spacing: 20) {
                    Text("Penerima")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Penerima", text: $penerimaCtrl, onEditingChanged: { changed in
                        print("\($penerimaCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Rekening Penerima Form
                HStack(spacing: 20) {
                    Text("Rekening Penerima")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Rekening Penerima", text: $rekeningPenerimaCtrl, onEditingChanged: { changed in
                        print("\($rekeningPenerimaCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Nominal Transfer
                HStack(spacing: 20) {
                    Text("Nominal Transfer")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Nominal Transfer", text: $nominalTransferCtrl, onEditingChanged: { changed in
                        print("\($nominalTransferCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Rekeking Form
                HStack(spacing: 20) {
                    Text("Rekening")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Rekening", text: $rekeningCtrl, onEditingChanged: { changed in
                        print("\($rekeningCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Waktu Transaksi Form
                HStack(spacing: 20) {
                    Text("Waktu Transaksi")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Waktu Transaksi", text: $waktuTransaksiCtrl, onEditingChanged: { changed in
                        print("\($waktuTransaksiCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Frekuensi Form
                HStack(spacing: 20) {
                    Text("Frekuensi")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Frekuensi", text: $frekuensiCtrl, onEditingChanged: { changed in
                        print("\($frekuensiCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Voucher Form
                HStack(spacing: 20) {
                    Text("Voucher")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Voucher", text: $voucherCtrl, onEditingChanged: { changed in
                        print("\($voucherCtrl)")
                    })
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Catatan Form
                HStack(spacing: 20) {
                    Text("Catatan")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Catatan", text: $catatanCtrl, onEditingChanged: { changed in
                        print("\($catatanCtrl)")
                    })
                    .frame(height: 50)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
            }
            
            VStack {
                Button(action: {}, label: {
                    Text("Download e-Receipt")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
            }
            .padding()
            
        }
        .navigationBarTitle("Detail Transaksi", displayMode: .inline)
        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        
    }
}

struct TransferOnUsDetailsInformation_Previews: PreviewProvider {
    static var previews: some View {
        TransferOnUsDetailsInformation()
    }
}
