//
//  AgeResultView.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 20.06.25.
//

import SwiftUI
import Combine

struct AgeResultView: View {
    let isLoading: Bool
    let estimatedAge: Int?

    @State private var randomAge = 0
    @State private var timerActive = false
    @State private var showPulse = false

    private let maxAge = 116
    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 15) {
            Text("Estimated age")
                .font(.title2)

            Text(displayedAge)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .scaleEffect(showPulse ? 1.2 : 1.0)
                .shadow(color: showPulse ? .orange.opacity(0.4) : .clear, radius: 10)
                .animation(.easeOut(duration: 0.3), value: showPulse)
        }
        .onAppear {
            timerActive = isLoading
        }
        .onDisappear {
            timerActive = false
        }
        .onChange(of: isLoading) { _, newValue in
            timerActive = newValue
        }
        .onChange(of: estimatedAge) { _, newValue in
            if newValue != nil {
                timerActive = false
                showPulse = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showPulse = false
                }
            }
        }
        .onReceive(timer) { _ in
            guard timerActive else { return }
            withAnimation(.easeInOut(duration: 0.1)) {
                randomAge = Int.random(in: 1...maxAge)
            }
        }
    }

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
