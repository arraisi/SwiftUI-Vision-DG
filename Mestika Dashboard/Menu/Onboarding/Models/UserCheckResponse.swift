//
//  UserCheckResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/11/20.
//

import Foundation

class UserCheckResponse: Decodable {
    let code: String?
    let message: String?
    let phoneNumber: String?
    let scheduledDate: String?
    let scheduledHours: String?
}
