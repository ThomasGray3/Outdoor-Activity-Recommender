//
//  Outdoor_Activity_RecommenderApp.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI
import CoreData

@main
struct Outdoor_Activity_RecommenderApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if (isAppAlreadyLaunchedOnce() == true){
                TabBar()
                    .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
            } else {
                Preferences()
            }
        }
    }
}

func isAppAlreadyLaunchedOnce() -> Bool {
    let defaults = UserDefaults.standard
    if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
        print("App already launched")
        return true
    } else {
        defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        print("App launched first time")
        return false
    }
}
