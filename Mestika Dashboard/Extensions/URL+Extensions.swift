//
//  URL+Extensions.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 20/10/20.
//

import Foundation

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}

extension URL {
    
    static func urlForSliderAssets() -> URL? {
        return URL(string: "https://my-json-server.typicode.com/primajatnika271995/dummy-json/assets-landing")
    }
    
    static func urlMobileVersion() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/version/mobile/find-by-osType")
    }
    
    static func urlUserNew() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/user/new")
    }
    
    static func urlUser() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/user")
    }
    
    static func urlOTP() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/otp")
    }
    
    static func urlPasswordValidation() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/password/validation")
    }
    
    static func urlCitizen() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/citizen/nik")
    }
    
    static func urlSheduleInterview() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/schedule")
    }
    
    static func urlSheduleInterviewFindById() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/schedule/find-byid")
    }
    
    static func urlSheduleInterviewSubmit() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/user?type=scheduleVC")
    }
    
    static func urlAddProductATM() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/user?type=addProduct");
    }
    
    static func urlGetListATM() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/content/content-find-atm");
    }
    
    static func urlGetListATMDesign(type: String) -> URL? {
        return URL(string: AppConstants().PROD_URL + "/content/content-find-atm-design?type=\(type)");
    }
    
    static func urlGetSuggestionAddress() -> URL? {
        return URL(string: AppConstants().PROD_URL + "/google-maps/address/geoloc-results")
    }
}
