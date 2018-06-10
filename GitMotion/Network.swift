//
//  Network.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 09/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import Foundation

struct Response {
    let status: Int
}

enum RequestErrorType {
    case badURL, nonHttpResponse
}

struct RequestError: Error {
    let type: RequestErrorType
}

struct NetworkError: Error {
    let status: Int
}

struct Request<T: Decodable> {
    let url: String
}

class NetworkClient {
    let queue: DispatchQueue

    init(callbackQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)) {
        self.queue = callbackQueue
    }

    private let APISession = URLSession(configuration: URLSessionConfiguration.ephemeral)

    func send<T: Decodable>(_ request: Request<T>,
                            success: @escaping (Response, T?) -> Void,
                            failure: @escaping (Error) -> Void) {

        guard let url = URL(string: request.url) else {
            failure(RequestError(type: .badURL))
            return
        }

        let urlRequest = URLRequest(url: url)

        let task = APISession.dataTask(with: urlRequest) { (data, response, error) in

            /// Unlikely, but still, let's check.
            guard let httpResponse = response as? HTTPURLResponse else {
                self.queue.async {
                    failure(RequestError(type: .nonHttpResponse))
                }
                return
            }

            /// Is it a 2xx or 3xx response?
            guard httpResponse.statusCode < 400 else {
                self.queue.async {
                    failure(NetworkError(status: httpResponse.statusCode))
                }
                return
            }

            /// Did we receive any content? It might have been a `201 No Content` one.
            /// In this case don't even try to decode the response, since we will get a decode error.
            guard let data = data, data.count > 0 else {
                self.queue.async {
                    success(Response(status: httpResponse.statusCode), nil)
                }
                return
            }

            /// Let's decode it. Fingers crossed!
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                self.queue.async {
                    success(Response(status: httpResponse.statusCode), decoded)
                }
            } catch let err {
                self.queue.async {
                    failure(err)
                }
            }
        }

        task.resume()
    }
}
