//
//  TransactionLimitModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/05/21.
//

import Foundation

// MARK: - TransactionLimitModel
struct TransactionLimitModel: Codable {
    let limits: [Limit]
}

// MARK: - Limit
struct Limit: Codable {
    let key: String
    let value: Int
}
