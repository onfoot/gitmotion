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

    var viewModel: UserViewModel?

    func configure(with userViewModel: UserViewModel) {
        viewModel = userViewModel
        nameLabel.text = userViewModel.name
        sourceLabel.text = userViewModel.source

        userViewModel.avatar { [weak self] (image, error) in
            if let image = image {
                self?.avatarImageView.image = image
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil

        avatarImageView.image = nil
    }
}
