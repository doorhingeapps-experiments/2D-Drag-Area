//
// 2D Drag Area
// ContentView.swift
//
// Created on 5/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI

struct ContentView: View {
    @State private var pos: [CGFloat] = [0, 0]
    
    var body: some View {
        VStack(spacing: 12) {
            AxisPicker(coords: $pos,
                       xMin: -200,  xMax: 200,
                       yMin: -200,  yMax: 200)
                .frame(width: 200)
            
            Text("x: \(pos[0], specifier: "%.1f")   y: \(pos[1], specifier: "%.1f")")
                .font(.caption)
        }
        .padding()
        .frame(width: 260, height: 320)
    }
}



#Preview {
    ContentView()
}
