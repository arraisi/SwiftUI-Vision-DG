// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let passwordParamResponse = try? newJSONDecoder().decode(PasswordParamResponse.self, from: jsonData)

import Foundation

// MARK: - PasswordParamResponse
struct PasswordParamResponse: Codable {
    let id: String
    let minimumPasswordLength, maximumPasswordLength, minimumUpperCaseLetterInPassword, minimumLowerCaseLetterInPassword: Int
    let minimumNumericInPassword, maximumPasswordHistory, maximumIncorrectPassword, maximumUserIdleTimeOut: Int
    let symbolRequired, enabled: Bool
}
