//
//  Persistence.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 13/01/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "PreferencesData")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error  \(error)")
            }
            
        }
    }
}
