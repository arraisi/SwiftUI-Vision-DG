//
//  TransferOnUsResponse.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 03/02/21.
//

import Foundation
// MARK: response transfer
class TransferOnUsResponse: Decodable {
    var status: TransferResponseStatus
    var ref: String
    var destinationNumber: String
    var cardNo: String
    var transactionDate: String
    var sourceNumber: String
    var currency: String
    var berita: String
    var nominal: String
    var nominalstr: String
}

struct TransferResponseStatus: Decodable {
    var status: String?
    var message: String?
    var code: String?
}
