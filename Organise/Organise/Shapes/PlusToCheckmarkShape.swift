//
//  PlusToCheckmarkShape.swift
//  Organise
//
//  Created by David Fitzgerald on 20/08/2025.
//

import SwiftUI


struct PlusToCheckmarkShape: Shape {
    var progress: CGFloat // 0 = plus, 1 = checkmark

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let size = min(rect.width, rect.height)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let half = size / 2

        // === Define Plus (+) Lines ===
        let plusVStart = CGPoint(x: center.x, y: center.y - half * 0.5)
        let plusVEnd   = CGPoint(x: center.x, y: center.y + half * 0.5)

        let plusHStart = CGPoint(x: center.x - half * 0.5, y: center.y)
        let plusHEnd   = CGPoint(x: center.x + half * 0.5, y: center.y)

        // === Define Checkmark Points (single path) ===
        let checkStart = CGPoint(x: center.x - half * 0.4, y: center.y)
        let checkMid   = CGPoint(x: center.x - half * 0.1, y: center.y + half * 0.3)
        let checkEnd   = CGPoint(x: center.x + half * 0.4, y: center.y - half * 0.3)

        // === Interpolation Helper ===
        func interp(_ from: CGPoint, _ to: CGPoint) -> CGPoint {
            CGPoint(
                x: from.x + (to.x - from.x) * progress,
                y: from.y + (to.y - from.y) * progress
            )
        }

        if progress < 0.5 {
            // Draw plus symbol lines, fade out toward check
            let pVStart = interp(plusVStart, checkStart)
            let pVEnd   = interp(plusVEnd,   checkMid)
            let pHStart = interp(plusHStart, checkMid)
            let pHEnd   = interp(plusHEnd,   checkEnd)

            path.move(to: pVStart)
            path.addLine(to: pVEnd)

            path.move(to: pHStart)
            path.addLine(to: pHEnd)
        } else {
            // Morph from plus symbol into checkmark
            let p1 = interp(plusVStart, checkStart)
            let p2 = interp(plusVEnd,   checkMid)
            let p3 = interp(plusHEnd,   checkEnd)

            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
        }

        return path
    }
}

#Preview {
    /**
     * Preview that toggles isCompleted every few seconds.
     */
    @Previewable @State var isCompleted = false
    let color = Color.blue
    let interval = 2.0
    
    ZStack {
        Circle()
            .fill(isCompleted ? color : Color.clear)
            .frame(width: 44, height: 44)
            .overlay(
                Circle()
                    .stroke(isCompleted ? color : Color.gray.opacity(0.4), lineWidth: 2)
            )
        
        PlusToCheckmarkShape(progress: isCompleted ? 1 : 0)
            .stroke(isCompleted ? .white : .gray, lineWidth: 3)
            .frame(width: 44, height: 44)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isCompleted)
    }
    .onAppear {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            isCompleted.toggle()
        }
    }
}

