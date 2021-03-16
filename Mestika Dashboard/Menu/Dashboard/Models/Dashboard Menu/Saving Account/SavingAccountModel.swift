//
//  SavingAccountModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation

// MARK: - SavingAccountModelElement
struct SavingAccountModelElement: Codable, Hashable {
    let accountName: String
    let accountType: AccountType
    let planAllowDebitInHouse, planAllowInquiry: PlanAllow
    let accountNumber: String
    let planAllowDebitDomestic: PlanAllow
    let accountStatusDescription: AccountStatusDescription
    let accountStatus: String
    let accountTypeDescription: AccountTypeDescription
    let currency: String
    let planAllowCreditDomestic, planAllowCreditInHouse: PlanAllow
    let cardNumber: String
    let accountBranch: String
}

enum AccountStatusDescription: String, Codable {
    case aktif = "AKTIF"
    case empty = ""
}

enum AccountType: String, Codable {
    case empty = ""
    case s = "S"
}

enum AccountTypeDescription: String, Codable {
    case empty = ""
    case saving = "SAVING"
}

enum PlanAllow: String, Codable {
    case empty = ""
    case y = "Y"
}

typealias SavingAccountModel = [SavingAccountModelElement]
