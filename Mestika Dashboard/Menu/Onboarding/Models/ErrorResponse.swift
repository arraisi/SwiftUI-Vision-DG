//
//  ErrorResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 13/11/20.
//

import Foundation

// MARK: - ErrorModel
class ErrorResponse {
    var error, status: String?

    enum CodingKeys: String, CodingKey {
        case error
        case status = "status"
    }
}
