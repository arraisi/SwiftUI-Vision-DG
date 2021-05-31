//
//  UserRegistrationService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 14/11/20.
//

import Foundation
import SwiftUI
import Combine
import Firebase

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
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        let token = Messaging.messaging().fcmToken
        let indexEnd = token!.index(of: ":")
        let firebaseId = String(token![..<indexEnd!])
        
        print("DEVICE ID \(String(describing: deviceId))")
        print(registerData.tujuanPembukaan)
        print(registerData.hasNoNpwp)
        
        var userDetailParam: [String : Any] = [
            "atmNumberReferral": registerData.atmNumberReferral,
            "mobileNumber": registerData.noTelepon,
            "codePlan": registerData.planCodeTabungan,
            "productName": registerData.jenisTabungan,
            "imageKtp": "/storage/20201211_090631_.jpg",
            "nik": registerData.nik,
            "imageSelfie": "/storage/20201211_090631_.jpg",
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
            "companyKabupaten": registerData.kotaPerusahaan,
            "companyProvinsi": registerData.provinsiPerusahaan,
            "companyKecamatan": registerData.kecamatan,
            "companyKelurahan": registerData.kelurahan,
            "companyPostalCode": registerData.kodePos,
//            "companyPhoneNumber": registerData.noTeleponPerusahaan,
            "companyBusinessField": registerData.alamatPerusahaan,
            "annualGrossIncome": registerData.penghasilanKotor,
            "hasOtherSourceOfIncome": registerData.hasSumberPendapatanLainnya,
            "otherSourceOfIncome": registerData.sumberPendapatanLainnya,
//            "relativeRelationship": registerData.hubunganKekerabatan,
//            "relativesName": registerData.namaKeluarga,
//            "relativesAddress": registerData.alamatKeluarga,
//            "relativesPostalCode": registerData.kodePosKeluarga,
//            "relativesKelurahan": registerData.kelurahanKeluarga,
//            "relativesKecamatan": registerData.kecamatanKeluarga,
//            "relativesPhoneNumber": registerData.noTelepon,
            "funderName": registerData.namaPenyandangDana,
            "funderRelation": registerData.hubunganPenyandangDana,
            "funderOccupation": registerData.profesiPenyandangDana,
            "password": registerData.password,
            "pin": registerData.pin,
            "isWni": registerData.isWni,
            "isAgreeTnc": registerData.isAgree,
            "isAgreetoShare": registerData.isShareData,
            "isAddressEqualToDukcapil": registerData.isAddressEqualToDukcapil,
            "addressInput": registerData.addressInput ,
//            "addressRtRwInput": registerData.addressRtRwInput ?? "",
            "addressKelurahanInput": registerData.addressKelurahanInput,
            "addressKecamatanInput": registerData.addressKecamatanInput,
            "addressKabupatenInput": registerData.addressKotaInput,
            "addressProvinsiInput": registerData.addressProvinsiInput,
            "addressPostalCodeInput": registerData.addressPostalCodeInput,
            "hasNoNpwp": registerData.npwp != "" ? true : false,
            "fireBaseId": firebaseId,
            "nasabahName": registerData.namaLengkapFromNik,
            "addressDukcapil": registerData.alamatKtpFromNik,
            "addressRtRwDukcapil": "\(registerData.rtFromNik)/\(registerData.rwFromNik)",
            "addressKelurahanDukcapil": registerData.kelurahanFromNik,
            "addressKecamatanDukcapil": registerData.kecamatanFromNik,
            "addressPostalCodeDukcapil": registerData.kodePosFromNik,
            "addressKabupatenDukcapil": registerData.kabupatenKotaFromNik,
            "addressPropinsiDukcapil": registerData.provinsiFromNik
        ]
        
        if registerData.npwp != "" {
            userDetailParam["imageNpwp"] = "/storage/20201211_090631_.jpg"
        }
        
        let monthlyWithdrawalFrequency = userDetailParam["monthlyWithdrawalFrequency"]
        let monthlyWithdrawalAmount = userDetailParam["monthlyWithdrawalAmount"]
        
        print("monthlyWithdrawalFrequency +> \(monthlyWithdrawalFrequency ?? "no content")")
        print("monthlyWithdrawalAmount +> \(monthlyWithdrawalAmount ?? "no content")")
        
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
            data.append("Content-Disposition: form-data; name=\"image_ktp\"; filename=\"\(deviceId ?? "")_ktp.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(imageKtp.pngData()!)
            
            if registerData.npwp != "" {
                // Add the image NPWP
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"image_npwp\"; filename=\"\(deviceId ?? "")_npwp.jpg\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                data.append(imageNpwp.pngData()!)
            }
            
            // Add the image SELFIE
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image_selfie\"; filename=\"\(deviceId ?? "")_selfie.jpg\"\r\n".data(using: .utf8)!)
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
    
    // MARK:- API SUBMIT USER SCHEDULE
    func cancelRequest(nik: String, completion: @escaping(Result<UserCheckResponse?, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "nik":  nik
        ]
        
        print("body => \(body)")
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlUser() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url
            .appending("type", value: "cancelRequest")
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("response: \(String(describing: response))")
            
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
    }
}
