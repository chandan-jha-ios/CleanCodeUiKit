//
//  UserTableViewCell.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 23/08/22.
//

import UIKit

final class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var mobileLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var websiteLabel: UILabel!
    
    func setupCell(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        mobileLabel.text = user.phone
        addressLabel.text = user.formattedAddress
        websiteLabel.text = user.website
    }
    
}
