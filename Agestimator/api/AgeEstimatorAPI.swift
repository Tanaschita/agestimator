//
//  AgeEstimatorAPI.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 19.06.25.
//

import Foundation

// MARK: - Protocol

protocol AgeEstimatorAPI {
    func estimateAge(for request: AgeEstimatorRequest) async throws -> AgeEstimatorResponse
}

// MARK: - Live API Implementation

/// A real network-based implementation of AgeEstimatorAPI using agify.io.
class LiveAgeEstimatorAPI: AgeEstimatorAPI {

    private let baseURL = URL(string: "https://api.agify.io")!
    private let session: URLSession = .shared

    func estimateAge(for request: AgeEstimatorRequest) async throws -> AgeEstimatorResponse {
        guard let url = request.makeURL(with: baseURL) else {
            throw URLError(.badURL)
        }

        return try await performRequest(url: url)
    }

    // MARK: - Internal Request Method

    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Delaying API Implementation

/// Wraps any AgeEstimatorAPI and guarantees a minimum execution duration.
class DelayingAgeEstimatorAPI: AgeEstimatorAPI {
    private let wrapped: AgeEstimatorAPI
    private let minimumDuration: TimeInterval

    init(wrapping api: AgeEstimatorAPI, minimumDuration: TimeInterval = 1.5) {
        self.wrapped = api
        self.minimumDuration = minimumDuration
    }

    func estimateAge(for request: AgeEstimatorRequest) async throws -> AgeEstimatorResponse {
        let start = Date()

        let result = try await wrapped.estimateAge(for: request)

        let elapsed = Date().timeIntervalSince(start)
        let remaining = minimumDuration - elapsed

        if remaining > 0 {
            try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
        }

        return result
    }
}
