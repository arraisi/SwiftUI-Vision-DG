//
//  UserRegistrationService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 14/11/20.
//

import Foundation
import SwiftUI
import Combine

class UserRegistrationService {
    
    private init() {}
    
    static let shared = UserRegistrationService()

    /* POST USER */
    func postUser(
        imageKtp: UIImage,
        imageNpwp: UIImage,
        imageSelfie: UIImage,
        completion: @escaping(Result<UserRegistrationResponse, ErrorResult>) -> Void) {

        guard let url = URL.urlUserNew() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }

        let userDetailParam: [String : Any] = [
            "firstName": "Prima",
            "lastName": "Jatnika",
            "productName": "Produk Tabungan 1",
            "mobileNumber": "085875074351",
            "emailAddress": "primajatnika271995@tabeldata.com",
            "nik": "1234123412341234",
            "imageKtp": "String",
            "imageSelfie": "String",
            "hasNoNpwp": true,
            "hasOtherSourceOfIncome": false,
            "imageNpwp": "String",
            "purposeOfAccountOpening": "Pinjaman / Angsuran Kredit",
            "sourceOfFund": "Gaji",
            "monthlyWithdrawalFrequency": "10 - 25 Kali",
            "monthlyWithdrawalAmount": "30 Juta",
            "monthlyDepositFrequency": "0 – 10 Kali",
            "monthlyDepositAmount": "30 Juta",
            "occupation": "Polisi",
            "companyName": "Tabeldata Informatika",
            "companyAddress": "Jl. Cicalengka Raya No 11",
            "companyKecamatan": "Bandung Kidul",
            "companyKelurahan": "Antapani",
            "companyPostalCode": "14085",
            "companyPhoneNumber": "022-898129389",
            "companyBusinessField": "Minimarket/ Jasa Parkir/ SPBU",
            "annualGrossIncome": "Rp 10 Juta - Rp 20 Juta",
            "otherSourceOfIncome": "Tidak",
            "relativeRelationship": "Ayah",
            "relativesName": "Setiadi",
            "password": "123abc",
            "pin": "147852",
            "relativesAddress": "Komp. Jakapurwa",
            "relativesKecamatan": "Kujangsari",
            "relativesPostalCode": "64656",
            "relativesKelurahan": "Antapani",
            "relativesPhoneNumber": "088218115997",
            "isWni": true,
            "isAgreeTnc": true,
            "noNpwp": "",
            "isAgreetoShare": true,
            "isAddressEqualToDukcapil": "Ya, alamat sesuai"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userDetailParam, options: .prettyPrinted)
            
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            
            // generate boundary string using a unique per-app string
            let boundary = UUID().uuidString

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue("*/*", forHTTPHeaderField: "accept")
            request.addValue("120", forHTTPHeaderField: "X-Device-ID")
            
            var data = Data()
            
            // Add the image KTP
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image_ktp\"; filename=\"\(imageKtp)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(imageKtp.pngData()!)
            
            // Add the image NPWP
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image_npwp\"; filename=\"\(imageNpwp)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(imageNpwp.pngData()!)
            
            // Add the image SELFIE
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image_selfie\"; filename=\"\(imageSelfie)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(imageSelfie.pngData()!)
            
            //
            // Add the User Details
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"userDetails\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(jsonString!)".data(using: .utf8)!)
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)


            URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                
                if error == nil {
                    let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let json = jsonData as? [String: Any] {
                        print(json)
                    }
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("\(httpResponse.statusCode)")
                    
                    if (httpResponse.statusCode == 500) {
                        completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                    }
                    
                    if (httpResponse.statusCode == 201) {
                        let userResponse = try? JSONDecoder().decode(UserRegistrationResponse.self, from: data!)
                        completion(.success(userResponse!))
                    }
                }

            }.resume()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* GET USER */
    func getUser(deviceId: String, completion: @escaping(Result<UserCheckResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlUser() else {
            return completion(.failure(.badUrl))
        }
        
        print("DEVICE ID HEADER : \(deviceId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        request.addValue(deviceId, forHTTPHeaderField: "X-Device-ID")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let userResponse = try? JSONDecoder().decode(UserCheckResponse.self, from: data)
            
            if userResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(userResponse!))
            }
            
        }.resume()
        
    }
    
}
