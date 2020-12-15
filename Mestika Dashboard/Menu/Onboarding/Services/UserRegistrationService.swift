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
        registerData: RegistrasiModel,
        imageKtp: UIImage,
        imageNpwp: UIImage,
        imageSelfie: UIImage,
        completion: @escaping(Result<UserCheckResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlUserNew() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        print("DEVICE ID \(deviceId)")
        print(registerData.tujuanPembukaan)
        
        let userDetailParam: [String : Any] = [
            "mobileNumber": registerData.noTelepon,
            "productName": "Bank Mestika Product",
            "imageKtp": "",
            "nik": registerData.nik,
            "imageSelfie": "",
            "imageNpwp": "",
            "noNpwp": registerData.npwp,
            "emailAddress": registerData.email,
            "purposeOfAccountOpening": registerData.tujuanPembukaan,
            "sourceOfFund": registerData.sumberDana,
            "monthlyWithdrawalFrequency": registerData.perkiraanPenarikan,
            "monthlyWithdrawalAmount": registerData.besarPerkiraanPenarikan,
            "monthlyDepositFrequency": registerData.perkiraanSetoran,
            "monthlyDepositAmount": registerData.besarPerkiraanSetoran,
            "occupation": registerData.pekerjaan,
            "position": registerData.jabatanProfesi,
            "companyName": registerData.namaPerusahaan,
            "companyAddress": registerData.alamatPerusahaan,
            "companyKecamatan": registerData.kecamatan,
            "companyKelurahan": registerData.kecamatan,
            "companyPostalCode": registerData.kodePos,
            "companyBusinessField": registerData.alamatPerusahaan,
            "annualGrossIncome": registerData.penghasilanKotor,
            "hasOtherSourceOfIncome": false,
            "otherSourceOfIncome": "Tidak",
            "relativeRelationship": registerData.hubunganKekerabatan,
            "relativesName": registerData.namaKeluarga,
            "relativesAddress": registerData.alamatKeluarga,
            "relativesPostalCode": registerData.kodePosKeluarga,
            "relativesKelurahan": registerData.kelurahanKeluarga,
            "relativesKecamatan": registerData.kecamatanKeluarga,
            "relativesPhoneNumber": registerData.noTelepon,
            "funderName": "TEST",
            "funderRelation": "TEMAN",
            "funderOccupation": "TESTER",
            "password": registerData.password,
            "pin": registerData.pin,
            "isWni": true,
            "isAgreeTnc": true,
            "isAgreetoShare": true,
            "isAddressEqualToDukcapil": "Ya, alamat sesuai",
            "addressInput": "Komp. Jakapurwa",
            "addressRtRwInput": "02/05",
            "addressKelurahanInput": "Bandung Kidul",
            "addressKecamatanInput": "Kujangsari",
            "addressPostalCodeInput": "40287",
            "hasNoNpwp": false,
            "fireBaseId": "1",
            "nasabahName": registerData.namaLengkapFromNik,
            "addressDukcapil": registerData.alamatKtpFromNik,
            "addressRtRwDukcapil": "\(registerData.rtFromNik)/\(registerData.rwFromNik)",
            "addressKelurahanDukcapil": registerData.kelurahanFromNik,
            "addressKecamatanDukcapil": registerData.kecamatanFromNik,
            "addressPostalCodeDukcapil": "12345",
            "addressKabupatenDukcapil": registerData.kabupatenKotaFromNik,
            "addressPropinsiDukcapil": registerData.provinsiFromNik
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userDetailParam, options: .prettyPrinted)
            
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            
            // generate boundary string using a unique per-app string
            let boundary = UUID().uuidString
            
            var request = URLRequest(url)
            request.httpMethod = "POST"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
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
                    } else if (httpResponse.statusCode == 200) {
                        let userResponse = try? JSONDecoder().decode(UserCheckResponse.self, from: data!)
                        completion(.success(userResponse!))
                    } else {
                        completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
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
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
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
