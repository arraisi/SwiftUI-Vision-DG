//
//  TransferRtgsConfirmation.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/02/21.
//

import SwiftUI

struct TransferRtgsConfirmation: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var transferData: TransferOffUsModel
    
    @State var adminFeeCtrl = "Rp. 1.000,00"
    
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
        .navigationBarTitle("Transfer \(self.transferData.transactionType)", displayMode: .inline)
        .onAppear {
            self.transferData.addressOfDestination = self.transferData.notes
        }
    }
    
    var formCard: some View {
        VStack(alignment: .leading) {
            Image("ic_confirmation")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 40)
                .padding(.horizontal, 15)
            
            Text(NSLocalizedString("CONFIRM TRANSFER".localized(language), comment: ""))
                .font(.title2)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Make sure the recipient data and the nominal amount inputted are correct,".localized(language), comment: ""))
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#707070"))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 15)
                .fixedSize(horizontal: false, vertical: true)
            
            Group {
                // Jenis Transfer Form
//                HStack(spacing: 20) {
//                    Text("Jenis Transfer")
//                        .font(.caption)
//                        .fontWeight(.light)
//                        .frame(width: 100, alignment: .leading)
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
                
                // Form Tipe Transaksi
//                HStack(spacing: 20) {
//                    Text("Tipe Transaksi")
//                        .font(.caption)
//                        .fontWeight(.light)
//                        .frame(width: 100, alignment: .leading)
//
//                    TextField("Tipe Transaksi", text: self.$transferData.transactionType, onEditingChanged: { changed in
//                        print("\(self.$transferData.transactionType)")
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
                
                // Penerima Form
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Recipient's name".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField(NSLocalizedString("Receiver".localized(language), comment: ""), text: self.$transferData.destinationName, onEditingChanged: { changed in
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
                
                // Form Nama Bank
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Bank name".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField("Bank", text: self.$transferData.bankName, onCommit: {
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
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField(NSLocalizedString("Beneficiary's Account".localized(language), comment: ""), text: self.$transferData.destinationNumber, onEditingChanged: { changed in
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
            }
            
            if (self.transferData.transactionType == "RTGS") {
                Group {
                    // Tipe Penerima Form
                    HStack(spacing: 20) {
                        Text(NSLocalizedString("Receiver Type".localized(language), comment: ""))
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField(NSLocalizedString("Receiver Type".localized(language), comment: ""), text: self.$transferData.typeDestination, onEditingChanged: { changed in
                            print("\(self.$transferData.typeDestination)")
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
                    
                    // Kewarganegaraan Form
                    HStack(spacing: 20) {
                        Text(NSLocalizedString("Citizen".localized(language), comment: ""))
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField(NSLocalizedString("Citizenship".localized(language), comment: ""), text: self.$transferData.citizenship, onEditingChanged: { changed in
                            print("\(self.$transferData.citizenship)")
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
                    
                    // Province Form
//                    HStack(spacing: 20) {
//                        Text("Provinsi Penerima")
//                            .font(.caption)
//                            .fontWeight(.light)
//                            .frame(width: 100)
//
//                        TextField("Provinsi Penerima", text: self.$transferData.provinceOfDestination, onEditingChanged: { changed in
//                            print("\(self.$transferData.provinceOfDestination)")
//                        })
//                        .disabled(true)
//                        .frame(height: 20)
//                        .padding()
//                        .font(.subheadline)
//                        .background(Color(hex: "#F6F8FB"))
//                        .cornerRadius(15)
//                    }
//                    .padding(.vertical, 5)
//                    .padding(.horizontal)
                    
                    // City Form
//                    HStack(spacing: 20) {
//                        Text("Kota Penerima")
//                            .font(.caption)
//                            .fontWeight(.light)
//                            .frame(width: 100)
//
//                        TextField("Kota Penerima", text: self.$transferData.cityOfDestination, onEditingChanged: { changed in
//                            print("\(self.$transferData.cityOfDestination)")
//                        })
//                        .disabled(true)
//                        .frame(height: 20)
//                        .padding()
//                        .font(.subheadline)
//                        .background(Color(hex: "#F6F8FB"))
//                        .cornerRadius(15)
//                    }
//                    .padding(.vertical, 5)
//                    .padding(.horizontal)
                    
                    // Alamat Penerima Form
                    HStack(spacing: 20) {
                        Text(NSLocalizedString("Recipient Address".localized(language), comment: ""))
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField(NSLocalizedString("Recipient Address".localized(language), comment: ""), text: self.$transferData.addressOfDestination, onEditingChanged: { changed in
                            print("\(self.$transferData.addressOfDestination)")
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
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField(NSLocalizedString("Account".localized(language), comment: ""), text: self.$transferData.sourceAccountName, onEditingChanged: { changed in
                            print("\(self.$transferData.sourceAccountName)")
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
                }
            } else if (self.transferData.transactionType == "Online") {
                EmptyView()
            } else if (self.transferData.transferType == "SKN") {
                Group {
                    // Tipe Penerima Form
                    HStack(spacing: 20) {
                        Text(NSLocalizedString("Receiver Type".localized(language), comment: ""))
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField(NSLocalizedString("Receiver Type".localized(language), comment: ""), text: self.$transferData.typeDestination, onEditingChanged: { changed in
                            print("\(self.$transferData.typeDestination)")
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
                    
                    // Kewarganegaraan Form
                    HStack(spacing: 20) {
                        Text(NSLocalizedString("Citizen".localized(language), comment: ""))
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField(NSLocalizedString("Citizenship".localized(language), comment: ""), text: self.$transferData.citizenship, onEditingChanged: { changed in
                            print("\(self.$transferData.citizenship)")
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
                }
            }
            
            Group {
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
                
                // Admin Fee
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Admin Fee".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField(NSLocalizedString("Admin Fee".localized(language), comment: ""), text: self.$adminFeeCtrl, onEditingChanged: { changed in
//                        print("\(self.$transferData.destinationNumber)")
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
                
                // Total Transaksi Form
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Total Transactions".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField(NSLocalizedString("Total Transactions".localized(language), comment: ""), text: self.$transferData.amount, onEditingChanged: { changed in
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
                
                // Waktu Transaksi
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Transaction Time".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
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
//                HStack(spacing: 20) {
//                    Text("Frekuensi")
//                        .font(.caption)
//                        .fontWeight(.light)
//                        .frame(width: 100, alignment: .leading)
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
                
                // Catatan Form
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Notes".localized(language), comment: ""))
                        .font(.caption)
                        .fontWeight(.light)
                        .frame(width: 100, alignment: .leading)
                    
                    MultilineTextField(NSLocalizedString("Notes".localized(language), comment: ""), text: self.$transferData.notes, onCommit: {
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
                NavigationLink(destination: TransferRtgsValidationPin(unLocked: false).environmentObject(transferData), label: {
                    Text(NSLocalizedString("Make a Transfer".localized(language), comment: ""))
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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

struct TransferRtgsConfirmation_Previews: PreviewProvider {
    static var previews: some View {
        TransferRtgsConfirmation().environmentObject(TransferOffUsModel())
    }
}
