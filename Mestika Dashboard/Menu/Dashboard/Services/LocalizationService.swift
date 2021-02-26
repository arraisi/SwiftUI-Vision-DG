//
//  LocalisationService.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 26/02/21.
//

import Foundation

class LocalizationService {

    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name("changedLanguage")

    private init() {}
    
    var language: Language {
        get {
            guard let languageString = UserDefaults.standard.string(forKey: "language") else {
                return .english_us
            }
            return Language(rawValue: languageString) ?? .english_us
        } set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }
}

enum Language: String {

    case indonesia = "id"
    case english_us = "en"
    
    var userSymbol: String {
        switch self {
        case .english_us:
            return "us"
        default:
            return rawValue
        }
    }
}
