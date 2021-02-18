//
//  LimitTransactionResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 18/02/21.
//

import Foundation

// MARK: - LimitTransactionResponse
struct LimitTransactionResponse: Codable {
    let classCode, maxIbftPerTrans, limitOnUs, limitWd: String
    let limitPayment, limitPurchase, classDescription, limitIbft: String
    let cardName, cardDescription, cardImageURL: String

    enum CodingKeys: String, CodingKey {
        case classCode, maxIbftPerTrans, limitOnUs, limitWd, limitPayment, limitPurchase, classDescription, limitIbft, cardName, cardDescription
        case cardImageURL = "cardImageUrl"
    }
}
