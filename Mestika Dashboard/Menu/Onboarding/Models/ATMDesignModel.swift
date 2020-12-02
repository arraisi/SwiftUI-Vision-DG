//
//  ATMDesignModel.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 01/12/20.
//

import UIKit

struct ATMDesignModel: Codable {
    let id, key, title: String
    let cardType: String?
    let cardImage: String
    let description: String
//    let ignoreField, ignoreField1: String
//    let ignoreField2, ignoreField3, ignoreField4: AnyObject
    
}

struct ATMDesignViewModel {
    var id, key, title: String
    var cardType: String?
    var cardImage: UIImage
    var description: String
    var isShow: Bool = false
}
