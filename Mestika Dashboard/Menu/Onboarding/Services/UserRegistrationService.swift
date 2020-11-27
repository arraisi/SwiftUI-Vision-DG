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
            "mobileNumber": "85875074351",
              "productName": "Bank Mestika Product",
              "imageKtp": "/storage/emulated/0/Android/data/com.multipolar.visiondg.mestika/files/Pictures/visiondgimage/20201114_142434_.jpg",
              "nik": "5106040309800927",
              "imageSelfie": "/storage/emulated/0/Android/data/com.multipolar.visiondg.mestika/files/Pictures/visiondgimage/20201114_142434_.jpg",
              "imageNpwp": "/storage/emulated/0/Android/data/com.multipolar.visiondg.mestika/files/Pictures/visiondgimage/20201114_142434_.jpg",
              "noNpwp": "",
              "emailAddress": "primajatnika@gmail.com",
              "purposeOfAccountOpening": "Pinjaman / Angsuran Kredit",
              "sourceOfFund": "Gaji",
              "monthlyWithdrawalFrequency": "10 - 25 Kali",
              "monthlyWithdrawalAmount": "30 Juta",
              "monthlyDepositFrequency": "0 – 10 Kali",
              "monthlyDepositAmount": "30 Juta",
              "occupation": "Polisi",
              "position": "Head",
              "companyName": "Tokopedia",
              "companyAddress": "Jakarta Raya",
              "companyKecamatan": "Jakarta",
              "companyKelurahan": "Jakarta",
              "companyPostalCode": "01921",
              "companyBusinessField": "Jakarta",
              "annualGrossIncome": "Rp 10 Juta - Rp 20 Juta",
              "hasOtherSourceOfIncome": false,
              "otherSourceOfIncome": "Tidak",
              "relativeRelationship": "Ayah",
              "relativesName": "Test",
              "relativesAddress": "Bandung",
              "relativesPostalCode": "40287",
              "relativesKelurahan": "Bandung Kidul",
              "relativesKecamatan": "Kujangsari",
              "relativesPhoneNumber": "88219901229",
              "funderName": "Test",
              "funderRelation": "Teman",
              "funderOccupation": "Kang Dawet",
              "password": "123abc",
              "pin": "271295",
              "isWni": false,
              "isAgreeTnc": false,
              "isAgreetoShare": false,
              "isAddressEqualToDukcapil": "Ya, alamat sesuai",
              "addressInput": "Komp. Jakapurwa",
              "addressRtRwInput": "02/05",
              "addressKelurahanInput": "Bandung Kidul",
              "addressKecamatanInput": "Kujangsari",
              "addressPostalCodeInput": "40287",
              "hasNoNpwp": false,
              "fireBaseId": "1",
              "nasabahName": "DATA TEST T 03",
              "addressDukcapil": "JL PROF DR LATUMETEN I GG.5/6",
              "addressRtRwDukcapil": "3/5",
              "addressKelurahanDukcapil": "JELAMBAR",
              "addressKecamatanDukcapil": "GROGOL PETAMBURAN",
              "addressPostalCodeDukcapil": "12345",
              "addressKabupatenDukcapil": "KOTA ADM. JAKARTA BARAT",
              "addressPropinsiDukcapil": "DKI JAKARTA"
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
                    
                    if (httpResponse.statusCode == 200) {
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
