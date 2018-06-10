//
//  UsersRouter.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 10/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import UIKit

class UsersRouter {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showUsers() {
        let usersViewModel = UsersViewModel(router: self)
        let usersViewController = UsersViewController(viewModel: usersViewModel)
        usersViewController.title = "Users"
        navigationController.setViewControllers([usersViewController], animated: true)
    }

    func showUser(_ user: UserType) {
        let userViewModel = UserViewModel(user: user)
        let userViewController = UserViewController(viewModel: userViewModel)
        userViewController.title = userViewModel.name
        navigationController.show(userViewController, sender: nil)
    }
}
