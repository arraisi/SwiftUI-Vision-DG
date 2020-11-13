//
//  SideMenuContent.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/10/20.
//

import Foundation

class SideMenuContent: Identifiable, ObservableObject {
    var id = UUID()
    var name: String = ""
    var image: String = ""
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
