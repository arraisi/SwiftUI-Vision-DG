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
//    var id, bankAccountNumber, bankName, name: String
//    let sourceNumber, cardNo, type: String
//    let transferOnUs: TransferOnUs?
//    let transactionDate, nominal, nominalSign: String
//    let transferOffUsSkn: TransferOffUsSkn?
//    let transferOffUsRtgs: TransferOffUsRtgs?
    let id, name, sourceNumber, cardNo: String
    let type: String
    let transferOffUsRtgs: TransferOffUsRtgs?
    let transferOnUs: TransferOnUs?
    let transferOffUsSkn: TransferOffUsSkn?
}

// MARK: - TransferOffUsRtgs
struct TransferOffUsRtgs: Codable {
//    let name: String, accountTo: String?
    let destinationBankCode, destinationBankName: String
}

// MARK: - TransferOffUsSkn
struct TransferOffUsSkn: Codable {
    let flagResidenceCreditur, ref, accountTo, clearingCode: String
    let branchCode, provinceCode, cityCode, typeOfBusiness: String
    let digitSign, flagResidenceDebitur, flagWargaNegara, transferOffUsSknDescription: String
    let ultimateBeneficiaryName, destinationBankCode, sourceNumber, currency: String
    let nominal, cardNo: String
    let pin, typeOfBeneficiary: String?
    let transactionFee: String?

    enum CodingKeys: String, CodingKey {
        case flagResidenceCreditur, ref, accountTo, clearingCode, branchCode, provinceCode, cityCode, typeOfBusiness, digitSign, flagResidenceDebitur, flagWargaNegara
        case transferOffUsSknDescription = "description"
        case ultimateBeneficiaryName, destinationBankCode, sourceNumber, currency, nominal, cardNo, pin, typeOfBeneficiary
        case transactionFee
    }
}

// MARK: - TransferOnUs
struct TransferOnUs: Codable {
    let destinationNumber: String
}

typealias FavoritModel = [FavoritModelElement]
