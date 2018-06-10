//
//  Model.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 05/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import Foundation

enum UserSource: String {
    case github, dailymotion
}

protocol UserType {
    var identifier: String { get }
    var username: String { get }
    var avatarURL: URL? { get }
    var source: UserSource { get }
}

struct DailymotionUser: UserType {
    let identifier: String
    let avatarURL: URL?
    let username: String

    let source: UserSource = .dailymotion
}

struct GithubUser: UserType {
    let identifier: String
    let avatarURL: URL?
    let username: String

    let source: UserSource = .github
}
