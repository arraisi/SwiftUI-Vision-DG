//
//  KartuKuResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/02/21.
//

import Foundation

// MARK: - KartuKuResponseElement
struct KartuKuResponseElement: Codable {
    let maxIbftPerTrans, limitOnUs, limitWd, limitPayment: JSONNull?
    let limitPurchase, limitIbft: JSONNull?
    let cardFlag, kodepos, provinsi, kabupatenKota: String
    let kecamatan, kelurahan, rw, rt: String
    let postalAddress, accountNumber, nameOnCard, cardNo: String
    let cardDesign: String
    let classCode, nik, id, imageNameAlias: String
    let balance: JSONNull?
    let status, mainCard: String?
}

typealias KartuKuResponse = [KartuKuResponseElement]
