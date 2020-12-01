//
//  SavingType.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import Foundation

struct SavingType: Hashable, Codable, Identifiable {
    
    var id : Int
    var tabunganName: String
    var rekeningNumber: String
    var imageName : String
    var isShow : Bool
    var description: [SavingTypeDescription]
}

struct SavingTypeDescription: Hashable, Codable, Identifiable {
    var id : String
    var desc: String
}
