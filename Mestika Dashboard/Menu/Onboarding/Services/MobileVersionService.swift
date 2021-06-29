//
//  MobileVersionService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/11/20.
//

import Foundation

class MobileVersionService {
    
    private init() {}
    
    static let shared = MobileVersionService()
    
    func decrypt(_ encryptData: String, _ privateKey: String) -> String? {
        
        print("ini encrypt")
        print(encryptData)
        
          guard let baseDecodeData = Data(base64Encoded: encryptData)
          else {
            print("kosong")
            return nil
          }
        let decryptedInfo = RSAUtils.decryptWithRSAPublicKey(baseDecodeData, pubkeyBase64: privateKey, keychainTag: "")
          if ( decryptedInfo != nil ) {
              let result = String(data: decryptedInfo!, encoding: .utf8)
              return result
          } else {
              print("Error while decrypting")
              return nil
          }
    }
    
    /* GET MOBILE VERSION */
    func getVersion(completion: @escaping(Result<MobileVersionResponse, NetworkError>) -> Void) {
    
        guard let url = URL.urlMobileVersion() else {
            return completion(.failure(.badUrl))
        }
        
        let paramsUrl = url.appending("osType", value: "ios")
        
        let preferences = UserDefaults.standard
        let token = "X-XSRF-TOKEN"
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data, error == nil else {
                print("RTO")
                return completion(.failure(.noData))
            }
            
            if let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "XSRF-TOKEN" }) {
                print("VALUE XSFR")
                print("\(cookie.value)")
                preferences.set(cookie.value, forKey: token)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("VALUE VERSION")
                print("\(httpResponse.statusCode)")
            }
            
//            print(String(data: data, encoding: .utf8))
//
//            let dataDec = self.decrypt((String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!, AppConstants().PUBLIC_KEY_RSA)
//
//            print(dataDec)
//
//            let jsonData = Data(dataDec!.utf8)
            let versionResponse = try? JSONDecoder().decode(MobileVersionResponse.self, from: data)
            
            if versionResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(versionResponse!))
            }
        }.resume()
    }
}
