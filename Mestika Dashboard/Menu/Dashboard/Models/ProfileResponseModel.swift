// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profileModel = try? newJSONDecoder().decode(ProfileModel.self, from: jsonData)

import Foundation

// MARK: - ProfileModel
import Foundation

// MARK: - ProfileResponseModel
struct ProfileResponseModel: Codable {
    let id: String
    let personal: Personal
    let status: String
    let products: [Product]
    let chipProfileDto: [ChipProfileDto]
    let profileResponseModelID: ID

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case personal, status, products, chipProfileDto
        case profileResponseModelID = "id"
    }
}

// MARK: - ChipProfileDto
struct ChipProfileDto: Codable {
    let maxIbftPerTrans, limitOnUs, limitWd, limitPayment: String
    let limitPurchase, limitIbft, cardFlag: String?
    let provinsi, kabupatenKota, kecamatan, kelurahan: String?
    let rw, rt, postalAddress, accountNumber: String?
    let nameOnCard, cardNo: String?
    let cardDesign: String?
    let classCode, nik, id, imageNameAlias: String?
    let balance, status: String?
    let mainCard: String?
    let kodepos: String?
}

// MARK: - Personal
struct Personal: Codable {
    let propName, noProp, kabName, noKab: String?
    let kecName, noKec, kelName, noKel: String?
    let rw, rt, address, marital: String?
    let gender, dateOfBirth, placeOfBirth, name: String?
    let namaIbuKandung: String?
}

// MARK: - Product
struct Product: Codable {
    let planCode: String
    let accountNo: String?
    let productName: String
}

// MARK: - ID
struct ID: Codable {
    let deviceID, firebaseID, telepon, surel: String
    let nik, cif: String

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case firebaseID = "firebaseId"
        case telepon, surel, nik, cif
    }
}
