//
//  NewSavingAccountResponse.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation

// MARK: - NewSavingAccountResponseModel
struct NewSavingAccountResponseModel: Codable {
    let status: Status
    let ref, currency, nominal, nominalstr: String
    let destinationNumber, cardNo, transactionDate, sourceNumber: String
}
