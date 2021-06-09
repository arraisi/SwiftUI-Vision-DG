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
    let accountType: String?
    let planAllowDebitInHouse, planAllowInquiry: String?
    let accountNumber: String
    let planAllowDebitDomestic: String?
    let accountStatusDescription: String?
    let accountStatus: String
    let accountTypeDescription: String?
    let planName: String?
    let currency: String
    let productName: String?
    let planCode: String
    let planAllowCreditDomestic, planAllowCreditInHouse: String?
    let cardNumber: String
    let accountBranch: String
    let categoryProduct: String?
    let balance: String
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
    case loan = "LOAN"
    case saving = "SAVING"
}

enum PlanAllow: String, Codable {
    case empty = ""
    case y = "Y"
}

typealias SavingAccountModel = [SavingAccountModelElement]
