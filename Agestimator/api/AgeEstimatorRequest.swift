//
//  AgeEstimatorRequest.swift
//  Agestimator
//
//  Created by Natascha Fadeeva on 20.06.25.
//

import Foundation

struct AgeEstimatorRequest {
    let name: String

    func makeURL(with baseURL: URL) -> URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "name", value: name)]
        return components?.url
    }
}
