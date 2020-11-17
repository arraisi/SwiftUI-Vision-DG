//
//  ErrorResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 13/11/20.
//

import Foundation

// MARK: - ErrorModel
class ErrorResponse: Decodable {
    let error: String
    let status: String
}
