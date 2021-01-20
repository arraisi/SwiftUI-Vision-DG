//
//  KetentuanViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 17/11/20.
//

import SwiftUI

class KetentuanViewModel: ObservableObject {
    /* Data Model */
    @Published var data = [
        KetentuanModel(
            id: 1,
            number: "01.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
        KetentuanModel(
            id: 2,
            number: "02.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
        KetentuanModel(
            id: 3,
            number: "03.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
        KetentuanModel(
            id: 4,
            number: "04.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
    ]
    
    @Published var readed: Bool = false
}
