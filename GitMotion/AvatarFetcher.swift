//
//  AvatarSource.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 10/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import UIKit

private extension UserType {
    var avatarFilename: String {
        return "\(identifier).png"
    }
}

class AvatarCorruptedError: Error {}
class NoAvatarError: Error {}

class AvatarSource: NSObject {
    typealias CompletionHandler = (_ user: UserType, _ image: UIImage?, _ error: Error?) -> Void

    private var avatarTasks: [String: (user: UserType, task: URLSessionTask)] = [:]
    private var completions: [String: [CompletionHandler]] = [:]

    private lazy var cacheURL: URL = {
        var cacheURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!)
        cacheURL.appendPathComponent("avatars")

        try? FileManager.default.createDirectory(at: cacheURL, withIntermediateDirectories: true, attributes: nil)

        return cacheURL
    }()

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    private func fetchAvatar(for user: UserType) {

        guard let avatarURL = user.avatarURL else { return }

        let task = urlSession.dataTask(with: avatarURL) { [weak self] data, response, error in

            var image: UIImage? = nil

            if let data = data {
                image = UIImage(data: data, scale: UIScreen.main.scale)

                if let strongSelf = self, let image = image {
                    let avatarURL = strongSelf.cacheURL.appendingPathComponent(user.avatarFilename)

                    let pngData = UIImagePNGRepresentation(image)
                    try? pngData?.write(to: avatarURL)
                }
            }

            let completions = self?.completions.removeValue(forKey: user.identifier)

            if let (user, _) = self?.avatarTasks.removeValue(forKey: user.identifier) {
                DispatchQueue.main.async {
                    completions?.forEach({ completion in
                        completion(user, image, error)
                    })
                }
            }
        }

        avatarTasks[user.identifier] = (user, task)

        task.resume()
    }

    func avatar(for user: UserType, completion: @escaping CompletionHandler) {
        guard user.avatarURL != nil else {
            DispatchQueue.main.async {
                completion(user, nil, NoAvatarError())
            }
            return
        }

        let avatarURL = cacheURL.appendingPathComponent(user.avatarFilename)

        if FileManager.default.fileExists(atPath: avatarURL.path) {
            DispatchQueue.global(qos: .userInteractive).async {
                if let image = UIImage(contentsOfFile: avatarURL.path) {
                    DispatchQueue.main.async {
                        completion(user, image, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.completions.removeValue(forKey: user.identifier)?.forEach({ handler in
                            handler(user, nil, AvatarCorruptedError())
                        })
                    }
                }
            }
            return
        }

        guard avatarTasks[user.identifier] == nil else {
            completions[user.identifier]?.append(completion)
            return
        }

        completions[user.identifier] = [completion]
        fetchAvatar(for: user)
    }

    func cancel(for user: UserType) {
        completions.removeValue(forKey: user.identifier)
        avatarTasks.removeValue(forKey: user.identifier)?.task.cancel()
    }
}
