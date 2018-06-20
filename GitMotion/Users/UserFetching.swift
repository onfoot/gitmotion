//
//  UserFetching.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 20/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import Foundation

protocol UserFetching {
    func fetch(_ completion: @escaping ([UserType]?, Error?) -> Void)
}
