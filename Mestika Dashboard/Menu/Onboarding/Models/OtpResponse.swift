//
//  OtpResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation

class OtpResponse: ErrorResponse, Decodable {
    var destination: String?
    var reference: String?
    var code: String?
    var timeCounter: Int?
    
    enum CodingKeys: String, CodingKey {
        case destination = "destination"
        case reference = "reference"
        case code = "code"
        case timeCounter = "timeCounter"
    }
}
