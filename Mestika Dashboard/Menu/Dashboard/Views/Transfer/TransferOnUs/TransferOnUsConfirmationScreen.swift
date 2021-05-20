//
//  TransferOnUsComfirmationScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct TransferOnUsConfirmationScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @EnvironmentObject var transferData: TransferOnUsModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "in_ID")
        return formatter
    }
    
    @State var nominalCtrl: String = ""
    @State var totalTransferCtrl: String = ""
    
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
        .navigationBarTitle("Confirmation".localized(language), displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            self.nominalCtrl = "Rp " + "\(self.transferData.amount.thousandSeparator())"
            self.totalTransferCtrl = "Rp " + "\(self.transferData.amount.thousandSeparator())"
        }
    }
    
    var formCard: some View {
        VStack(alignment: .leading) {
            Image("ic_confirmation")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 40)
                .padding(.horizontal, 15)
            
            Text("CONFIRM TRANSFER".localized(language))
                .font(.title2)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Make sure the recipient data and the nominal amount inputted are correct,".localized(language))
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 15)
                .fixedSize(horizontal: false, vertical: true)
            
            Group {
                
                // Penerima Form
                HStack(spacing: 20) {
                    Text("Recipient's name".localized(language))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Receiver".localized(language), text: self.$transferData.destinationName, onCommit: {
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
                    Text("Beneficiary's Account".localized(language))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Beneficiary's Account".localized(language), text: self.$transferData.destinationNumber, onEditingChanged: { changed in
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
                    Text("Sender's Account".localized(language))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Sender's Account".localized(language), text: self.$transferData.sourceNumber, onEditingChanged: { changed in
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
                    
                    TextField("Nominal Transfer", text: self.$nominalCtrl, onEditingChanged: { changed in
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
                    
                    TextField("Total", text: self.$totalTransferCtrl, onEditingChanged: { changed in
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
                    Text("Transaction Time".localized(language))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("Transaction Time".localized(language), text: self.transferData.transactionDate == dateFormatter.string(from: Date()) ? .constant("Now") : self.$transferData.transactionDate, onEditingChanged: { changed in
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
                    Text("Notes".localized(language))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Notes".localized(language), text: self.$transferData.notes, onCommit: {
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
                    Text("Make a Transfer".localized(language))
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
