//
//  MobileVersionResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/11/20.
//

import Foundation

class MobileVersionResponse: Decodable {
    let versionNumber: String
    let versionCodeMajor: String
    let versionCodeMinor: String
    let versionCodePatch: String
    let versionName: String
}
