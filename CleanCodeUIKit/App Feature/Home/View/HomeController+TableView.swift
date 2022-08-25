//
//  HomeController+TableView.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 25/08/22.
//

import UIKit

// MARK: UITableViewDataSource
extension HomeController {
    func registerCell() {
        let nib = UINib(nibName: UserTableViewCell.name, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: UserTableViewCell.name)
    }
}

extension HomeController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.name, for: indexPath)
        
        if let userCell = cell as? UserTableViewCell,
           let user = viewModel.user(at: indexPath.row) {
            userCell.setupCell(with: user)
        }
        return cell
    }
    
}
