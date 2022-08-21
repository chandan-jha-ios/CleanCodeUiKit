//
//  CDUser+CoreDataProperties.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var country: String?

    func transformToUser() -> User {
       User(userName: username ?? "", password: password ?? "", country: country ?? "")
    }
}
