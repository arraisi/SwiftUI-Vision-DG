//
//  OtpResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation

// MARK: - OtpResponse
struct OtpResponse: Decodable {
    let destination, reference, code: String?
    let timeCounter: Int?
    let tryCount: Int?
    let status: Status?
    let nik: String?
}

// MARK: - Status
struct Status: Codable {
    let code, message: String?
}
