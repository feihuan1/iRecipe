//
//  File.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/9/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "RecipeContainer")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                print("CoredataManager failed loading at init: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save () {
        do {
            try context.save()
            print("CoreData manager save func worked")
        } catch let error {
            print("Coredata Manager save func error : \(error.localizedDescription)")
        }
    }
}
