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
    let destinationNumber, destinationBankName: String
    let transferOffUsRtgs: TransferOffUsRtgs?
    let transferOnUs: TransferOnUs?
    let transferOffUsSkn: TransferOffUsSkn?
    let transferOffUsOnline: TransferOffUsOnline?
}

// MARK: - TransferOffUsOnline
struct TransferOffUsOnline: Codable {
    let destinationNumber, destinationBankName: String
}

// MARK: - TransferOffUsRtgs
struct TransferOffUsRtgs: Codable {
    let destinationNumber, destinationBankName, typeOfBeneficiary, citizenCode: String
}

// MARK: - TransferOffUsSkn
struct TransferOffUsSkn: Codable {
    let destinationNumber, destinationBankName, typeOfBeneficiary, citizenCode: String
}

// MARK: - TransferOnUs
struct TransferOnUs: Codable {
    let destinationNumber, destinationBankName: String
}

typealias FavoritModel = [FavoritModelElement]
