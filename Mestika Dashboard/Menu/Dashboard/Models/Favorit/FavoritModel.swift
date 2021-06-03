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
    let destinationNumber, destinationBankName, type: String
    let transferOnUs: TransferO?
    let typeOfBeneficiary, citizenCode: String?
    let transferOffUsRtgs, transferOffUsSkn: TransferOffUs?
    let transferOffUsOnline: TransferO?
}

// MARK: - TransferO
struct TransferO: Codable {
    let destinationNumber, destinationBankName: String
}

// MARK: - TransferOffUs
struct TransferOffUs: Codable {
    let destinationNumber, destinationBankName, typeOfBeneficiary, citizenCode: String
}

typealias FavoritModel = [FavoritModelElement]
