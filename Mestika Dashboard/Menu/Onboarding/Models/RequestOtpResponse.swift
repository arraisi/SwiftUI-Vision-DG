//
//  RequestOtpResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/05/21.
//

import Foundation

// MARK: - RequestOtpResponse
struct RequestOtpResponse: Codable {
    let phoneNumber, type: String
    let subType: String?
    let appCode, deviceID, fireBaseID: String
    let emailAddress: String?
    let reference: String
    let correlation: String?
    let destination: String
    let timeCounter: Int

    enum CodingKeys: String, CodingKey {
        case phoneNumber, type, subType, appCode
        case deviceID = "deviceId"
        case fireBaseID = "fireBaseId"
        case emailAddress, reference, correlation, destination, timeCounter
    }
}
