//
//  ScheduleInterviewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 23/11/20.
//

import SwiftUI

struct ScheduleInterviewModel:  Hashable, Codable, Identifiable  {
    var id: Int
    var date: String
    var nik: String
    var timeEnd: String
    var timeStart: String
}
