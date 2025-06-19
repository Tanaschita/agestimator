//
//  AgeEstimatorView.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 19.06.25.
//

import SwiftUI

struct AgeEstimatorView: View {

    @State private var viewModel = AgeEstimatorViewModel(api: LiveAgeEstimatorAPI())
    @State private var name: String = ""

    var body: some View {
        VStack(spacing: 24) {
            titleView
            nameInputField
            estimateButton
            errorView
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
            viewModel.estimateAge(for: name)
        }) {
            Text("Let's go")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }

    // MARK: - Result View

    private var resultView: some View {
        if let estimatedAge = viewModel.estimatedAge {
            Text("Estimated age: \(estimatedAge)")
                .font(.title2)
        } else {
            Text("Estimated age: ?")
                .font(.title2)
        }
    }

    // MARK: - Error View

    @ViewBuilder
    private var errorView: some View {
        if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    AgeEstimatorView()
}
