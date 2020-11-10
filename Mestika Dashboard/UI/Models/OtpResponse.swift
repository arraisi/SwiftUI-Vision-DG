//
//  OtpResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation

struct OtpResponse: Codable {
    var destination: String
    var reference: String
    var code: String
    var timeCounter: Int
    var createDate: Int
    var status: String
}
