// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userRegistrationResponse = try? newJSONDecoder().decode(UserRegistrationResponse.self, from: jsonData)

import Foundation

// MARK: - UserRegistrationResponse
struct UserRegistrationResponse: Codable {
    let deviceID: String
    let password, pin: JSONNull?
    let userStatus: String
    let videoCall, status, products: JSONNull?
    let userDetails: UserDetails

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case password, pin, userStatus, videoCall, status, products, userDetails
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let firstName, lastName, productName: String
    let phone, email: JSONNull?
    let nik, address: String
    let addressKecamatan, addressKelurahan, addressPostalCode, addressRtRw: JSONNull?
    let imageKtp, imageSelfie: String
    let hasNoNpwp: Bool
    let imageNpwp: JSONNull?
    let annualGrossIncome, companyAddress, companyBusinessField, companyKecamatan: String
    let companyKelurahan, companyName, companyPhoneNumber, companyPostalCode: String
    let emailAddress: String
    let hasOtherSourceOfIncome: Bool
    let isAddressEqualToDukcapil: String
    let isAgreeTNC, isAgreetoShare, isWni: Bool
    let mobileNumber, monthlyDepositAmount, monthlyDepositFrequency, monthlyWithdrawalAmount: String
    let monthlyWithdrawalFrequency, noNpwp, occupation, otherSourceOfIncome: String
    let password, pin: String
    let position: JSONNull?
    let purposeOfAccountOpening, relativeRelationship, relativesAddress, relativesKecamatan: String
    let relativesKelurahan, relativesName, relativesPhoneNumber, relativesPostalCode: String
    let sourceOfFund: String
    let businessField, industryName: JSONNull?
    let imageKtpByte, imageSelfieByte: String
    let imageNpwpByte, fireBaseID: JSONNull?
    let kodeBIDatiDuaKtp, kodeKepemilikanRumah, kodeBIDatiDua, pendidikan: String
    let birthPlace, birthDate, motherName: String
    let funderName, funderOccupation, funderRelation: JSONNull?
    let gender: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, productName, phone, email, nik, address, addressKecamatan, addressKelurahan, addressPostalCode, addressRtRw, imageKtp, imageSelfie, hasNoNpwp, imageNpwp, annualGrossIncome, companyAddress, companyBusinessField, companyKecamatan, companyKelurahan, companyName, companyPhoneNumber, companyPostalCode, emailAddress, hasOtherSourceOfIncome, isAddressEqualToDukcapil
        case isAgreeTNC = "isAgreeTnc"
        case isAgreetoShare, isWni, mobileNumber, monthlyDepositAmount, monthlyDepositFrequency, monthlyWithdrawalAmount, monthlyWithdrawalFrequency, noNpwp, occupation, otherSourceOfIncome, password, pin, position, purposeOfAccountOpening, relativeRelationship, relativesAddress, relativesKecamatan, relativesKelurahan, relativesName, relativesPhoneNumber, relativesPostalCode, sourceOfFund, businessField, industryName, imageKtpByte, imageSelfieByte, imageNpwpByte
        case fireBaseID = "fireBaseId"
        case kodeBIDatiDuaKtp, kodeKepemilikanRumah, kodeBIDatiDua, pendidikan, birthPlace, birthDate, motherName, funderName, funderOccupation, funderRelation, gender
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
