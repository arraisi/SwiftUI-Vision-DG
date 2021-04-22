//
//  BankReferenceModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/02/21.
//

import Foundation

// MARK: - BankReferenceResponseElement
struct BankReferenceResponseElement: Codable, Hashable {
    let code, name: String
}

typealias BankReferenceResponse = [BankReferenceResponseElement]

