import SwiftUI

fileprivate extension Array {
    subscript(safe i: Int) -> Element? {
        indices.contains(i) ? self[i] : nil
    }
}

struct AxisPicker: View {
    @Binding var coords: [CGFloat]
    let xMin: CGFloat
    let xMax: CGFloat
    let yMin: CGFloat
    let yMax: CGFloat
    
    var handleSize: CGFloat = 30
    var strokeWidth: CGFloat = 4
    
    private let knobRadius: CGFloat = 10
    private var xSpan: CGFloat { xMax - xMin }
    private var ySpan: CGFloat { yMax - yMin }
    
    private func clamp(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat {
        min(max(v, lo), hi)
    }
    
    public var body: some View {
        GeometryReader { geo in
            let side  = min(geo.size.width, geo.size.height)
            let track = side - knobRadius * 2
            
            // Current knob center from coord values
            let nx = ((coords[safe: 0] ?? xMin) - xMin) / xSpan
            let ny = ((coords[safe: 1] ?? yMin) - yMin) / ySpan
            let cx = clamp(nx * track + knobRadius, knobRadius, side - knobRadius)
            let cy = clamp(ny * track + knobRadius, knobRadius, side - knobRadius)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12.5)
                    .fill(Color(hex: "78D6FF"))
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12.5)
                                .stroke(Color.black.opacity(0.7), lineWidth: strokeWidth)
                                .blur(radius: 5)
                                .mask {
                                    RoundedRectangle(cornerRadius: 12.5)
                                }
                            
                            RoundedRectangle(cornerRadius: 12.5)
                                .stroke(Color(hex: "1E8CCB"), lineWidth: strokeWidth)
                        }
                    }
                
                ZStack {
                    Circle()
                        .fill(Color(hex: "4C7C97"))
                        .frame(width: handleSize, height: handleSize)
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    
                    Circle()
                        .fill(Color(hex: "4C7C97")
                                .shadow(.inner(color: Color.black.opacity(0.3), radius: 4)))
                        .frame(width: handleSize - strokeWidth * 2,
                               height: handleSize - strokeWidth * 2)
                }
                    .position(x: cx, y: cy)
                    .gesture(
                        DragGesture()
                            .onChanged { g in
                                // Clamp gesture location to travelable area
                                let lx = clamp(g.location.x, knobRadius, side - knobRadius)
                                let ly = clamp(g.location.y, knobRadius, side - knobRadius)
                                
                                coords = [
                                    (lx - knobRadius) / track * xSpan + xMin,
                                    (ly - knobRadius) / track * ySpan + yMin
                                ]
                            }
                    )
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            if coords.count != 2 { coords = [xMin, yMin] }
        }
    }
}
