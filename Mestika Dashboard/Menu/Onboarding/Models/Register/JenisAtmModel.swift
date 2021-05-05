//
//  JenisAtmModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/05/21.
//

import Foundation

// MARK: - JenisATMModelElement
struct JenisATMModelElement: Codable {
    let classCode, maxIbftPerTrans, limitOnUs, limitWd: String
    let limitPayment, limitPurchase, classDescription, limitIbft: String
    let cardName: String
    let type: [DesainAtmModel]
    let cardImageURL: String

    enum CodingKeys: String, CodingKey {
        case classCode, maxIbftPerTrans, limitOnUs, limitWd, limitPayment, limitPurchase, classDescription, limitIbft, cardName, type
        case cardImageURL = "cardImageUrl"
    }
}

// MARK: - TypeElement
struct DesainAtmModel: Codable {
    let cardTypeName, cardTypeDescription: String
    let cardTypeImageURL: String

    enum CodingKeys: String, CodingKey {
        case cardTypeName, cardTypeDescription
        case cardTypeImageURL = "cardTypeImageUrl"
    }
}

typealias JenisATMModel = [JenisATMModelElement]
