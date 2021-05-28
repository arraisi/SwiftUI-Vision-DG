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
    let type: String
    let transferOffUsRtgs: TransferOffUsRtgs?
    let transferOnUs: TransferO?
    let destinationNumber, destinationBankName, typeOfBeneficiary, citizenCode: String?
    let transferOffUsSkn: TransferOffUsSkn?
    let transferOffUsOnline: TransferO?
}

// MARK: - TransferO
struct TransferO: Codable {
    let destinationNumber: String
    let destinationBankName: String?
}

// MARK: - TransferOffUsRtgs
struct TransferOffUsRtgs: Codable {
    let destinationBankCode, destinationBankName: String
}

// MARK: - TransferOffUsSkn
struct TransferOffUsSkn: Codable {
    let destinationNumber, destinationBankName, typeOfBeneficiary, citizenCode: String
}

typealias FavoritModel = [FavoritModelElement]
