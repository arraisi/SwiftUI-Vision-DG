//
//  RequestOtpUserResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 15/06/21.
//

import Foundation

// MARK: - RequestOtpUserResponse
struct RequestOtpUserResponse: Codable {
    let destination: String?
    let reference: String
    let code: String?
    let timeCounter: Int
    let createdDate, tryCount, status: String?
}
