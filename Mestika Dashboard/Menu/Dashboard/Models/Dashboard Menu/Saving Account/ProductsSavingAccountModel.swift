//
//  ProductsSavingAccountModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation

// MARK: - ProductsSavingAccountModel
struct ProductsSavingAccountModel: Codable {
    let content: [ProductSavingAccountModel]
}

// MARK: - Content
struct ProductSavingAccountModel: Codable, Identifiable {
    let id, name: String
    let image: String
    let contentDescription, type, codePlan: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case contentDescription = "description"
        case type, codePlan
    }
}
