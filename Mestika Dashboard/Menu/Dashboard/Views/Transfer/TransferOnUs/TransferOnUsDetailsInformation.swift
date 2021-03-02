//
//  TransferOnUsDetailsInformation.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct TransferOnUsDetailsInformation: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
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
    }
    
    var formCard: some View {
        VStack(alignment: .leading) {
            
            Text(NSLocalizedString("Transfer Successful".localized(language), comment: ""))
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
                    Text(NSLocalizedString("Transfer Type".localized(language), comment: ""))
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField(NSLocalizedString("Account Type".localized(language), comment: ""), text: self.$transferData.transferType, onEditingChanged: { changed in
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
                
                // Penerima Form
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Receiver".localized(language), comment: ""))
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField(NSLocalizedString("Receiver".localized(language), comment: ""), text: self.$transferData.destinationName, onEditingChanged: { changed in
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
                    Text(NSLocalizedString("Beneficiary's Account".localized(language), comment: ""))
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField(NSLocalizedString("Beneficiary's Account".localized(language), comment: ""), text: self.$transferData.destinationNumber, onEditingChanged: { changed in
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
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Nominal Transfer", text: self.$transferData.amount, onEditingChanged: { changed in
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
                
                // Rekeking Form
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Account".localized(language), comment: ""))
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField(NSLocalizedString("Account".localized(language), comment: ""), text: self.$transferData.sourceAccountName, onEditingChanged: { changed in
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
                    Text(NSLocalizedString("Transaction Time".localized(language), comment: ""))
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField(NSLocalizedString("Transaction Time".localized(language), comment: ""), text: self.$transferData.transactionDate, onEditingChanged: { changed in
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
                
                // Frekuensi Form
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Frequency".localized(language), comment: ""))
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField(NSLocalizedString("Frequency".localized(language), comment: ""), text: self.$transferData.transactionFrequency, onEditingChanged: { changed in
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
                
                // Voucher Form
                HStack(spacing: 20) {
                    Text("Voucher")
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField("Voucher", text: self.$transferData.transactionVoucher, onEditingChanged: { changed in
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
                    Text(NSLocalizedString("Notes".localized(language), comment: ""))
//                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100)
                    
                    TextField(NSLocalizedString("Notes".localized(language), comment: ""), text: self.$transferData.notes, onEditingChanged: { changed in
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
        .navigationBarTitle(NSLocalizedString("Transaction Details".localized(language), comment: ""), displayMode: .inline)
        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        
    }
}

struct TransferOnUsDetailsInformation_Previews: PreviewProvider {
    static var previews: some View {
        TransferOnUsDetailsInformation().environmentObject(TransferOnUsModel())
    }
}
