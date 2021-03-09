//
//  LimitKartuKuModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/03/21.
//

import Foundation

class LimitKartuKuModel: ObservableObject {
    
    @Published var cardNo = ""
    @Published var maxIbftPerTrans = ""
    @Published var limitOnUs = ""
    @Published var limitWd = ""
    @Published var limitPayment = ""
    @Published var limitPurchase = ""
    @Published var limitIbft = ""
    @Published var pinTrx = ""
    
    static let shared = LimitKartuKuModel()
}
