//
//  AppConstants.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/12/20.
//

import Foundation
class AppConstants {
    #if DEBUG
    var BASE_URL = "http://eagle.visiondg.xyz:8765/api/v1.0"
    #elseif DEBUGQA
    var BASE_URL = "http://eagle.visiondg.xyz:8765/api/v1.0"
    #elseif DEBUGMESTIKA
    var BASE_URL = "http://eagle-development.apps.visiondg.bankmestika.co.id/api/v1.0"
    #elseif Release
    var BASE_URL = "http://eagle-development.apps.visiondg.bankmestika.co.id/api/v1.0"
    #else
    var BASE_URL = "http://localhost:8765/api/v1.0"
    #endif
}
