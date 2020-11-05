//
//  PopUpBubble.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/11/20.
//

import SwiftUI

struct PopupBubble: Shape {
    let cornerRadius: CGFloat
    let arrowHeight: CGFloat
    let arrowEdge: Edge

    init(cornerRadius: CGFloat = 6, arrowEdge: Edge = .trailing, arrowHeight: CGFloat = 13) {
        self.cornerRadius = cornerRadius
        self.arrowHeight = arrowHeight
        self.arrowEdge = arrowEdge
    }

    func path(in rect: CGRect) -> Path {
        // we will add more here...
        let rect = rect
        let fit: ((CGPoint) -> (CGPoint)) = { point in return point }
        let arrow: CGSize = CGSize(width: (arrowHeight/811)*2000, height: arrowHeight)
        
        let clockwise = false
        let arc1 = (start: Angle.radians(-.pi*0.5), end: Angle.radians(.pi*0.0))
        let arc2 = (start: Angle.radians(.pi*0.0),  end: Angle.radians(.pi*0.5))
        let arc3 = (start: Angle.radians(.pi*0.5),  end: Angle.radians(.pi*1.0))
        let arc4 = (start: Angle.radians(.pi*1.0),  end: Angle.radians(-.pi*0.5))
        
        var path = Path()

        // Move to beginning of Arc 1
        path.move(to: fit(CGPoint(x: rect.width*0.5 + arrow.width*0.5, y: arrow.height)) )

        // Step 1 (arc1)
        path.addArc(center: fit(CGPoint(x: rect.width - cornerRadius, y: cornerRadius + arrow.height)),
                    radius: cornerRadius,
                    startAngle: arc1.start,
                    endAngle: arc1.end,
                    clockwise: clockwise )
        // Step 2 (arc2)
        path.addArc(center: fit(CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius)),
                    radius: cornerRadius,
                    startAngle: arc2.start,
                    endAngle: arc2.end,
                    clockwise: clockwise )
        // Step 3 (arc3)
        path.addArc(center: fit(CGPoint(x: cornerRadius, y: rect.height - cornerRadius)),
                    radius: cornerRadius,
                    startAngle: arc3.start,
                    endAngle: arc3.end,
                    clockwise: clockwise )
        // Step 4 (arc4)
        path.addArc(center: fit(CGPoint(x: cornerRadius, y: cornerRadius + arrow.height)),
                    radius: cornerRadius,
                    startAngle: arc4.start,
                    endAngle: arc4.end,
                    clockwise: clockwise )
        
        // arrow points where x = distance from arrow center, y = distance from top of rect
        let apex = CGPoint(x: arrow.width*0.5*0.000, y: -arrow.height*0.1456)
        let peak = CGPoint(x: arrow.width*0.5*0.149, y: arrow.height*0.0864)
        let curv = CGPoint(x: arrow.width*0.5*0.600, y: arrow.height*0.7500)
        let ctrl = CGPoint(x: arrow.width*0.5*0.750, y: arrow.height*1.0000)
        let base = CGPoint(x: arrow.width*0.5*1.000, y: arrow.height*1.0000)
        
        // Step 5
        path.addLine(to: fit(CGPoint(x: rect.midX - base.x, y: base.y)))

        // Step 6
        path.addQuadCurve(to:      fit(CGPoint(x: rect.midX - curv.x, y: curv.y)),
                          control: fit(CGPoint(x: rect.midX - ctrl.x, y: ctrl.y)))

        // Step 7
        path.addLine(to: fit(CGPoint(x: rect.midX - peak.x, y: peak.y)))

        // Step 8
        path.addQuadCurve(to:      fit(CGPoint(x: rect.midX + peak.x, y: peak.y)),
                          control: fit(CGPoint(x: rect.midX + apex.x, y: apex.y)))

        // Step 9
        path.addLine(to: fit(CGPoint(x: rect.midX + curv.x, y: curv.y)))

        // Step 10
        path.addQuadCurve(to:      fit(CGPoint(x: rect.midX + base.x, y: base.y)),
                          control: fit(CGPoint(x: rect.midX + ctrl.x, y: ctrl.y)))

        return path
    }
}

// MARK: - RESOURCE
// https://medium.com/better-programming/cgaffinetransforms-arcs-and-quad-curves-in-swiftui-41e1dbfe6161
