//
//  QrisModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/04/21.
//

import Foundation

class QrisModel: ObservableObject {
    
    @Published var content = ""
    @Published var pan = ""
    @Published var fromAccountName = ""
    @Published var fromAccount = ""
    @Published var pinTrx = ""
    @Published var transactionAmount = ""
    @Published var transactionFee = ""
    
    @Published var merchantName = ""
    @Published var merchantCity = ""
    
    @Published var transactionDate = ""
    @Published var reffNumber = ""
    @Published var responseCode = ""
    
    static let shared = QrisModel()
}
