// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let masterVilageResponse = try? newJSONDecoder().decode(MasterVilageResponse.self, from: jsonData)

import Foundation

// MARK: - MasterVilageResponseElement
struct MasterVilageResponseElement: Codable {
    let id, districtID, name: String
    let postalCode: String?

    enum CodingKeys: String, CodingKey {
        case id
        case districtID = "districtId"
        case name, postalCode
    }
}

typealias MasterVilageResponse = [MasterVilageResponseElement]
