// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginCredentialModel = try? newJSONDecoder().decode(LoginCredentialModel.self, from: jsonData)

import Foundation

// MARK: - LoginCredentialModel
struct LoginCredentialResponse: Codable {
    let code: String
    let message: String
}
