//
//  TransferSknExecResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 12/02/21.
//

import Foundation

struct TransferSknExecResponse: Codable {
    let status: StatusExec
    let flagResidenceCreditor, ref, typeOfBusiness: String
    let sourceName: JSONNull?
    let currency, flagResidenceDebitur, destinationBankCode, nominal: String
    let nominalstr, accountTo, branchCode, cardNo: String
    let transactionDate, sourceNumber, clearingCode, transferSknExecResponseDescription: String
    let ultimateBeneficiaryName, flagWargaNegara, provinceCode, cityCode: String
    let digitSign: String
    let sumTotal: String

    enum CodingKeys: String, CodingKey {
        case status, flagResidenceCreditor, ref, typeOfBusiness, sourceName, currency, flagResidenceDebitur, destinationBankCode, nominal, nominalstr, accountTo, branchCode, cardNo, transactionDate, sourceNumber, clearingCode
        case transferSknExecResponseDescription = "description"
        case ultimateBeneficiaryName, flagWargaNegara, provinceCode, cityCode, digitSign
        case sumTotal
    }
}
