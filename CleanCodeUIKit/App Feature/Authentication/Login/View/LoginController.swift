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
        case pageTitle = "Taxi"
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
        super.viewDidLoad()
        addKeypadListener()
        createTestUser()
        setupDidload()
    }

    class func loadController() -> LoginController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: LoginController.name) as? LoginController
        return controller
    }
}
    
    // MARK: Protected methods
private extension LoginController {
    
    @IBAction func selectCountry(sender: UIButton) {
        dismissKeypad()
        showCountryPicker(sender)
    }
    
    @IBAction func loginAction() {
        dismissKeypad()
        if viewModel.validateForm {
            loginRequest()
        } else {
            showErrors()
        }
    }

    func setupDidload() {
        titleLabel.text = Keys.pageTitle.rawValue
        headerView.backgroundColor = AppColor.activeButton.value
        setupBindings()
        showHideErrorLabels()
        addKeypadListener()
    }
    
    func createTestUser() {
        let password = Utility.convertMD5(value: "Taxi@123")
        let user = LoginRequest(userName: "taxi",
                                password: password,
                                country: "India")
        if viewModel.manager.isRegistered(user: user).0 == false {
            viewModel.manager.create(user: user)
        }
    }
    
    func setupBindings() {
        bindFields()
        bindDataValidation()
        bindLoginResponse()
    }
    
    func bindFields() {
        userNameField.rx.text
            .bind(to: viewModel.username)
            .disposed(by: viewModel.disposeBag)
        passwordField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: viewModel.disposeBag)
    }
    
    func bindDataValidation() {
        viewModel.isValid
            .subscribe(onNext: { [weak self] result in
                self?.updateLoginBtn(state: result)
            })
            .disposed(by: viewModel.disposeBag)
        viewModel.username
            .subscribe(onNext: { [weak self] value in
                if value?.isEmpty == false {
                    self?.userNameErrorLabel.isHidden = true
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.password
            .subscribe(onNext: { [weak self] value in
                if value?.isEmpty == false {
                    self?.passwordErrorLabel.isHidden = true
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    func updateLoginBtn(state: Bool) {
        let backgroundColor = state ? AppColor.activeButton.value : AppColor.disabled.value
        if #available(iOS 15.0, *) {
            loginButton.configuration?.background.backgroundColor = backgroundColor
        } else {
            loginButton.backgroundColor = backgroundColor
        }
    }
    
    func bindLoginResponse() {
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
        let requestData =  LoginRequest(userName: viewModel.username.value ?? "",
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
        (UIApplication.shared.delegate as? AppDelegate)?.showHomeOrLogin()
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
