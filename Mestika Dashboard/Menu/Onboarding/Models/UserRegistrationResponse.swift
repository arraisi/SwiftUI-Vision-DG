// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userRegistrationResponse = try? newJSONDecoder().decode(UserRegistrationResponse.self, from: jsonData)

import Foundation

// MARK: - UserRegistrationResponse
struct UserRegistrationResponse: Codable {
    let deviceID: String
    let password, pin: String?
    let userStatus: String
    let videoCall, status, products: String?
    let userDetails: UserDetails

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case password, pin, userStatus, videoCall, status, products, userDetails
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let firstName, lastName, productName: String
    let phone, email: String?
    let nik, addressDukcapil, addressPropinsiDukcapil, addressKecamatanDukcapil: String
    let addressKabupatenDukcapil, addressKelurahanDukcapil, addressPostalCodeDukcapil, addressRtRwDukcapil: String
    let companyAddress, companyKecamatan, companyKelurahan, companyPostalCode: String
    let companyBusinessField, companyName: String
    let companyPhoneNumber: String?
    let relativeRelationship, relativesName, relativesAddress, relativesPostalCode: String
    let relativesKelurahan, relativesKecamatan, relativesPhoneNumber, addressInput: String
    let addressRtRwInput, addressKelurahanInput, addressKecamatanInput, addressPostalCodeInput: String
    let imageKtp, imageSelfie: String
    let hasNoNpwp: Bool
    let imageNpwp, annualGrossIncome, emailAddress: String
    let hasOtherSourceOfIncome: Bool
    let isAddressEqualToDukcapil: String
    let isAgreeTNC, isAgreetoShare, isWni: Bool
    let mobileNumber, monthlyDepositAmount, monthlyDepositFrequency, monthlyWithdrawalAmount: String
    let monthlyWithdrawalFrequency, noNpwp, occupation, otherSourceOfIncome: String
    let password, pin, position, purposeOfAccountOpening: String
    let sourceOfFund: String
    let businessField, industryName: String?
    let imageKtpByte, imageSelfieByte: String
    let imageNpwpByte: String?
    let fireBaseID: String
    let kodeBIDatiDuaKtp, kodeKepemilikanRumah, kodeBIDatiDua, pendidikan: String?
    let birthPlace, birthDate, motherName, funderName: String
    let funderOccupation, funderRelation, gender, nasabahName: String
    let religion, maritalStatus: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, productName, phone, email, nik, addressDukcapil, addressPropinsiDukcapil, addressKecamatanDukcapil, addressKabupatenDukcapil, addressKelurahanDukcapil, addressPostalCodeDukcapil, addressRtRwDukcapil, companyAddress, companyKecamatan, companyKelurahan, companyPostalCode, companyBusinessField, companyName, companyPhoneNumber, relativeRelationship, relativesName, relativesAddress, relativesPostalCode, relativesKelurahan, relativesKecamatan, relativesPhoneNumber, addressInput, addressRtRwInput, addressKelurahanInput, addressKecamatanInput, addressPostalCodeInput, imageKtp, imageSelfie, hasNoNpwp, imageNpwp, annualGrossIncome, emailAddress, hasOtherSourceOfIncome, isAddressEqualToDukcapil
        case isAgreeTNC = "isAgreeTnc"
        case isAgreetoShare, isWni, mobileNumber, monthlyDepositAmount, monthlyDepositFrequency, monthlyWithdrawalAmount, monthlyWithdrawalFrequency, noNpwp, occupation, otherSourceOfIncome, password, pin, position, purposeOfAccountOpening, sourceOfFund, businessField, industryName, imageKtpByte, imageSelfieByte, imageNpwpByte
        case fireBaseID = "fireBaseId"
        case kodeBIDatiDuaKtp, kodeKepemilikanRumah, kodeBIDatiDua, pendidikan, birthPlace, birthDate, motherName, funderName, funderOccupation, funderRelation, gender, nasabahName, religion, maritalStatus
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
