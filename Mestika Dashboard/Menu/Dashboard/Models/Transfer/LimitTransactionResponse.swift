//
//  LimitTransactionResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 18/02/21.
//

import Foundation

// MARK: - LimitTransactionResponse
// MARK: - LimitTransactionResponse
struct LimitTransactionResponse: Codable {
    let classCode, maxIbftPerTrans, limitOnUs, limitWd: String
    let limitPayment, limitPurchase, classDescription, limitIbft: String
    let cardName: String
    let type: [TypeElement]
    let cardImageURL: String?
    let cardReplaceFee: String

    enum CodingKeys: String, CodingKey {
        case classCode, maxIbftPerTrans, limitOnUs, limitWd, limitPayment, limitPurchase, classDescription, limitIbft, cardName, type
        case cardImageURL = "cardImageUrl"
        case cardReplaceFee
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let cardTypeName, cardTypeDescription: String
    let cardTypeImageURL: String

    enum CodingKeys: String, CodingKey {
        case cardTypeName, cardTypeDescription
        case cardTypeImageURL = "cardTypeImageUrl"
    }
}
