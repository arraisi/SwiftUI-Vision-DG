//
//  DeviceTraceModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/05/21.
//

import Foundation

class DeviceTraceModel: ObservableObject {
    @Published var osVersion = ""
    @Published var version = ""
    @Published var sdk = ""
    @Published var release = ""
    @Published var device = ""
    @Published var model = ""
    @Published var product = ""
    @Published var brand = ""
    @Published var display = ""
    @Published var cpuAbi = ""
    @Published var cpuAbi2 = ""
    @Published var unknown = ""
    @Published var hardware = ""
    @Published var id = ""
    @Published var manufacturer = ""
    @Published var serial = ""
    @Published var user = ""
    @Published var host = ""
    @Published var latitude = ""
    @Published var longitude = ""
    @Published var carrier = ""
    @Published var ip4 = ""
    @Published var ip6 = ""
    @Published var iccId = ""
    
    static let shared = DeviceTraceModel()
}
