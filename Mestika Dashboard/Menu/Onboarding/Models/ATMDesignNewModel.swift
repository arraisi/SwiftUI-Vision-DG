//
//  ATMDesignNewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 14/01/21.
//

import Foundation

// MARK: - ATMDesignNewModel
struct ATMDesignNewModel: Codable {
    let data: DataClassATM
    let success: Bool
}

// MARK: - DataClass
struct DataClassATM: Codable {
    let content: [ContentATM]
}

// MARK: - Content
struct ContentATM: Codable {
    let key, title, id, contentDescription: String
    let cardType: String
    let cardImage: String
    let cardImageBase64: String?

    enum CodingKeys: String, CodingKey {
        case key, title, id
        case contentDescription = "description"
        case cardType, cardImage, cardImageBase64
    }
}
