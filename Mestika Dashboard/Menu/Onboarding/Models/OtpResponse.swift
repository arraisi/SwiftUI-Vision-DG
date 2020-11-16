//
//  OtpResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation

class OtpResponse: Decodable {
    let destination: String
    let reference: String
    let code: String
    let timeCounter: Int
}
