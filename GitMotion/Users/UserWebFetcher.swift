//
//  UserWebFetcher.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 20/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import Foundation

private enum ApiURL: String {
    case github = "https://api.github.com/users"
    case dailymotion = "https://api.dailymotion.com/users?fields=avatar_360_url,username"
}

class UserWebFetcher: UserFetching {
    private let client = NetworkClient()

    func fetch(_ completion: @escaping ([UserType]?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in

            let semaphore = DispatchSemaphore(value: 0)

            var users = [UserType]()
            var error: Error? = nil

            let githubRequest = Request<GithubResponse>(url: ApiURL.github.rawValue)

            self?.client.send(githubRequest, success: { response, content in
                if let usersResponse = content {
                    users.append(contentsOf: usersResponse)
                }

                semaphore.signal()
            }) { err in
                error = err
                semaphore.signal()
            }

            let motionRequest = Request<DailymotionResponse>(url: ApiURL.dailymotion.rawValue)

            self?.client.send(motionRequest, success: { response, content in
                if let usersResponse = content?.users {
                    users.append(contentsOf: usersResponse)
                }

                semaphore.signal()
            }) { err in
                error = err
                semaphore.signal()
            }

            semaphore.wait()
            semaphore.wait()

            DispatchQueue.main.async {
                completion(users, error)
            }
        }

    }
}
