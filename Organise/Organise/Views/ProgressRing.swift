//
//  ProgressRing.swift
//  Organise
//
//  Created by David Fitzgerald on 27/07/2025.
//
import SwiftUI


struct ProgressRing: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: progress)
                

            VStack(spacing: 0) {
                Text("\(Int(progress * 100))%")
                    .contentTransition(.numericText())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("done")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var progress = 0.50
    ProgressRing(progress: progress, color: .green, lineWidth: 4, size:50)
    Button("Change percentage") {
        withAnimation {
            progress = Double.random(in: 0...100) / 100
        }
    }
}
