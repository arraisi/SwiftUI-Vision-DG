//
//  MoveBalancesModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import Foundation

class MoveBalancesModel: ObservableObject {
    @Published var username = ""
    @Published var transferType = ""
    @Published var cardNo = ""
    @Published var ref = ""
    @Published var amount = ""
    @Published var adminFee = ""
    @Published var currency = "360"
    @Published var sourceNumber = ""
    @Published var sourceAccountName = ""
    @Published var destinationNumber = ""
    @Published var destinationName = ""
    @Published var notes = ""
    @Published var pin = ""
    
    @Published var idEdit = ""
    
    @Published var transactionDate = "Sekarang"
    @Published var transactionFrequency = ""
    
    @Published var trxDateResp = ""
    
    @Published var mainBalance = ""
    
    static let shared = MoveBalancesModel()
}
