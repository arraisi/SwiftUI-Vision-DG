// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let masterRegencyResponse = try? newJSONDecoder().decode(MasterRegencyResponse.self, from: jsonData)

import Foundation

// MARK: - MasterRegencyResponseElement
struct MasterRegencyResponseElement: Codable {
    let id, provinceID, name: String

    enum CodingKeys: String, CodingKey {
        case id
        case provinceID = "provinceId"
        case name
    }
}

typealias MasterRegencyResponse = [MasterRegencyResponseElement]
