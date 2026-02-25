import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    var duration: Double = 2.5
    var shimmerColor: Color = .white

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    let width = geo.size.width
                    LinearGradient(
                        colors: [
                            shimmerColor.opacity(0),
                            shimmerColor.opacity(0.4),
                            shimmerColor.opacity(0),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: width * 0.4)
                    .offset(x: -width * 0.4 + (width * 1.8) * phase)
                    .animation(
                        .linear(duration: duration)
                        .repeatForever(autoreverses: false),
                        value: phase
                    )
                }
                .mask(content)
            }
            .onAppear {
                phase = 1
            }
    }
}

extension View {
    func shimmer(duration: Double = 2.5, color: Color = .white) -> some View {
        modifier(ShimmerModifier(duration: duration, shimmerColor: color))
    }
}
