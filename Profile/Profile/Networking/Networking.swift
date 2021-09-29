//
//  Networking.swift
//  Profile
//
//  Created by Ashish Tripathi on 9/9/21.
//

import Foundation
import Combine

enum Endpoint: String {
    case profile = "0de531f4-963c-4671-adb6-2c7b07ec9fdf"
}

class Networking {
    
    static let shared = Networking()
    
    private init() {}
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://run.mocky.io/v3/"
    
    
    func getData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            
            guard let self = self, let url = URL(string: self.baseURL.appending(endpoint.rawValue)) else {
                return promise(.failure(NetworkingError.invalidURL))
            }
            print("URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkingError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main) // RunLoop.main
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkingError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkingError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}


public enum NetworkingError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
