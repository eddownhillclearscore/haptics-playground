//
//  ContentView.swift
//  HapticTester
//
//  Created by Edward Downhill on 21/11/2024.
//

import SwiftUI
import CoreHaptics

struct SimpleHapticCurve: Identifiable {
    let id = UUID()
    let name: String
    let duration: Float
    let intensity: Float
    let sharpness: Float
    let attackTime: Float
    let decayTime: Float
    let releaseTime: Float
    
    static let examples: [SimpleHapticCurve] = [
        SimpleHapticCurve(
            name: "Soft Pulse",
            duration: 0.5,
            intensity: 0.5,
            sharpness: 0.3,
            attackTime: 0.2,
            decayTime: 0.2,
            releaseTime: 0.3
        ),
        SimpleHapticCurve(
            name: "Sharp Tap",
            duration: 0.1,
            intensity: 1.0,
            sharpness: 1.0,
            attackTime: 0.05,
            decayTime: 0.1,
            releaseTime: 0.05
        ),
        SimpleHapticCurve(
            name: "Long Vibration",
            duration: 1.0,
            intensity: 0.8,
            sharpness: 0.5,
            attackTime: 0.3,
            decayTime: 0.5,
            releaseTime: 0.5
        )
    ]
}

class HapticManager: ObservableObject {
    private var engine: CHHapticEngine?
    @Published var duration: Float = 1.0
    @Published var intensity: Float = 1.0
    @Published var sharpness: Float = 1.0
    @Published var attackTime: Float = 0.1
    @Published var releaseTime: Float = 0.1

    init() {
        prepareEngine()
    }
    
    func prepareEngine() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to start haptic engine: \(error.localizedDescription)")
        }
    }

    func playSimpleHaptic() {
        guard let engine = engine else { return }
        do {
            let pattern = try createSimpleHapticPattern()
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
    
    private func createSimpleHapticPattern() throws -> CHHapticPattern {
        let intensityControl = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessControl = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let attackControl = CHHapticEventParameter(parameterID: .attackTime, value: attackTime)
        let releaseControl = CHHapticEventParameter(parameterID: .releaseTime, value: releaseTime)

        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensityControl, sharpnessControl, attackControl, releaseControl],
            relativeTime: 0,
            duration: TimeInterval(duration)
        )

        return try CHHapticPattern(events: [event], parameters: [])
    }
}

struct ContentView: View {
    @StateObject private var hapticManager = HapticManager()
    
    @State private var selectedTitle: String?
    @State private var selectedDescription: String?

    @State private var selectedCurve: SimpleHapticCurve?
    @State private var isPresentingPopover = false

    var body: some View {
        VStack {
            Text("Haptic Playground")
                .font(.largeTitle)
                .padding()

            List(SimpleHapticCurve.examples) { curve in
                Button(action: {
                    selectedCurve = curve
                    applyCurve(curve)
                }) {
                    Text(curve.name)
                }
            }
            .frame(height: 200)

            VStack(spacing: 20) {
                sliderRow(title: "Duration", value: $hapticManager.duration, range: 0...3, description: "Duration of the haptic feedback.")
                sliderRow(title: "Intensity", value: $hapticManager.intensity, range: 0...1, description: "Intensity of the haptic feedback.")
                sliderRow(title: "Sharpness", value: $hapticManager.sharpness, range: 0...1, description: "Sharpness of the haptic feedback.")
                sliderRow(title: "Attack Time", value: $hapticManager.attackTime, range: 0...1, description: "The time when a haptic pattern’s intensity begins increasing.")
                sliderRow(title: "Release Time", value: $hapticManager.releaseTime, range: 0...1, description: "The time at which to begin fading the haptic pattern.")
            }
            .padding()
            
            // Big circle play button
            Button(action: {
                hapticManager.playSimpleHaptic()
            }) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.blue)
            }
        }
        .alert(isPresented: $isPresentingPopover) {
            Alert(
                title: Text(selectedTitle ?? ""),
                message: Text(selectedDescription ?? "")
            )
        }
    }
    
    private func applyCurve(_ curve: SimpleHapticCurve) {
        hapticManager.intensity = curve.intensity
        hapticManager.sharpness = curve.sharpness
        hapticManager.attackTime = curve.attackTime
        hapticManager.releaseTime = curve.releaseTime
    }
    
    @ViewBuilder
    private func sliderRow(title: String, value: Binding<Float>, range: ClosedRange<Float>, description: String) -> some View {
        HStack {
            Button(action: {
                selectedTitle = title
                selectedDescription = description
                isPresentingPopover = true
            }) {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Text(title)
                            .font(.headline)
                        Image(systemName: "info.circle")
                            .foregroundStyle(.secondary)
                    }
                    Text("\(String(format: "%.2f", value.wrappedValue))")
                        .font(.footnote)
                }
            }
            .foregroundStyle(Color.primary)
            
            Slider(value: value, in: range)
        }
    }
}

#Preview {
    ContentView()
}
