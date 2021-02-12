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
    var BASE_URL = "http://eagle-dev.apps.visiondg.bankmestika.co.id/api/v1.0"
    #elseif Release
    var BASE_URL = "http://eagle.visiondg.xyz:8765/api/v1.0"
    #else
    var BASE_URL = "http://eagle.visiondg.xyz:8765/api/v1.0"
    #endif
    
    var JITSI_URL = "https://jibri.visiondg.xyz/"
//    https://video.visiondg.xyz
    
    var PUBLIC_KEY_RSA = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7l8gErdf9mYzocGvR0uiNUjQrx9hf8lbIAsFlL0fZXEgZ8Ba+ZXMhbXW4rTgnFZx8Bo6wIXIFoNjqn5eFGjLvtKn5LX+Ul9k4j85pgsW40n29HNG3MAf4gSd+gtRD5a/OxzF9GCmipOAPRFiitazLzAwme9A9J2i/SyIO+VlTVQIDAQAB"
    
    var BYPASS_OTP: Bool = false
}
