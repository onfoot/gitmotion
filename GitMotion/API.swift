//
//  API.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 09/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import Foundation

extension DailymotionUser: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let username = try container.decode(String.self, forKey: .username)
        let avatarURL = try? container.decode(URL.self, forKey: .avatarURL)

        self.avatarURL = avatarURL
        self.username = username
        self.identifier = "\(source).\(username)"
    }

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case avatarURL = "avatar_360_url"
    }
}

extension GithubUser: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let identifier = try container.decode(Int.self, forKey: .identifier)
        let username = try container.decode(String.self, forKey: .username)

        let avatarURL = try? container.decode(URL.self, forKey: .avatarURL)

        self.identifier = "\(source).\(identifier)"
        self.username = username
        self.avatarURL = avatarURL
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case username = "login"
        case avatarURL = "avatar_url"
    }
}

struct DailymotionResponse: Decodable {
    let users: [DailymotionUser]

    enum CodingKeys: String, CodingKey {
        case users = "list"
    }
}

typealias GithubResponse = Array<GithubUser>
