//
//  TransferOffUsModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/02/21.
//

import Foundation

class TransferOffUsModel: ObservableObject {
    @Published var username = ""
    @Published var transferType = "ke Bank Lain"
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
    @Published var destinationBankCode = ""
    @Published var swiftCode = ""
    @Published var kliringCode = ""
    
    @Published var transactionType = ""
    @Published var bankName = ""
    @Published var combinationBankName = ""
    
    @Published var typeDestination = ""
    @Published var citizenship = ""
    @Published var provinceOfDestination = ""
    @Published var cityOfDestination = ""
    @Published var addressOfDestination = ""
    
    @Published var trxDateResp = ""
    @Published var totalTrx = ""
    
    static let shared = TransferOffUsModel()
}
