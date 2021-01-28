//
//  ScheduleInterviewService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/11/20.
//

import Foundation
import Firebase

class ScheduleInterviewService {
    
    private init() {}
    
    static let shared = ScheduleInterviewService()
    
    // MARK: - API GET SCHEDULE ALL
    func getSheduleInterviewAll(completion: @escaping(Result<[ScheduleInterviewResponse]?, NetworkError>) -> Void) {
        
        print("API SCHEDULE ALL")
        
        guard let url = URL.urlSheduleInterview() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let scheduleResponse = try? JSONDecoder().decode([ScheduleInterviewResponse].self, from: data)
            
            if scheduleResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(scheduleResponse!))
            }
            
        }.resume()
    }
    
    // MARK:- API GET SCHEDULE FIND BY ID
    func getSheduleInterviewFindById(idSchedule: Int, completion: @escaping(Result<ScheduleInterviewResponse?, NetworkError>) -> Void) {
        
        print("API SCHEDULE FIND BY ID")
        
        guard let url = URL.urlSheduleInterviewFindById() else {
            return completion(.failure(.badUrl))
        }
        
        let finalUrl = url.appending("id", value: idSchedule.numberString)
        
        var request = URLRequest(finalUrl)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let scheduleResponse = try? JSONDecoder().decode(ScheduleInterviewResponse.self, from: data)
            
            if scheduleResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(scheduleResponse!))
            }
            
        }.resume()
    }
    
    // MARK:- API SUBMIT USER SCHEDULE NASABAH EXISTING
    func submitScheduleInterviewNasabahExisting(
        atmData: AddProductATM,
        date: String,
        nik: String,
        endTime: String,
        startTime: String,
        completion: @escaping(Result<Status, NetworkError>) -> Void) {
        
        let firebaseToken = Messaging.messaging().fcmToken
        
        let body: [String: Any] = [
            "schedule": [
                "date": "2020-12-11",
                "fireBaseToken": firebaseToken!,
                "nik": atmData.nik,
                "timeEnd": "09:00",
                "timeStart": "08:00",
                "app": "ios-mestika"
            ],
            "atm": [
                "atmAddressInput": "JL PROF DR LATUMETEN I GG.5/",
                "atmAddressKelurahanInput": "KELURAHAn",
                "atmAddressKecamatanInput": "KECAMATAN",
                "atmAddressKotaInput": "KOTA",
                "atmAddressPropinsiInput": "PROVINISI",
                "atmAddressPostalCodeInput": "12345",
                "atmAddressRtInput": "002",
                "atmAddressRwInput": "003",
                "atmName": "TEST",
                "isNasabahMestika": true,
                "codeClass": "02",
                "imageDesign": "http://eagle.visiondg.xyz:8765/image/b5fb9a649b2c3670120343eb8dd85d03.png",
                "addressEqualToDukcapil": false
            ]
        ]
        
        print("body => \(body)")
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlSheduleInterviewNasabahExisting() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let response = try? JSONDecoder().decode(Status.self, from: data)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            if response == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(response!))
            }
            
        }.resume()
        
    }
    
    // MARK:- API SUBMIT USER SCHEDULE NASABAH NON EXISTING
    func submitScheduleInterview(date: String, nik: String, endTime: String, startTime: String, completion: @escaping(Result<UserCheckResponse?, ErrorResult>) -> Void) {
        
        let firebaseToken = Messaging.messaging().fcmToken
        
        let body: [String: Any] = [
            "date": date,
            "nik":  nik,
            "fireBaseToken": firebaseToken!,
            "app": "ios-mestika",
            "isNasabahMestika": false,
            "timeEnd": endTime,
            "timeStart": startTime
        ]
        
        print("body => \(body)")
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlUser() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url
            .appending("type", value: "scheduleVC")
        
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
    
    // MARK:- API RESCHEDULE
    func submitReScheduleInterview(date: String, nik: String, endTime: String, startTime: String, completion: @escaping(Result<UserCheckResponse?, ErrorResult>) -> Void) {
        
        let firebaseToken = Messaging.messaging().fcmToken
        
        let body: [String: Any] = [
            "date": date,
            "nik":  nik,
            "fireBaseToken": firebaseToken!,
            "app": "ios-mestika",
            "isNasabahMestika": false,
            "timeEnd": endTime,
            "timeStart": startTime
        ]
        
        print("body => \(body)")
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlUser() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url
            .appending("type", value: "reScheduleVC")
        
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
