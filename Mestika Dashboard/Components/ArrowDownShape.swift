//
//  ArrowUpShape.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct ArrowDownShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = rect.width/2
        
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))

            path.addLine(to: CGPoint(x: center - 15, y: rect.height - 20))
            path.addLine(to: CGPoint(x: center, y: rect.height))
            path.addLine(to: CGPoint(x: center + 15, y: rect.height - 20))

            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
        }
    }
}
