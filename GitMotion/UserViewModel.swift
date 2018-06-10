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
    private let avatarSource = AvatarSource(urlSession: URLSession(configuration: .ephemeral))

    init(user: UserType) {
        self.user = user
    }

    var name: String {
        return user.username
    }

    func avatar(_ completion: @escaping (UIImage?, Error?) -> Void) {
        avatarSource.avatar(for: user) { (user, image, error) in
            completion(image, error)
        }
    }

    deinit {
        avatarSource.cancel(for: user)
    }
}
