//
//  PopOverFavoriteView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct PopOverFavoriteView: View {
    
    @StateObject var favoriteVM = FavoritesViewModel()
    
    var transferData: TransferOnUsModel
    
    @Binding var show: Bool
    @State var receivedName = "NOVI PAHMALIA"
    @State var receivedBank = "Mestika"
    @State var receivedRekening = "88091293900"
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Tambahkan ke Favorit?")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Nama Kontrak Penerima")
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    VStack {
                        TextField("Nama Kontak Penerima", text: .constant(transferData.destinationName), onEditingChanged: { changed in
                            print("\($receivedName)")
                        })
                        .disabled(true)
                        .frame(height: 10)
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .padding()
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                    }
                    .padding(.bottom, 25)
                    
                    HStack {
                        Text("Detail Rekening")
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Bank Form
                    HStack(spacing: 20) {
                        Text("Bank")
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100)
                        
                        TextField("Bank", text: $receivedBank, onEditingChanged: { changed in
                            print("\($receivedBank)")
                        })
                        .disabled(true)
                        .frame(height: 10)
                        .padding()
                        .font(.subheadline)
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    
                    // No. Rekening Form
                    HStack(spacing: 20) {
                        Text("No. Rekening")
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100)
                        
                        TextField("No. Rekening", text: .constant(transferData.destinationNumber), onEditingChanged: { changed in
                            print("\($receivedRekening)")
                        })
                        .disabled(true)
                        .frame(height: 10)
                        .padding()
                        .font(.subheadline)
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    
                    Button(action: {
                        
                        // MARK: BODY
                        let body: [String: Any] = [
                            "bankAccountNumber" : "001",
                            "bankName" : "MESTIKA",
                            "name" : transferData.destinationName,
                            "sourceNumber" : transferData.sourceNumber,
                            "cardNo" : transferData.cardNo,
                            "type" : transferData.transferType,
                            "transferOnUs" : [
                                "cardNo" : transferData.cardNo,
                                "ref": transferData.ref,
                                "nominal": transferData.amount,
                                "currency": transferData.currency,
                                "sourceNumber": transferData.sourceNumber,
                                "destinationNumber": transferData.destinationNumber,
                                "berita": "testing"
                            ],
                            "transactionDate" : "2020-01-10 10:20:57",
                            "nominal" : transferData.amount,
                            "nominalSign" : transferData.amount
                        ]
                        
                        print("TRANSFER ON US body => \(body)")
                        
                        self.favoriteVM.transferOnUs(data: transferData) { result in
                            print("Berhasil simpan ke favorite")
                            self.show = false
                        }
                    }, label: {
                        Text("SIMPAN KE FAVORIT")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        
                    })
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 30, alignment: .top)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 20)
            Spacer()
        }
    }
}

struct PopOverFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        PopOverFavoriteView(transferData: TransferOnUsModel(), show: .constant(false))
    }
}
