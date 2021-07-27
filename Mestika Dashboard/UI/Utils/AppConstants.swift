//
//  AppConstants.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/12/20.
//

import Foundation

class AppConstants {
    
    
    #if DEBUG
    var BASE_URL = "https://digital.bankmestika.co.id/api/v1.0"
    #elseif DEBUGQA
    var BASE_URL = "https://mysql.visiondg.xyz:8765/api/v1.0"
    #elseif DEBUGMESTIKA
    var BASE_URL = "https://digital.bankmestika.co.id/api/v1.0"
    #elseif Release
    var BASE_URL = "https://digital.bankmestika.co.id/api/v1.0"
    #else
    var BASE_URL = "https://digital.bankmestika.co.id/api/v1.0"
    #endif
    
//    var JITSI_URL = "https://meet.visiondg.xyz/"
    var JITSI_URL = "https://meet.bankmestika.co.id/"
    
    #if DEBUG
    var WEBSOCKET_URL = "ws://eagle-dev.apps.visiondg.bankmestika.co.id/websocketnotification"
    #elseif Release
    var WEBSOCKET_URL = "ws://eagle-dev.apps.visiondg.bankmestika.co.id/websocketnotification"
    #else
    var WEBSOCKET_URL = "ws://eagle-dev.apps.visiondg.bankmestika.co.id/websocketnotification"
    #endif
    
    var PUBLIC_KEY_RSA = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7l8gErdf9mYzocGvR0uiNUjQrx9hf8lbIAsFlL0fZXEgZ8Ba+ZXMhbXW4rTgnFZx8Bo6wIXIFoNjqn5eFGjLvtKn5LX+Ul9k4j85pgsW40n29HNG3MAf4gSd+gtRD5a/OxzF9GCmipOAPRFiitazLzAwme9A9J2i/SyIO+VlTVQIDAQAB"
    
    var PRIVATE_KEY_RSA = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALuXyASt1/2ZjOhwa9HS6I1SNCvH2F/yVsgCwWUvR9lcSBnwFr5lcyFtdbitOCcVnHwGjrAhcgWg2Oqfl4UaMu+0qfktf5SX2TiPzmmCxbjSfb0c0bcwB/iBJ36C1EPlr87HMX0YKaKk4A9EWKK1rMvMDCZ70D0naL9LIg75WVNVAgMBAAECgYBeoX6A/cFLaL4wMyXwvtgZEjLHMxTvsawdUWaFyIgSGf81NmwCt+KQJkuQUbFV5gz+c8BfEUAXnsBN+xvQRRsT+wyJtgaCnaFgs4m8huIo5IGYWqwwlns4pfKUQC1L725YFSPbaGu1lYRbe1oo+qSJwGdmb0gs4/rD5tp2Wau8MQJBAOq/Hjh8+rrlJi+MDFWDdJTeiZaZe92JFI3Tj1v3aJ6+wVqwatlvI26Zbc750wWbKfs5u9/90ql+kVjJ1w0y8qsCQQDMk8AlDJHW+bjSuF/V9A8ZhJaD3IYCxSVrowZUebU8RNdBHC9L5jd3ffk1xJ7GDHTVjVKNVj1sasjN1sTSdNH/AkEA56QcECXTzOUeH0EVUrTbL6PBJWjjP6JrM+CV0Gx9Qlh9uB3p8hGnZxXjs5/2ScvpS0yXRdrULAkHKBRUL2Qc7QJBAI8cVPAWCPfQHeEbJb+wSdfaDskTvZO2gmT32HfD5GrS5Zogs11vISIwN+PLNh7pm9nAUR2aVMHBOdP1CB8JpdUCQFeDTB4teLcrdZ4CURj/JWTpfU2rKf/E5hk8fCgCkMKDXuPKtV/drih/5EVWCVTSbe/8YhrksirtV52jFlxBego="
    
    var KEY_ENCRYPT_DEVICE_ID = "D3v1ceId"
    
    var BYPASS_OTP: Bool = true
    var ENCRYPTED: Bool = true
}

struct defaultsKeys {
    static let keyToken = "tokenKey"
    static let keyXsrf = "xsrfKey"
    static let biometricCode = "biometricCode"
}
