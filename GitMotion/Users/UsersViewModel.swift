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

class UsersViewModel {
    private let userFetcher: UserFetching
    private let avatarFetcher: AvatarFetching
    private let router: UsersRouter

    weak var delegate: UsersViewModelDelegate?

    private var users: [UserType] = []

    required init(router: UsersRouter, userFetcher: UserFetching, avatarFetcher: AvatarFetching) {
        self.router = router
        self.userFetcher = userFetcher
        self.avatarFetcher = avatarFetcher
    }

    func reload() {
        delegate?.willReload()

        userFetcher.fetch { [weak self] users, error in
            self?.users = users ?? []
            self?.delegate?.didReload()
        }
    }

    func numberOfUsers() -> Int {
        return users.count
    }

    func userViewModel(for user: UserType) -> UserViewModel {
        return UserViewModel(user: user, avatarFetcher: avatarFetcher)
    }

    func userViewModel(for index: Int) -> UserViewModel {
        let user = users[index]
        return UserViewModel(user: user, avatarFetcher: avatarFetcher)
    }

    func showUser(at index: Int) {
        let user = users[index]
        self.router.showUser(user, parent: self)
    }
}
