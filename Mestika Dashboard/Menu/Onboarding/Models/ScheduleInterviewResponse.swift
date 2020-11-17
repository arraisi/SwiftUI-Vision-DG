//
//  ScheduleInterviewResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 16/11/20.
//

import Foundation

// MARK: - ScheduleInterviewResponse
class ScheduleInterviewResponse: Decodable {
    let id: Int
    let date: String
//    var time: JSONNull?
    let timeStart, timeEnd: String
}
