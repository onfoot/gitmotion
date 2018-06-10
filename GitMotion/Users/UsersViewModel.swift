//
//  UserSource.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 09/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import Foundation

protocol UsersViewModelDelegate: class {
    func willReload()
    func didReload()
}

enum ApiURL: String {
    case github = "https://api.github.com/users"
    case dailymotion = "https://api.dailymotion.com/users?fields=avatar_360_url,username"
}

class UsersViewModel {

    private let client = NetworkClient()
    private let router: UsersRouter

    weak var delegate: UsersViewModelDelegate?

    private var users: [UserType] = []

    required init(router: UsersRouter) {
        self.router = router
    }

    func reload() {
        delegate?.willReload()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in

            let semaphore = DispatchSemaphore(value: 0)

            var users = [UserType]()

            let githubRequest = Request<GithubResponse>(url: ApiURL.github.rawValue)

            self?.client.send(githubRequest, success: { response, content in
                if let usersResponse = content {
                    users.append(contentsOf: usersResponse)
                }

                semaphore.signal()
            }) { _ in
                semaphore.signal()
            }

            let motionRequest = Request<DailymotionResponse>(url: ApiURL.dailymotion.rawValue)

            self?.client.send(motionRequest, success: { response, content in
                if let usersResponse = content?.users {
                    users.append(contentsOf: usersResponse)
                }

                semaphore.signal()
            }) { _ in
                semaphore.signal()
            }

            semaphore.wait()
            semaphore.wait()

            DispatchQueue.main.async {
                self?.users = users
                self?.delegate?.didReload()
            }
        }
    }

    func numberOfUsers() -> Int {
        return users.count
    }

    func userViewModel(for index: Int) -> UserViewModel {
        let user = users[index]
        return UserViewModel(user: user)
    }

    func showUser(at index: Int) {
        let user = users[index]
        self.router.showUser(user)
    }
}
