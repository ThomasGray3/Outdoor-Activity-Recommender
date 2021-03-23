//
//  SwiftUIView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI

struct UserProfileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var preference: FetchedResults<UserPreference>
    
    var body: some View {
       
            Preferences(title: "Profile")
        
    }
}
