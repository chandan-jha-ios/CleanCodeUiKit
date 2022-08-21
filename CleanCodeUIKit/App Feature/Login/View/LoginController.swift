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
        case appTitle = "Taxi"
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var userNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var countryField: UITextField!
    
    @IBOutlet private weak var userNameErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var countryErrorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: Properties
    lazy private var dropDown = DropDown()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        createTestUser()
        setupDidload()
    }
    
    func setupDidload() {
        titleLabel.text = Keys.appTitle.rawValue
        headerView.backgroundColor = AppColor.activeButton.value
        setupBindings()
        showHideErrorLabels()
        addKeypadListener()
    }
    
    func createTestUser() {
        let password = Utility.convertMD5(value: "Taxi@123")
        let user = User(userName: "taxi",
                        password: password,
                        country: "India")
        if viewModel.manager.isRegistered(user: user) == false {
            viewModel.manager.create(user: user)
        }
    }
    
    @IBAction private func selectCountry(sender: UIButton) {
        dismissKeypad()
        showCountryPicker(sender)
    }
    
    @IBAction private func loginAction() {
        dismissKeypad()
        if viewModel.validateForm {
            loginRequest()
        } else {
            showErrors()
        }
    }
}

// MARK: Protected methods
private extension LoginController{
    
    func setupBindings() {
        userNameField.rx.text
            .bind(to: viewModel.username)
            .disposed(by: viewModel.disposeBag)
        passwordField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: viewModel.disposeBag)
        viewModel.isValid
            .subscribe(onNext: { [weak self] result in
                let backgroundColor = result ? AppColor.activeButton.value : AppColor.disabled.value
                if #available(iOS 15.0, *) {
                    self?.loginButton.configuration?.background.backgroundColor = backgroundColor
                } else {
                    self?.loginButton.backgroundColor = backgroundColor
                }
                self?.showHideErrorLabels()
            })
            .disposed(by: viewModel.disposeBag)
        viewModel.result
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.handleLogin(result)
            }, onError: { [weak self] error in
                self?.showAlert(message: error.localizedDescription)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    func handleLogin(_ result: LoginResult) {
        switch result {
        case.success:
            showDashboard()
        case let .failure(error):
            showAlert(message: error.description)
        }
    }
    
    func loginRequest() {
        let password = Utility.convertMD5(value: viewModel.password.value ?? "")
        let requestData =  User(userName: viewModel.username.value ?? "",
                                password: password,
                                country: viewModel.selectedCountry.value)
        viewModel.login(with: requestData)
    }
    
    func showErrors() {
        userNameErrorLabel.text = viewModel.nameFieldError
        passwordErrorLabel.text = viewModel.passwordFieldError
        countryErrorLabel.text = viewModel.countryFieldError
        showHideErrorLabels()
    }
    
    func showHideErrorLabels() {
        userNameErrorLabel.isHidden  = viewModel.nameFieldError.isEmpty
        passwordErrorLabel.isHidden = viewModel.passwordFieldError.isEmpty
        countryErrorLabel.isHidden = viewModel.countryFieldError.isEmpty
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
