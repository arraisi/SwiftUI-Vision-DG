//
//  GeneralPaginationResponse.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 01/12/20.
//

import Foundation

struct GeneralPaginationResponse<T: Codable>: Decodable {
    let success: Bool
    let code: String
    let message: String
    let data: GeneralDataPagination<T>
}

struct GeneralDataPagination<T: Codable>: Decodable {
    let content: [T]
    let pageable: String
    let last: Bool
    let totalPages: Int
    let totalElements: Int
    let number: Int
    let size: Int
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}
