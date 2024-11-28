//
//  ContentView.swift
//  HapticTester
//
//  Created by Edward Downhill on 21/11/2024.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @StateObject private var hapticManager = HapticManager()
    
    @State private var selectedTitle: String?
    @State private var selectedDescription: String?

    @State private var nativeCurveId: UUID?
    @State private var selectedCurve: SimpleHapticCurve?
    @State private var isPresentingPopover = false

    var body: some View {
        VStack {
            Text("Haptic Playground")
                .font(.largeTitle)
                .padding()

            if #available(iOS 17.0, *) {
                List(SimpleHapticCurve.nativeCurves) { curve in
                    Button(action: {
                        nativeCurveId = curve.id
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            nativeCurveId = nil
                        }
                    }) {
                        Text(curve.name)
                    }
                    .sensoryFeedback(curve.feedback, trigger: nativeCurveId) { old, new in
                        new == curve.id
                    }
                }
                .frame(maxHeight: .infinity)
            } else {
                List(SimpleHapticCurve.examples) { curve in
                    Button(action: {
                        selectedCurve = curve
                        applyCurve(curve)
                    }) {
                        Text(curve.name)
                    }
                }
                .frame(maxHeight: .infinity)
            }

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
