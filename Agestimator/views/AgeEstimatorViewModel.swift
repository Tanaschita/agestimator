//
//  AgeEstimatorViewModel.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 19.06.25.
//

import Observation

@Observable
final class AgeEstimatorViewModel {
    // MARK: - Output

    private(set) var estimatedAge: Int? = nil
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil

    // MARK: - Dependencies

    private let api: AgeEstimatorAPI

    init(api: AgeEstimatorAPI) {
        self.api = api
    }

    // MARK: - Public Interface

    func estimateAge(for name: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a name."
            return
        }

        isLoading = true
        estimatedAge = nil
        errorMessage = nil

        Task {
            do {
                let request = EstimateAgeRequest(name: name)
                let response = try await api.estimateAge(for: request)
                estimatedAge = response.age
            } catch {
                errorMessage = "Something went wrong. Please try again."
            }

            isLoading = false
        }
    }
}

