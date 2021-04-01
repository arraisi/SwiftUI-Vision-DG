//
//  KartuKuModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/02/21.
//

import Foundation

struct KartuKuDesignViewModel {
    var maxIbftPerTrans, limitOnUs, limitWd, limitPayment: String?
    var limitPurchase, limitIbft: String?
    var cardFlag, kodepos, provinsi, kabupatenKota: String
    var kecamatan, kelurahan, rw, rt: String
    var postalAddress, accountNumber, nameOnCard, cardNo: String
    var cardDesign: URL?
    var classCode, nik, id, imageNameAlias: String
    var mainCard, status: String?
    var isShow: Bool = false
}
