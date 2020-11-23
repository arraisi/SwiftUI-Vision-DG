//
//  ScheduleInterviewResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/11/20.
//

import Foundation

// MARK: - ScheduleInterviewResponse
class ScheduleInterviewResponse: Decodable {
    var id: Int
    var date: String
    var nik: String
//    var time: JSONNull?
    var timeStart, timeEnd: String
}
