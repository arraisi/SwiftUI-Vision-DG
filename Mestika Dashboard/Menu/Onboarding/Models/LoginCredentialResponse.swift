// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginCredentialModel = try? newJSONDecoder().decode(LoginCredentialModel.self, from: jsonData)

import Foundation

// MARK: - LoginCredentialModel
struct LoginCredentialResponse: Codable {
    let deviceID: String
    let fingerprintFlag: Bool
    let id, nik, password, phoneNumber: String
    let pinTransaction, status: String

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case fingerprintFlag, id, nik, password, phoneNumber, pinTransaction, status
    }
}
