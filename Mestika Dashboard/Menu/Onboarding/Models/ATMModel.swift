//
//  ATMModel.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 01/12/20.
//

import UIKit

struct ATMModel: Codable {
    let id, key, title: String
    let cardType: String?
    let cardImage: String
    let description: ATMDescriptionModel
    let ignoreField, ignoreField1: String
    let cardImageBase64: String
    
}

struct ATMDescriptionModel: Codable {
    let limitPurchase, limitPayment, limitPenarikanHarian: String
    let limitTransferKeBankLain, limitTransferAntarSesama: String
    let codeClass: String
}

struct ATMViewModel {
    var id, key, title: String
    var cardType: String?
    var cardImage: URL?
    var description: ATMDescriptionModel
    var isShow: Bool = false
}
