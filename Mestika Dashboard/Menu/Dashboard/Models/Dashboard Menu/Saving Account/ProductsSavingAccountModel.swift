//
//  ProductsSavingAccountModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation

// MARK: - ProductsSavingAccountModelElement
struct ProductsSavingAccountModelElement: Codable {
    let id, kodePlan, kodeAplikasi: String
    let balType: String?
    let namaPlan, currency: String
    let outgoing, continueFlag: String?
    let minimumSaldo, biayaAdministrasi, minimumSetoranAwal, minimumSetoranSelanjutnya: String
    let fieldRate1, fieldRate2, fieldRate3, fieldRate4: String
    let fieldRate5, fieldRate6, fieldRate7, fieldRate8: String
    let fieldRate9: String?
    let fieldSaldo1, fieldSaldo2, fieldSaldo3, fieldSaldo4: String
    let fieldSaldo5, fieldSaldo6, fieldSaldo7, fieldSaldo8: String
    let fieldSaldo9: String?
    let productName, productDescription: String
    let productImageURL: String
    let categoryProduct: String
    let enable: String?

    enum CodingKeys: String, CodingKey {
        case id, kodePlan, kodeAplikasi, balType, namaPlan, currency, outgoing, continueFlag, minimumSaldo, biayaAdministrasi, minimumSetoranAwal, minimumSetoranSelanjutnya, fieldRate1, fieldRate2, fieldRate3, fieldRate4, fieldRate5, fieldRate6, fieldRate7, fieldRate8, fieldRate9, fieldSaldo1, fieldSaldo2, fieldSaldo3, fieldSaldo4, fieldSaldo5, fieldSaldo6, fieldSaldo7, fieldSaldo8, fieldSaldo9, productName, productDescription
        case productImageURL = "productImageUrl"
        case categoryProduct, enable
    }
}

typealias ProductsSavingAccountModel = [ProductsSavingAccountModelElement]
