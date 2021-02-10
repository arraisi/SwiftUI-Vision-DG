//
//  TransferOnUsModel.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 02/02/21.
//

import Foundation

class TransferOnUsModel: ObservableObject {
    @Published var username = ""
    @Published var transferType = "TRANSFER_SESAMA"
    @Published var cardNo = ""
    @Published var ref = "1"
    @Published var amount = ""
    @Published var adminFee = ""
    @Published var currency = "360"
    @Published var sourceNumber = ""
    @Published var sourceAccountName = ""
    @Published var destinationNumber = ""
    @Published var destinationName = ""
    @Published var notes = ""
    @Published var pin = ""
    
    @Published var transactionDate = "Sekarang"
    @Published var transactionFrequency = ""
    @Published var transactionVoucher = ""
    
    static let shared = TransferOnUsModel()
}
