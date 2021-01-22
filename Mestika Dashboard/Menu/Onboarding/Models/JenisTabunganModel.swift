// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let jenisTabunganModel = try? newJSONDecoder().decode(JenisTabunganModel.self, from: jsonData)

import Foundation

// MARK: - JenisTabunganModel
struct JenisTabunganModel: Codable {
    let content: [ContentJenisTabungan]
}

// MARK: - Content
struct ContentJenisTabungan: Codable {
    let id, name: String
    let image: String
    let contentDescription, type, codePlan: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case contentDescription = "description"
        case type, codePlan
    }
}
