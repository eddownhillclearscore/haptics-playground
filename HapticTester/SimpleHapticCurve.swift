//
//  SimpleHapticCurve.swift
//  HapticTester
//
//  Created by Edward Downhill on 25/11/2024.
//

import SwiftUI

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
    
    @available(iOS 17.0, *)
    static let nativeCurves: [NativeHapticCurve] = [
        .init(name: "Start", feedback: .start),
        .init(name: "Stop", feedback: .stop),
        .init(name: "Alignment", feedback: .alignment),
        .init(name: "Decrease", feedback: .decrease),
        .init(name: "Increase", feedback: .increase),
        .init(name: "Level Change", feedback: .levelChange),
        .init(name: "Selection", feedback: .selection),
        .init(name: "Success", feedback: .success),
        .init(name: "Warning", feedback: .warning),
        .init(name: "Error", feedback: .error)
    ]
}

@available(iOS 17.0, *)
struct NativeHapticCurve: Identifiable {
    let id = UUID()
    let name: String
    let feedback: SensoryFeedback
}
