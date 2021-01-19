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
                TabBar()
                    .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
