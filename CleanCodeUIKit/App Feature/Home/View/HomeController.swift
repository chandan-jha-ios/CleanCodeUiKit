//
//  HomeController.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 23/08/22.
//

import UIKit

final class HomeController: BaseController {
    
    // MARK: Keys
    private enum Keys: String {
        case pageTitle = "Taxi"
    }
    
    // MARK: IBOutlets
    @IBOutlet private(set) weak var tableView: UITableView! {
        didSet {
            registerCell()
        }
    }
    
    // MARK: Property
    private(set) var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Keys.pageTitle.rawValue
        showLogout()
        setupBinding()
        fetchData()
    }
    
    // MARK: Protected Methods
    private func setupBinding() {
        /// Manage loader activity show or hide
        viewModel.isLoading
            .skip(1)
            .subscribe(onNext: { [weak self] status in
                /// Hide loader if `status == false`
                self?.tableView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
        
        /// Show api network error message
        viewModel.networkError
            .skip(1)
            .subscribe(onNext: { [weak self] errorMessage in
                /// show alert if message is not empty
                if errorMessage.isEmpty == false {
                    self?.showAlert(message: errorMessage)
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func fetchData() {
        viewModel.fetchUsers()
    }
}

