//
//  BreedService.swift
//  PruebaGS
//
//  Created by PEDRO MENDEZ on 30/07/24.
//

import Foundation
import Combine

/// Service class responsible for fetching breed data from an API
class BreedService {
    
    /// Fetches breed data from the API
    /// - Returns: A publisher that emits breed data or an error
    func fetchBreeds() -> AnyPublisher<BreedsDAta, Error> {
        /// Constructing the URL with query parameters
        let url = BreedServiceConstant.url.appending(queryItems: [.init(name: "limit", value: "100")])
        
        /// Performing a data task with the constructed URL
        return URLSession.shared.dataTaskPublisher(for: url)
            /// Extracting the data from the response
            .map(\.data)
            /// Decoding the data into the BreedsDAta model
            .decode(type: BreedsDAta.self, decoder: JSONDecoder())
            /// Erasing the publisher to return a generic AnyPublisher
            .eraseToAnyPublisher()
    }
}
