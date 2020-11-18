//
//  NotificationModel.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 16/11/20.
//

import Foundation

struct NotificationModel: Identifiable {
    var id: Int
    var type, status, title, time, destinationAccount, amount: String
}
