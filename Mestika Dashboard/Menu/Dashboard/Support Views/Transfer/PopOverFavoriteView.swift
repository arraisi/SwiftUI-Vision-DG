//
//  PopOverFavoriteView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct PopOverFavoriteView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @StateObject var favoritVM = FavoritViewModel()
    
    var transferData: TransferOnUsModel
    
    @Binding var show: Bool
    @Binding var showAlert: Bool
    @State var receivedName = ""
    @State var receivedBank = "MESTIKA"
    //    @State var receivedRekening = "88091293900"
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Add to favorites?".localized(language))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Contact".localized(language))
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    VStack {
                        TextField("Contact".localized(language), text: self.$receivedName, onEditingChanged: { changed in
                            self.transferData.destinationName = self.receivedName
                            print("\($receivedName)")
                        })
                        .disabled(false)
                        .frame(height: 10)
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .padding()
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                    }
                    .padding(.bottom, 25)
                    
                    HStack {
                        Text("Account Details".localized(language))
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Bank Form
                    HStack(spacing: 20) {
                        
                        HStack {
                            Text("Bank")
                                .font(.caption)
                                .fontWeight(.light)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 60)
                        
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
                        Text("Account number".localized(language))
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100)
                        
                        TextField("Account number".localized(language), text: .constant(transferData.destinationNumber), onEditingChanged: { changed in
                            //                            print("\($receivedRekening)")
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
                        self.transferData.destinationName = self.receivedName
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
                            "transactionDate" : transferData.transactionDate,
                            "nominal" : transferData.amount,
                            "nominalSign" : transferData.amount
                        ]
                        
                        print("TRANSFER ON US body => \(body)")
                        
                        print("\nTRANSFER ON US trx date => \(transferData.transactionDate)")
                        
                        self.favoritVM.transferOnUs(data: transferData) { result in
                            print("Save to favorites".localized(language))
                            self.show = false
                            self.showAlert = true
                        }
                    }, label: {
                        if self.favoritVM.isLoading {
                            ProgressView()
                        } else {
                            Text("SAVE TO FAVORITE".localized(language))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                        }
                    })
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    .disabled(disableForm)
                    .background(disableForm ? Color(.lightGray) : Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)
                }
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 20)
            
            Spacer()
        }
        .onAppear {
            self.receivedName = self.transferData.destinationName
        }
    }
    
    var disableForm: Bool {
        receivedName.isEmpty || self.favoritVM.isLoading
    }
}

struct PopOverFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        PopOverFavoriteView(transferData: TransferOnUsModel(), show: .constant(false), showAlert: .constant(false))
    }
}
