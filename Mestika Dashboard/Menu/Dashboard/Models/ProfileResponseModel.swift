// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profileModel = try? newJSONDecoder().decode(ProfileModel.self, from: jsonData)

import Foundation

// MARK: - ProfileModel
struct ProfileResponseModel: Codable {
    let id: String
    let personal: Personal
    let status: String
    let products: [Product]
    let chipProfileDto: [ChipProfileDto]?
    let profileResponseModelID: ID

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case personal, status, products, chipProfileDto
        case profileResponseModelID = "id"
    }
}

// MARK: - ChipProfileDto
struct ChipProfileDto: Codable {
    let maxIbftPerTrans, limitOnUs, limitWd, limitPayment, limitPurchase, limitIbft: String?
    let cardFlag, kodepos, provinsi, kabupatenKota: String
    let kecamatan, kelurahan, rw, rt: String
    let postalAddress, accountNumber, nameOnCard: String
    let cardNo: String?
    let cardDesign, classCode, nik, id: String
    let imageNameAlias, balance: String
    let status: String?
    let mainCard: String
}

// MARK: - Personal
struct Personal: Codable {
    let propName, noProp, kabName, noKab: String
    let kecName, noKec, kelName, noKel: String
    let rw, rt, address, marital: String
    let gender, dateOfBirth, placeOfBirth, name: String
    let namaIbuKandung: String
}

// MARK: - Product
struct Product: Codable {
    let planCode: String
    let accountNo, productName: String?
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
