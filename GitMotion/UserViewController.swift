//
//  UserViewController.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 09/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarLoadingIndicator: UIActivityIndicatorView!

    let viewModel: UserViewModel

    required init(viewModel: UserViewModel) {

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = viewModel.name

        avatarLoadingIndicator.startAnimating()
        viewModel.avatar { [weak self] image, _ in
            self?.avatarLoadingIndicator.stopAnimating()
            if let image = image {
                self?.avatarImageView.image = image
            }
        }
    }
}
