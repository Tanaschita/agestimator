//
//  AgeEstimatorAPI.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 19.06.25.
//

import Foundation

// MARK: - Protocol

protocol AgeEstimatorAPI {
    func estimateAge(for request: EstimateAgeRequest) async throws -> EstimateAgeResponse
}

// MARK: - Live API Implementation

final class LiveAgeEstimatorAPI: AgeEstimatorAPI {

    private let baseURL = URL(string: "https://api.agify.io")!
    private let session: URLSession = .shared

    func estimateAge(for request: EstimateAgeRequest) async throws -> EstimateAgeResponse {
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

// MARK: - Request Model

struct EstimateAgeRequest {
    let name: String

    func makeURL(with baseURL: URL) -> URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "name", value: name)]
        return components?.url
    }
}

// MARK: - Response Model

struct EstimateAgeResponse: Decodable {
    let age: Int
    let name: String
}
