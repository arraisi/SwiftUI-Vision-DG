//
//  TransferOnUsResponse.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 03/02/21.
//

import Foundation

// MARK: response transfer
struct TransferOnUsResponse: Codable {
    let status: StatusTrx
    let ref, destinationNumber, cardNo, transactionDate: String
    let sourceNumber, currency, berita, nominal: String
    let nominalstr, traceNumber: String
    
    enum CodingKeys: String, CodingKey {
        case status, ref, destinationNumber, cardNo, transactionDate
        case sourceNumber, currency, berita, nominal
        case nominalstr, traceNumber
    }
}

// MARK: - Status
struct StatusTrx: Codable {
    let status, message, code: String
}
