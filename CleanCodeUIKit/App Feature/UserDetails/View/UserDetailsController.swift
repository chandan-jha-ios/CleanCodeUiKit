//
//  UserDetailsController.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 25/08/22.
//

import UIKit
import MapKit

final class UserDetailsController: BaseController {

    // MARK: Keys
    private enum Keys: String {
        case pageTitle = "User details"
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var mobileLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var websiteLabel: UILabel!
    @IBOutlet private(set) weak var mapView: MKMapView!
    
    private(set) var viewModel: UserDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func configure(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    class func loadController() -> UserDetailsController {
        UserDetailsController(nibName: UserDetailsController.name,
                              bundle: nil)
    }
}

private extension UserDetailsController {
    
    func setupUI() {
        title = Keys.pageTitle.rawValue
        guard let user = viewModel?.user else { return }
        updateBasicInformation(user)
        showUserPin()
    }
    
    func updateBasicInformation(_ user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        mobileLabel.text = user.phone
        addressLabel.text = user.formattedAddress
        websiteLabel.text = user.website
    }
}
