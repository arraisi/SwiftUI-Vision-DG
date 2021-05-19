//
//  TransactionLimitModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/05/21.
//

import Foundation

// MARK: - GlobalLimitModelElement
typealias GlobalLimitModel = [Limit]

// MARK: - UserLimitModel
struct UserLimitModel: Codable {
    let nik: String
    let pinTrx: String?
    let limits: [Limit]
}

// MARK: - Limit
struct Limit: Codable {
    let key: String
    let value: Double
}
