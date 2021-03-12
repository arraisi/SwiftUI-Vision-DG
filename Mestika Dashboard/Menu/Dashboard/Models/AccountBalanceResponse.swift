//
//  AccountBalanceResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/03/21.
//

import Foundation

// MARK: - AccountBalanceResponse
struct AccountBalanceResponse: Codable {
    let accountLegderBalance, balance, creditDebit, currencyCode: String
}
