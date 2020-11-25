//
//  GeneralResponse.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 25/11/20.
//

import Foundation

class GeneralResponse: Decodable {
    let status: Bool
    let code: String
    let message: String
}
