//
//  TransferOnUsComfirmationScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct TransferOnUsConfirmationScreen: View {
    
    @EnvironmentObject var transferData: TransferOnUsModel
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack {
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
        .navigationBarTitle("Konfirmasi", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var formCard: some View {
        VStack(alignment: .leading) {
            Image("ic_confirmation")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 40)
                .padding(.horizontal, 15)
            
            Text("Konfirmasi Transfer")
                .font(.title2)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Pastikan data penerima dan jumlah nominal yang di input telah sesuai,")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 15)
                .fixedSize(horizontal: false, vertical: true)
            
            Group {
                
                // Penerima Form
                HStack(spacing: 20) {
                    Text("Nama Penerima")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Penerima", text: self.$transferData.destinationName, onEditingChanged: { changed in
                        print("\(self.$transferData.destinationName)")
                    })
                    .disabled(true)
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
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Rekening Penerima", text: self.$transferData.destinationNumber, onEditingChanged: { changed in
                        print("\(self.$transferData.destinationNumber)")
                    })
                    .disabled(true)
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Rekening Pengirim Form
                HStack(spacing: 20) {
                    Text("Rekening Pengirim")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Rekening Pengirim", text: self.$transferData.sourceNumber, onEditingChanged: { changed in
                        print("\(self.$transferData.sourceNumber)")
                    })
                    .disabled(true)
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
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Nominal Transfer", text: self.$transferData.amount, onEditingChanged: { changed in
                        print("\(self.$transferData.destinationNumber)")
                    })
                    .disabled(true)
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                //                // Jenis Transfer Form
                //                HStack(spacing: 20) {
                //                    Text("Jenis Transfer")
                //                        .font(.caption)
                //                        .fontWeight(.light)
                //                        .frame(width: 100)
                //
                //                    TextField("Jenis Rekening", text: self.$transferData.transferType, onEditingChanged: { changed in
                //                        print("\(self.$transferData.transferType)")
                //                    })
                //                    .disabled(true)
                //                    .frame(height: 20)
                //                    .padding()
                //                    .font(.subheadline)
                //                    .background(Color(hex: "#F6F8FB"))
                //                    .cornerRadius(15)
                //                }
                //                .padding(.vertical, 5)
                //                .padding(.horizontal)
                //
                //                // Rekeking Form
                //                HStack(spacing: 20) {
                //                    Text("Rekening")
                //                        .font(.caption)
                //                        .fontWeight(.light)
                //                        .frame(width: 100)
                //
                //                    TextField("Rekening", text: self.$transferData.sourceAccountName, onEditingChanged: { changed in
                //                        print("\(self.$transferData.sourceAccountName)")
                //                    })
                //                    .disabled(true)
                //                    .frame(height: 20)
                //                    .padding()
                //                    .font(.subheadline)
                //                    .background(Color(hex: "#F6F8FB"))
                //                    .cornerRadius(15)
                //                }
                //                .padding(.vertical, 5)
                //                .padding(.horizontal)
                
                //                // Frekuensi Form
                //                HStack(spacing: 20) {
                //                    Text("Frekuensi")
                //                        .font(.caption)
                //                        .fontWeight(.light)
                //                        .frame(width: 100)
                //
                //                    TextField("Frekuensi", text: self.$transferData.transactionFrequency, onEditingChanged: { changed in
                //                        print("\(self.$transferData.transactionFrequency)")
                //                    })
                //                    .disabled(true)
                //                    .frame(height: 20)
                //                    .padding()
                //                    .font(.subheadline)
                //                    .background(Color(hex: "#F6F8FB"))
                //                    .cornerRadius(15)
                //                }
                //                .padding(.vertical, 5)
                //                .padding(.horizontal)
                
                // Voucher Form
                HStack(spacing: 20) {
                    Text("Voucher")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Voucher", text: self.$transferData.transactionVoucher, onEditingChanged: { changed in
                        print("\(self.$transferData.transactionVoucher)")
                    })
                    .disabled(true)
                    .frame(height: 20)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                // Total Transfer Form
                HStack(spacing: 20) {
                    Text("Total Transfer")
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Total", text: self.$transferData.amount, onEditingChanged: { changed in
                        print("\(self.$transferData.amount)")
                    })
                    .disabled(true)
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
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Waktu Transaksi", text: self.$transferData.transactionDate, onEditingChanged: { changed in
                        print("\(self.$transferData.transactionDate)")
                    })
                    .disabled(true)
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
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Catatan", text: self.$transferData.notes, onCommit: {
                    })
                    .disabled(true)
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
                NavigationLink(destination: TransferOnUsPinConfirmationScreen(unLocked: false).environmentObject(transferData), label: {
                    Text("Lakukan Transfer")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    
                })
                .isDetailLink(false)
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
            }
            .padding()
            
        }
        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        
    }
}

struct TransferOnUsConfirmationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransferOnUsConfirmationScreen().environmentObject(TransferOnUsModel())
        }
    }
}
