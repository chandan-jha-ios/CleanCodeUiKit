//
//  HomeController.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 23/08/22.
//

import UIKit

final class HomeController: BaseController {

    private enum Keys: String {
        case pageTitle = "Taxi"
    }
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Keys.pageTitle.rawValue
        showLogout()
        setupBinding()
        fetchData()
    }
    
    func setupBinding() {
        /// Manage loader activity show or hide
        viewModel.isLoading
            .skip(1)
            .subscribe(onNext: { [weak self] status in
                /// Hide loader if `status == false`
                print(self?.viewModel.users?.count ?? -1)
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
    
    func fetchData() {
        viewModel.fetchUsers()
    }

}

