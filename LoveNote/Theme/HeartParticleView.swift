import SwiftUI

struct HeartParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var rotation: Double
    var speed: CGFloat
    var wobbleOffset: CGFloat
    var wobbleSpeed: CGFloat
}

struct HeartParticleView: View {
    @State private var particles: [HeartParticle] = []
    @State private var time: Double = 0

    let particleCount: Int
    let colors: [Color]

    init(particleCount: Int = 18, colors: [Color] = [
        ValentineTheme.roseRed,
        ValentineTheme.hotPink,
        ValentineTheme.softPink,
        ValentineTheme.deepRed,
        .pink
    ]) {
        self.particleCount = particleCount
        self.colors = colors
    }

    var body: some View {
        TimelineView(.animation) { (timeline: TimelineViewDefaultContext) in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate

                for particle in particles {
                    let elapsed = now.truncatingRemainder(dividingBy: 200)
                    let yOffset = (elapsed * Double(particle.speed) * 30)
                        .truncatingRemainder(dividingBy: Double(size.height + 100))
                    let currentY = size.height + 50 - yOffset
                    let wobble = sin(elapsed * Double(particle.wobbleSpeed)) * Double(particle.wobbleOffset)
                    let currentX = Double(particle.x) * Double(size.width) + wobble
                    let currentRotation = elapsed * particle.rotation

                    let progress = yOffset / Double(size.height + 100)
                    let fadeOpacity = particle.opacity * (1.0 - progress * 0.6)

                    var contextCopy = context
                    contextCopy.opacity = max(0, fadeOpacity)
                    contextCopy.translateBy(x: currentX, y: currentY)
                    contextCopy.rotate(by: .degrees(currentRotation * 30))

                    let heartImage = Image(systemName: "heart.fill")
                    let resolved = contextCopy.resolve(heartImage)
                    contextCopy.draw(resolved, at: .zero)
                }
            }
        }
        .onAppear {
            particles = (0..<particleCount).map { _ in
                HeartParticle(
                    x: CGFloat.random(in: 0.05...0.95),
                    y: CGFloat.random(in: 0...1),
                    size: CGFloat.random(in: 10...28),
                    opacity: Double.random(in: 0.15...0.5),
                    rotation: Double.random(in: -2...2),
                    speed: CGFloat.random(in: 0.3...1.2),
                    wobbleOffset: CGFloat.random(in: 10...35),
                    wobbleSpeed: CGFloat.random(in: 0.5...2.0)
                )
            }
        }
        .foregroundStyle(ValentineTheme.hotPink.opacity(0.6))
        .allowsHitTesting(false)
    }
}
