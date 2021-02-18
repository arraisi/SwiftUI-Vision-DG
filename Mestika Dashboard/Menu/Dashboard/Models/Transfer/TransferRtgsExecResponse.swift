//
//  TransferRtgsExecResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 12/02/21.
//

import Foundation

struct TransferRtgsExecResponse: Codable {
    let status: StatusExec
    let destinationBankName, ref, currency, flagResidenceDebitur: String
    let destinationBankCode, nominal, destinationBankMemberName, nominalstr: String
    let accountTo, cardNo, transactionDate, sourceNumber: String
    let addressBeneficiary2, addressBeneficiary1, transferRtgsExecResponseDescription, ultimateBeneficiaryName: String
    let addressBeneficiary3, flagWargaNegara, destinationBankBranchName: String

    enum CodingKeys: String, CodingKey {
        case status, destinationBankName, ref, currency, flagResidenceDebitur, destinationBankCode, nominal, destinationBankMemberName, nominalstr, accountTo, cardNo, transactionDate, sourceNumber, addressBeneficiary2, addressBeneficiary1
        case transferRtgsExecResponseDescription = "description"
        case ultimateBeneficiaryName, addressBeneficiary3, flagWargaNegara, destinationBankBranchName
    }
}

struct StatusExec: Codable {
    let status, message, code: String
}
