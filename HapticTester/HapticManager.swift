//
//  HapticManager.swift
//  HapticTester
//
//  Created by Edward Downhill on 25/11/2024.
//

import CoreHaptics
import SwiftUI

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
