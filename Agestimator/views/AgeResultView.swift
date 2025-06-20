//
//  AgeResultView.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 20.06.25.
//

import SwiftUI
import Combine

/// This view shows random numbers while loading, then reveals the result with a subtle pulse.
struct AgeResultView: View {
    // MARK: - Inputs

    let isLoading: Bool
    let estimatedAge: Int?

    // MARK: - State

    @State private var randomAge = 0
    @State private var isTimerActive = false
    @State private var showPulse = false

    // MARK: - Constants

    private let maxAge = 116
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 15) {
            Text("Estimated age")
                .font(.title2)

            ageDisplayView
        }
        .onDisappear {
            isTimerActive = false
        }
        .onChange(of: isLoading) { _, newValue in
            isTimerActive = newValue
        }
        .onChange(of: estimatedAge) { _, newValue in
            if newValue != nil {
                isTimerActive = false
                triggerPulse()
            }
        }
        .onReceive(timer) { _ in
            guard isTimerActive else { return }
            withAnimation(.easeInOut(duration: 0.1)) {
                randomAge = Int.random(in: 1...maxAge)
            }
        }
    }

    // MARK: - Views

    private var ageDisplayView: some View {
        Text(displayedAge)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.orange)
            .scaleEffect(showPulse ? 1.5 : 1.0)
            .shadow(color: showPulse ? .orange.opacity(0.4) : .clear, radius: 10)
            .animation(.easeOut(duration: 0.3), value: showPulse)
    }

    // MARK: - Logic

    private func triggerPulse() {
        showPulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPulse = false
        }
    }

    // MARK: - Computed Properties

    private var displayedAge: String {
        if isLoading {
            return String(randomAge)
        } else if let age = estimatedAge {
            return String(age)
        } else {
            return "??"
        }
    }
}

#Preview {
    AgeResultView(isLoading: false, estimatedAge: 60)
}
