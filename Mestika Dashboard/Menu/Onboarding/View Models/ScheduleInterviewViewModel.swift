//
//  ScheduleInterviewViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/11/20.
//

import Foundation

class ScheduleInterviewSummaryViewModel: ObservableObject {
    var idSchedule: Int = 0
    
    private var _scheduleModels = [ScheduleInterviewResponse]()
    
    @Published var schedule = [ScheduleInterviewViewModel]()
    @Published var isLoading: Bool = false
    @Published var timeStart: String = ""
    @Published var timeEnd: String = ""
    
    
    // MARK:- GET ALL SCHEDULE
    func getAllSchedule(completion: @escaping (Bool) -> Void) {
        
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
                    }
                }
                
                completion(true)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                print(error.localizedDescription)
            }
        }
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
}

class ScheduleInterviewViewModel: Identifiable {
    
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
