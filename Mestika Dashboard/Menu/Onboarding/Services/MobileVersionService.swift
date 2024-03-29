//
//  MobileVersionService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/11/20.
//

import Foundation
import Security
import CommonCrypto

class MobileVersionService: NSObject {
    
    static let shared = MobileVersionService()
    var defaults = UserDefaults.standard
    
    static let publicKeyHash = "Gdbmf0GLeR880mGN9WSW1XOL6v7xsVmWO6ks0LxybzU="
    
    let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    private var isCertificatePinning: Bool = false
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(keyWithHeader.count), &hash)
        }
        
        
        return Data(hash).base64EncodedString()
    }
    
    /* GET MOBILE VERSION */
    func getVersion(isCertificatePinning: Bool, completion: @escaping(Result<MobileVersionResponse, ErrorResult>) -> Void) {
        
        self.isCertificatePinning = isCertificatePinning
    
        guard let url = URL.urlMobileVersion() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("osType", value: "ios")
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            
            guard let data = data, error == nil else {
                print("Failed Pinning")
                return completion(Result.failure(ErrorResult.customWithStatus(code: 600, codeStatus: "Failed Pinning")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("VALUE VERSION")
                print("\(httpResponse.statusCode)")
                
                if isCertificatePinning {
                    
                    print("Certificate pinning is successfully completed")
                    if (httpResponse.statusCode == 200) {
                        let versionResponse = try? JSONDecoder().decode(MobileVersionResponse.self, from: BlowfishEncode().decrypted(data: data)!)
                        completion(.success(versionResponse!))
                    }
                    
                    if (httpResponse.statusCode > 200) {
                        completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                    }
                    
                } else {
                    print("Certificate pinning not completed")
                    return completion(Result.failure(ErrorResult.customWithStatus(code: 700, codeStatus: "Certificate pinning not completed")))
                }
            }
        }.resume()
    }
}

extension MobileVersionService: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return
        }
        
        if self.isCertificatePinning {
            
            
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
            // SSL Policies for domain name check
            let policy = NSMutableArray()
            policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
            
            //evaluate server certifiacte
            let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
            
            //Local and Remote certificate Data
            let remoteCertificateData:NSData =  SecCertificateCopyData(certificate!)
            //let LocalCertificate = Bundle.main.path(forResource: "github.com", ofType: "cer")
            let pathToCertificate = Bundle.main.path(forResource: "mestika", ofType: "cer")
            let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
            
            //Compare certificates
            if(isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
                let credential:URLCredential =  URLCredential(trust:serverTrust)
                print("Certificate pinning is successfully completed")
                completionHandler(.useCredential,credential)
            }
            else{
                completionHandler(.cancelAuthenticationChallenge,nil)
            }
        } else {
            if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                // Server public key
                let serverPublicKey = SecCertificateCopyKey(serverCertificate)
                let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey!, nil )!
                let data:Data = serverPublicKeyData as Data
                // Server Hash key
                let serverHashKey = sha256(data: data)
                // Local Hash Key
                let publickKeyLocal = type(of: self).publicKeyHash
                if (serverHashKey == publickKeyLocal) {
                    // Success! This is our server
                    print("Public key pinning is successfully completed")
                    completionHandler(.useCredential, URLCredential(trust:serverTrust))
                    return
                }
            }
        }
    }
}
