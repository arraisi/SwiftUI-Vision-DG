//
//  Card.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct Card: Identifiable {
    var id : Int
    var imageName : String
    var name : String
    var description: String
    var activeStatus : Bool
    var isShow : Bool
}
