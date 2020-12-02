//
//  ATMModel.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 01/12/20.
//

import UIKit

struct ATMModel: Codable {
    let id, key, title: String
    let cardImage: String
    let description: ATMDescriptionModel
    let ignoreField, ignoreField1: String
//    let ignoreField2, ignoreField3, ignoreField4: AnyObject
    
}

struct ATMDescriptionModel: Codable {
    let limitPurchase, limitPayment, limitPenarikanHarian: String
    let limitTransferKeBankLain, limitTransferAntarSesama: String
    let codeClass: String
}

struct ATMCard {
    var id, key, title: String
    var cardImage: UIImage
    var description: ATMDescriptionModel
    var isShow: Bool = false
}