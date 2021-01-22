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
    let cardImageBase64: String?
}

struct ATMDesignViewModel {
    var id, key, title: String
    var cardType: String?
    var cardImage: URL?
    var description: String
    let cardImageBase64: UIImage?
    var isShow: Bool = false
}

struct JenisTabunganViewModel {
    var id, name: String
    var image: URL?
    var description: String
    var type: String
    var codePlan: String
    var isShow: Bool = false
}
