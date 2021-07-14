//
//  TransferSknExecResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 12/02/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transferSknExecResponse = try? newJSONDecoder().decode(TransferSknExecResponse.self, from: jsonData)

import Foundation

// MARK: - TransferSknExecResponse
struct TransferSknExecResponse: Codable {
    let status: StatusExec
    let flagResidenceCreditor, ref, typeOfBusiness: String
    let sourceName: String?
    let currency, flagResidenceDebitur, destinationBankCode, nominal: String
    let nominalstr, accountTo, branchCode, cardNo: String
    let transactionDate, sourceNumber, clearingCode, transferSknExecResponseDescription: String
    let ultimateBeneficiaryName, flagWargaNegara, provinceCode, cityCode: String
    let digitSign, traceNumber, transactionFee, sumTotal: String

    enum CodingKeys: String, CodingKey {
        case status, flagResidenceCreditor, ref, typeOfBusiness, sourceName, currency, flagResidenceDebitur, destinationBankCode, nominal, nominalstr, accountTo, branchCode, cardNo, transactionDate, sourceNumber, clearingCode
        case transferSknExecResponseDescription = "description"
        case ultimateBeneficiaryName, flagWargaNegara, provinceCode, cityCode, digitSign, traceNumber, transactionFee, sumTotal
    }
}

