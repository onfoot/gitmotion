//
//  StartViewController.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 10/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navigationController = self.navigationController {
            let router = UsersRouter(navigationController: navigationController)
            router.showUsers()
        }
    }
}
