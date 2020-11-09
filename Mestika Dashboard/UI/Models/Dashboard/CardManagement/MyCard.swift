//
//  KartuKu.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/11/20.
//

import SwiftUI

struct MyCard: Hashable, Codable, Identifiable {
    
    var id : Int
    var rekeningName: String
    var saldo: String
    var rekeningNumber: String
    var imageName : String
    var activeStatus : Bool
    var blocked : Bool
    var isShow : Bool
    
}
