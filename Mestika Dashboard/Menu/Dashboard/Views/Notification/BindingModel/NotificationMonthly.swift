//
//  NotificationMonthly.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 16/11/20.
//

import Foundation

struct NotificationMonthly: Identifiable {
    var id: Int
    var month: String
    var list: [NotificationModel] = []
}
