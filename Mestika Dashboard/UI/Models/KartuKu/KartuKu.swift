//
//  KartuKu.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/11/20.
//

import SwiftUI

struct KartuKu: Hashable, Codable, Identifiable {
    
    var id : Int
    var imageName : String
    var activeStatus : Bool
    var isShow : Bool
    fileprivate var details: [DetailKartuKu]
    
}

struct DetailKartuKu: Hashable, Codable {
    var name: Double
    var description: Double
}
