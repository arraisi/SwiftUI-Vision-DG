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
    let id, bankAccountNumber, bankName, name: String
    let sourceNumber, cardNo, type: String
    let transferOnUs: TransferOnUs?
    let transactionDate, nominal, nominalSign: String
    let transferOffUsSkn: TransferOffUsSkn?
    let transferOffUsRtgs: TransferOffUsRtgs?
}

// MARK: - TransferOffUsRtgs
struct TransferOffUsRtgs: Codable {
    let addressBeneficiary3, ref, addressBeneficiary2, addressBeneficiary1: String
    let accountTo, destinationBankBranchName, destinationBankName, destinationBankMemberName: String
    let flagResidenceDebitur, flagWargaNegara, transferOffUsRtgsDescription, ultimateBeneficiaryName: String
    let destinationBankCode, sourceNumber, currency, nominal: String
    let cardNo: String

    enum CodingKeys: String, CodingKey {
        case addressBeneficiary3, ref, addressBeneficiary2, addressBeneficiary1, accountTo, destinationBankBranchName, destinationBankName, destinationBankMemberName, flagResidenceDebitur, flagWargaNegara
        case transferOffUsRtgsDescription = "description"
        case ultimateBeneficiaryName, destinationBankCode, sourceNumber, currency, nominal, cardNo
    }
}

// MARK: - TransferOffUsSkn
struct TransferOffUsSkn: Codable {
    let flagResidenceCreditur, ref, accountTo, clearingCode: String
    let branchCode, provinceCode, cityCode, typeOfBusiness: String
    let digitSign, flagResidenceDebitur, flagWargaNegara, transferOffUsSknDescription: String
    let ultimateBeneficiaryName, destinationBankCode, sourceNumber, currency: String
    let nominal, cardNo: String
    let pin, typeOfBeneficiary: JSONNull?

    enum CodingKeys: String, CodingKey {
        case flagResidenceCreditur, ref, accountTo, clearingCode, branchCode, provinceCode, cityCode, typeOfBusiness, digitSign, flagResidenceDebitur, flagWargaNegara
        case transferOffUsSknDescription = "description"
        case ultimateBeneficiaryName, destinationBankCode, sourceNumber, currency, nominal, cardNo, pin, typeOfBeneficiary
    }
}

// MARK: - TransferOnUs
struct TransferOnUs: Codable {
    let berita, destinationNumber, sourceNumber, currency: String
    let nominal, ref, cardNo: String
}

typealias FavoritModel = [FavoritModelElement]
