//
//  ProductDetailSavingAccountModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation

// MARK: - ProductDetailSavingAccountModel
struct ProductDetailSavingAccountModel: Codable {
    let id, kodePlan, kodeAplikasi, balType: String
    let namaPlan, currency, outgoing, continueFlag: String
    let minimumSaldo, biayaAdministrasi, minimumSetoranAwal, fieldRate1: String
    let fieldRate2, fieldRate3, fieldRate4, fieldRate5: String
    let fieldRate6, fieldRate7, fieldRate8, fieldRate9: String
    let fieldSaldo1, fieldSaldo2, fieldSaldo3, fieldSaldo4: String
    let fieldSaldo5, fieldSaldo6, fieldSaldo7, fieldSaldo8: String
    let fieldSaldo9, productName, productDescription: String
    let productImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, kodePlan, kodeAplikasi, balType, namaPlan, currency, outgoing, continueFlag, minimumSaldo, biayaAdministrasi, minimumSetoranAwal, fieldRate1, fieldRate2, fieldRate3, fieldRate4, fieldRate5, fieldRate6, fieldRate7, fieldRate8, fieldRate9, fieldSaldo1, fieldSaldo2, fieldSaldo3, fieldSaldo4, fieldSaldo5, fieldSaldo6, fieldSaldo7, fieldSaldo8, fieldSaldo9, productName, productDescription
        case productImageURL = "productImageUrl"
    }
}
