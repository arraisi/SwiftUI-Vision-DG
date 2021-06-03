//
//  FavoritModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/02/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let favoritModel = try? newJSONDecoder().decode(FavoritModel.self, from: jsonData)

import Foundation

// MARK: - FavoritModelElement
struct FavoritModelElement: Codable {
    let id, name, sourceNumber, cardNo: String
    let type: String?
    let transferOnUs: TransferO?
    let transferOffUsSkn: TransferOffUsSkn?
    let transferOffUsRtgs: TransferOffUsRtgs?
    let destinationNumber, destinationBankName, favoritModelType, typeOfBeneficiary: String?
    let citizenCode: String?
    let transferOffUsOnline: TransferO?
    
    enum CodingKeys: String, CodingKey {
        case id, name, sourceNumber, cardNo, type, transferOnUs, transferOffUsSkn, transferOffUsRtgs, destinationNumber, destinationBankName
        case favoritModelType
        case typeOfBeneficiary, citizenCode, transferOffUsOnline
    }
}

// MARK: - TransferO
struct TransferO: Codable {
    let destinationNumber: String
    let destinationBankName: String?
}

// MARK: - TransferOffUsSkn
struct TransferOffUsSkn: Codable {
    let destinationBankCode: String?
    let typeOfBeneficiary: String
    let destinationNumber, destinationBankName, citizenCode: String?
}

// MARK: - TransferOffUsRtgs
struct TransferOffUsRtgs: Codable {
    let destinationBankCode, destinationBankName: String
}

typealias FavoritModel = [FavoritModelElement]
