//
//  UserCell.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 09/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!

    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var avatarLoadingIndicator: UIActivityIndicatorView!

    var viewModel: UserViewModel?

    func configure(with userViewModel: UserViewModel) {
        viewModel = userViewModel
        nameLabel.text = userViewModel.name
        sourceLabel.text = userViewModel.source

        avatarLoadingIndicator.startAnimating()
        userViewModel.avatar { [weak self] (image, error) in
            self?.avatarLoadingIndicator.stopAnimating()
            if let image = image {
                self?.avatarImageView.image = image
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil

        avatarImageView.image = nil
        avatarLoadingIndicator.stopAnimating()
    }
}
