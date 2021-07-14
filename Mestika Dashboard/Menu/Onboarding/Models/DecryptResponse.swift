//
//  DecryptResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 12/07/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let decryptResponse = try? newJSONDecoder().decode(DecryptResponse.self, from: jsonData)

import Foundation

// MARK: - DecryptResponse
struct DecryptResponse: Codable {
    let data: String
}
