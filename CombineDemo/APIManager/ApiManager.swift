//
//  NetworkManager.swift
//  CombineDemo
//
//  Created by Purplle on 07/03/22.
//

import Foundation
import Combine


enum Endpoint: String {
    case albums
    case posts
}
class ApiManager {
    
    static let shared = ApiManager()
    private init() {
        
    }
    private let baseURL = "https://jsonplaceholder.typicode.com/"

    
    private var cancellables = Set<AnyCancellable>()
    
    func getAlbums<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<[T], Error> {

        // Return Future publisher
        // Produces a single value and then finishes or fails.
        // It is invoke in the future, when an element or error is available.
        //Based on promise:  The promise closure receives one parameter: a `Result` that contains either a single element published by a ``Future``, or an error.
        return Future<[T], Error> { [weak self] promise in

            //In case of Invalid url, promise to return failure error
            guard let self = self, let url = URL(string: self.baseURL.appending(endpoint.rawValue)) else {
                return promise(.failure(NetworkError.invalidURL))
            }

            //func dataTaskPublisher(for request: URLRequest)
            //func dataTaskPublisher(for url: URL)
            //An extension of combine framework inside URLSession
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }

                .decode(type: [T].self, decoder: JSONDecoder()) // decode the response with respective model
                .receive(on: RunLoop.main) // Allow to access the data in the Main thread

                // Subscriber
                // Get it data from publisher
                // Sink has two parameter receiveCompletion and receiveValue
                // receiveCompletion: basically tell us that the operation is completed or not
                // receiveValue: get it value
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                 
                }, receiveValue: { promise(.success($0)) })

                // Manage the memory managemnt
                .store(in: &self.cancellables)
        }
    }
    
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}
