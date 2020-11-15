//
// Created by Prima Jatnika on 14/11/20.
//

import Foundation

// MARK: - UserRegistrationResponse
struct UserRegistrationResponse: Codable {
    var deviceID: String
    var password, pin: JSONNull?
    var userStatus: String
    var videoCall, status: JSONNull?
    var userDetails: UserDetails

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case password, pin, userStatus, videoCall, status, userDetails
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    var firstName, lastName, productName, phone: String
    var email, nik: String
    var imageKtp, imageSelfie: JSONNull?
    var hasNoNpwp: Bool
    var imageNpwp: JSONNull?
    var purposeOfAccountOpening, sourcOfFunds, monthlyWithdrawalFrequency, monthlyWithdrawalAmount: String
    var monthlyDepositFrequency, monthlyDepositAmount, occupation, position: String
    var companyName, companyAddress, companyKecamatan, companyKelurahan: String
    var companyPostalCode, companyPhoneNumber, companyBusinessField, annualGrossIncome: String
    var hasOtherSourceOfIncome, otherSourceOfIncome, relativeRelationship: String
    var relativesName: Bool
    var relativesAddress, relativesPostalCode, relativesKelurahan, relativesPhoneNumber: String
    var funderName, funderRelation, funderOccupation: String
    var isWni, isAgreeTNC, isAgreetoShare, isAddressEqualToDukcapil: Bool
    var correspondenceAddress, correspondenceRt, correspondenceRw, correspondenceKelurahan: String
    var correspondenceKecamatan, correspondencePostalCode: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, productName, phone, email, nik, imageKtp, imageSelfie, hasNoNpwp, imageNpwp, purposeOfAccountOpening, sourcOfFunds, monthlyWithdrawalFrequency, monthlyWithdrawalAmount, monthlyDepositFrequency, monthlyDepositAmount, occupation, position, companyName, companyAddress, companyKecamatan, companyKelurahan, companyPostalCode, companyPhoneNumber, companyBusinessField, annualGrossIncome, hasOtherSourceOfIncome, otherSourceOfIncome, relativeRelationship, relativesName, relativesAddress, relativesPostalCode, relativesKelurahan, relativesPhoneNumber, funderName, funderRelation, funderOccupation, isWni
        case isAgreeTNC = "isAgreeTnc"
        case isAgreetoShare, isAddressEqualToDukcapil, correspondenceAddress, correspondenceRt, correspondenceRw, correspondenceKelurahan, correspondenceKecamatan, correspondencePostalCode
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