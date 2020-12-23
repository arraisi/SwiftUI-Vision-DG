//
//  ScheduleInterviewViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/11/20.
//

import Foundation
import SwiftUI
import Combine

class ScheduleInterviewSummaryViewModel: ObservableObject {
    var idSchedule: Int = 0
    
    private var _scheduleModels = [ScheduleInterviewResponse]()
    
    @Published var schedule = [ScheduleInterviewViewModel]()
    @Published var isLoading: Bool = false
    @Published var timeStart: String = ""
    @Published var timeEnd: String = ""
    
    @Published var scheduleDates = [String]()
    @Published var scheduleJamBasedOnDate = [String]()
    
    @Published var message: String = ""
    @Published var code: String = ""
    
    // MARK:- GET ALL SCHEDULE
    func getAllSchedule(completion: @escaping (Bool) -> Void) {
        if schedule.count > 0 {
            self.isLoading = false
            completion(true)
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ScheduleInterviewService.shared.getSheduleInterviewAll { result in
            print(result)
            
            switch result {
            case .success(let schedule):
                
                print("Length Data Schedule : \(schedule?.count)")
                
                if let schedule = schedule {
                    self._scheduleModels = schedule
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.schedule = schedule.map(ScheduleInterviewViewModel.init)
                        self.scheduleDates = Array(Set(schedule.map({ (resp:ScheduleInterviewResponse) -> String in
                            return resp.date
                        }))).sorted()
                    }
                }
                
                completion(true)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
            case .failure(let error):
                
                print("Error Get Schedule")
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- GET SCHEDULE BY DATE
    func getScheduleById(date: String) {
        self.scheduleJamBasedOnDate = Array(Set(schedule.filter({ (data:ScheduleInterviewViewModel) -> Bool in
            return data.date == date
        }).map({ (data:ScheduleInterviewViewModel) -> String in
            return "\(data.timeStart)" + "-" + "\(data.timeEnd)"
        }))).sorted()
    }
    
    // MARK:- GET SCHEDULE BY ID
    func getScheduleById(idSchedule: Int) {
        ScheduleInterviewService.shared.getSheduleInterviewFindById(idSchedule: idSchedule) { result in
            print(result)
            
            switch result {
            case .success(let schedule):
                print("Success")
                
                DispatchQueue.main.async {
                    self.timeStart = schedule!.timeStart
                    self.timeEnd = schedule!.timeEnd
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- SUBMIT SCHEDULE INTERVIEW
    func submitSchedule(date: String, nik: String, endTime: String, startTime: String, completion: @escaping (Bool) -> Void) {
        ScheduleInterviewService.shared.submitScheduleInterview(date: date, nik: nik, endTime: endTime, startTime: startTime) { result in
            print(result)
            
            switch result {
            case .success(let schedule):
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    self.code = schedule!.code!
                    self.message = schedule!.message!
                }
                
                completion(true)

            case .failure(let error):
                print("ERROR-->")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    print("Internal Server Error")
                    self.message = "Internal Server Error"
                default:
                    print("ERRROR")
                }
                completion(false)
            }
        }
    }
}

class ScheduleInterviewViewModel {
    
    var schedule: ScheduleInterviewResponse
    
    init(schedule: ScheduleInterviewResponse) {
        self.schedule = schedule
    }
    
    var id: Int {
        return self.schedule.id
    }
    
    var date: String {
        return self.schedule.date
    }
    
    var timeStart: String {
        return self.schedule.timeStart
    }
    
    var timeEnd: String {
        return self.schedule.timeEnd
    }
    
}
