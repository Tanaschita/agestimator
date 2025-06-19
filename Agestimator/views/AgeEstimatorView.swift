//
//  AgeEstimatorView.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 19.06.25.
//

import SwiftUI

struct AgeEstimatorView: View {

    @State private var name: String = ""

    var body: some View {
        VStack(spacing: 24) {
            titleView
            nameInputField
            estimateButton
            resultView
            Spacer()
        }
        .padding()
    }

    // MARK: - Title

    private var titleView: some View {
        Text("Agestimator")
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    // MARK: - Name Input

    private var nameInputField: some View {
        TextField("Enter your name", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }

    // MARK: - Estimate Button

    private var estimateButton: some View {
        Button(action: {
            //
        }) {
            Text("Let's go")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(name.isEmpty)
        .padding(.horizontal)
    }

    // MARK: - Result View

    private var resultView: some View {
        Text("Estimated age: ?")
            .font(.title2)
            .transition(.opacity)
    }
}

#Preview {
    AgeEstimatorView()
}
