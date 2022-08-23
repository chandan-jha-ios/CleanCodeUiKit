//
//  Persistence.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//

import CoreData

final class Persistence {
    static let shared = Persistence()
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CleanCodeUIKit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchManageObject<T: NSManagedObject>(object: T.Type) -> [T]? {
        do {
            let result = try context.fetch(object.fetchRequest()) as? [T]
            return result
        } catch let error {
            Utility.log(error.localizedDescription)
        }
        return nil
    }
}
