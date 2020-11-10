//
//  URL+Extensions.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 20/10/20.
//

import Foundation

private var baseUrl = "http://159.65.2.90:8765"
extension URL {
    
    
    
    static func urlForSliderAssets() -> URL? {
         return URL(string: "https://my-json-server.typicode.com/primajatnika271995/dummy-json/assets-landing")
    }
    
    static func urlGetRequestOtp() -> URL? {
        return URL(string: baseUrl + "/api/v1.0/otp")
    }
}
