//
//  EStatementModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 08/06/21.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eStatementModel = try? newJSONDecoder().decode(EStatementModel.self, from: jsonData)

import Foundation

// MARK: - EStatementModel
struct EStatementModel: Codable {
    var data: [EStatementModelElement]?
}

// MARK: - Datum
struct EStatementModelElement: Codable {
    var fileName, periode, email, accountNumber: String?
    var id: String?
}
