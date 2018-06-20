//
//  UserViewModel.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 10/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import UIKit

class UserViewModel {
    private let user: UserType
    private let avatarFetcher: AvatarFetching

    init(user: UserType, avatarFetcher: AvatarFetching) {
        self.user = user
        self.avatarFetcher = avatarFetcher
    }

    var name: String {
        return user.username
    }

    var source: String {
        return user.source.rawValue
    }

    func avatar(_ completion: @escaping (UIImage?, Error?) -> Void) {
        avatarFetcher.avatar(for: user) { user, image, error in
            DispatchQueue.main.async {
                completion(image, error)
            }
        }
    }

    deinit {
        avatarFetcher.cancel(for: user)
    }
}
