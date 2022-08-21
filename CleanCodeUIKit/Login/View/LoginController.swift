//
//  LoginController.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 18/08/22.
//

import UIKit
import DropDown
import RxCocoa
import RxSwift

final class LoginController: BaseController {
    
    private enum Keys: String {
        case appTitle = "Apna Taxi"
    }
    // MARK: IBOutlets
    @IBOutlet private weak var userNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var countryField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: Properties
    lazy private var dropDown = DropDown()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        navigationItem.title = Keys.appTitle.rawValue
        setupBindings()
        addKeypadListener()
    }
    
    func setupBindings() {
        userNameField
            .rx
            .text
            .bind(to: viewModel.username)
            .disposed(by: viewModel.disposeBag)
        
        passwordField
            .rx
            .text
            .bind(to: viewModel.password)
            .disposed(by: viewModel.disposeBag)
        
//        viewModel
//            .isValid
//            .bind(to: loginButton.rx.isEnabled)
//            .disposed(by: viewModel.disposeBag)
        
        viewModel.result
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case.success:
                    self?.showDashboard()
                case let .failure(error):
                    self?.showAlert(message: error.description)
                }
            }, onError: { error in
                self.showAlert(message: error.localizedDescription)
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: Protected methods
private extension LoginController{
    
    @IBAction func selectCountry(sender: UIButton) {
        dismissKeypad()
        showCountryPicker(sender)
    }
    
    @IBAction func loginAction() {
        dismissKeypad()
        loginRequest()
    }
    
    func loginRequest() {
        let requestData =  UserRequest(userName: viewModel.username.value ?? "",
                                       password: viewModel.password.value ?? "",
                                       country: viewModel.selectedCountry.value)
        viewModel.login(user: requestData)
    }
    
    func showDashboard() {
        
    }
}

extension LoginController {
    
    /// Show country list drop down
    private func showCountryPicker(_ sender: UIButton) {
        dropDown.anchorView = view
        dropDown.dataSource = viewModel.country
        dropDown.direction = .any
        dropDown.anchorView = sender
        dropDown.selectionAction = { [unowned self] (_, name: String) in
            countryField.text = name
            viewModel.selectedCountry.accept(name)
        }
        dropDown.show()
    }
}
