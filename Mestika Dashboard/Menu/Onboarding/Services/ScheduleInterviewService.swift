//
//  ScheduleInterviewService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/11/20.
//

import Foundation

class ScheduleInterviewService {
    
    private init() {}
    
    static let shared = ScheduleInterviewService()
    
    // MARK: - API GET SCHEDULE ALL
    func getSheduleInterviewAll(completion: @escaping(Result<[ScheduleInterviewResponse]?, NetworkError>) -> Void) {
        
        print("API SCHEDULE ALL")
        
        guard let url = URL.urlSheduleInterview() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
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
        
        var request = URLRequest(url: finalUrl)
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
    
    // MARK:- API GET SCHEDULE FIND BY ID
    func submitScheduleInterview(date: String, nik: String, endTime: String, startTime: String, completion: @escaping(Result<ScheduleInterviewResponse?, NetworkError>) -> Void) {
        
        let body: [String: String] = ["date": date, "nik":  nik, "timeEnd": endTime, "timeStart": startTime]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlSheduleInterviewSubmit() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("21", forHTTPHeaderField: "X-Device-ID")
        request.addValue("01", forHTTPHeaderField: "X-Firebase-ID")
        
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("response: \(String(describing: response))")
            
            guard let _ = data, error == nil else {
                return completion(.failure(.noData))
            }
            
        }.resume()
    }
}
