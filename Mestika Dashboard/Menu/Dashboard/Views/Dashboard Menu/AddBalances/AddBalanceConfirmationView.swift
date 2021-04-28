//
//  AddBalanceConfirmationView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI

struct AddBalanceConfirmationView: View {
    
    @State private var amountCtrl: String = ""
    
    // Environtment Object
    @EnvironmentObject var transactionData: MoveBalancesModel
    
    // Route
    @State private var nextRoute: Bool = false
    
    var body: some View {
        ZStack {
            
            NavigationLink(
                destination: AddBalancePinView().environmentObject(transactionData),
                isActive: self.$nextRoute,
                label: {}
            )
            
            // bg color
            Color(hex: "#F4F7FA")
            
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
            .onAppear {
                self.amountCtrl = "Rp " + "\(self.transactionData.amount.thousandSeparator())"
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var formCard: some View {
        VStack(alignment: .leading) {
            Image("ic_confirmation")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 40)
                .padding(.horizontal, 15)
            
            Text("Konfirmasi Pindah Saldo")
                .font(.title2)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Pastikan data penerima dan jumlah nominal yang di input telah sesuai.")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 15)
                .fixedSize(horizontal: false, vertical: true)
            
            Group {
                
                // Type Transaction
                HStack(spacing: 20) {
                    Text("Jenis Transaksi")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Jenis Transaksi", text: self.$transactionData.transferType, onCommit: {
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
                
                // Source Account
                HStack(spacing: 20) {
                    Text("Rekening Asal")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Rekening Asal", text: self.$transactionData.sourceAccountName, onCommit: {
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
                
                // Destination Account
                HStack(spacing: 20) {
                    Text("Rekening Tujuan")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Rekening Tujuan", text: self.$transactionData.destinationName, onCommit: {
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
                
                // Nominal Transaction
                HStack(spacing: 20) {
                    Text("Nominal Transaksi")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("", text: self.$amountCtrl, onCommit: {
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
                
                // Date Transaction
                HStack(spacing: 20) {
                    Text("Waktu Transaksi")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Waktu Transaksi", text: self.$transactionData.transactionDate, onCommit: {
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
                
                // Frekuensi
                HStack(spacing: 20) {
                    Text("Frekuensi")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Frekuensi", text: self.$transactionData.transactionFrequency, onCommit: {
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
                
                // Notes
                HStack(spacing: 20) {
                    Text("Catatan")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Catatan", text: self.$transactionData.notes, onCommit: {
                    })
                    .disabled(true)
                    .padding(.top, 20)
                    .frame(height: 50)
                    .padding()
                    .font(.subheadline)
                    .background(Color(hex: "#F6F8FB"))
                    .cornerRadius(15)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                Button(action: {
                    
                    self.nextRoute = true
                    
                }, label: {
                    Text("KONFIRMASI TRANSAKSI")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding()
            }
        }
        .frame(minWidth: UIScreen.main.bounds.width - 60, maxWidth: UIScreen.main.bounds.width - 60, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
}

struct AddBalanceConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AddBalanceConfirmationView().environmentObject(MoveBalancesModel())
    }
}
