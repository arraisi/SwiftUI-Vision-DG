//
//  InquiryOnUsResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/02/21.
//

import Foundation

// MARK: - InquiryTransferResponse
struct InquiryTransferResponse: Codable {
    let status: Status
    let statusOfAccount, ref, applicationCode, currency: String
    let nominal, nominalstr, destinationNumber, destinationAccountName: String
    let cardNo, transactionDate, sourceNumber, cif: String
}
