//
//  UsersViewController.swift
//  GitMotion
//
//  Created by Maciej Rutkowski on 09/06/2018.
//  Copyright © 2018 onFoot IT. All rights reserved.
//

import UIKit

private let UserCellIdentifier = "UserCell"

class UsersTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    unowned let viewModel: UsersViewModel

    required init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCellIdentifier) as! UserCell

        let userViewModel = viewModel.userViewModel(for: indexPath.row)
        cell.configure(with: userViewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showUser(at: indexPath.row)
    }
}

class UsersViewController: UITableViewController, UsersViewModelDelegate {
    private let viewModel: UsersViewModel
    private let adapter: UsersTableAdapter

    required init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        self.adapter = UsersTableAdapter(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "UserCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: UserCellIdentifier)
        tableView.dataSource = adapter
        tableView.delegate = adapter

        tableView.estimatedRowHeight = 56
        tableView.rowHeight = 56
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)

        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl

        viewModel.delegate = self
        viewModel.reload()
    }

    @objc func didRefresh(_ sender: UIRefreshControl) {
        viewModel.reload()
    }

    func willReload() {
        if let refreshControl = self.refreshControl, !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
    }

    func didReload() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}
