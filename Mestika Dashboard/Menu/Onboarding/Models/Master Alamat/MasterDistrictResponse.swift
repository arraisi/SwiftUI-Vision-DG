// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let masterDistrictResponse = try? newJSONDecoder().decode(MasterDistrictResponse.self, from: jsonData)

import Foundation

// MARK: - MasterDistrictResponseElement
struct MasterDistrictResponseElement: Codable {
    let id, regencyID, name: String

    enum CodingKeys: String, CodingKey {
        case id
        case regencyID = "regencyId"
        case name
    }
}

typealias MasterDistrictResponse = [MasterDistrictResponseElement]
