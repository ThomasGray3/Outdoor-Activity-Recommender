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
        NavigationView {
            List {
                ForEach(preference) { UserPreference in
                    Text(UserPreference.activity ?? "Untitled")
                    
                }  .onDelete(perform: deletePreference)
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Profile"))
            .navigationBarItems(trailing: Button("Add preference") {
                addPreference()
            })
        }
    }
    
    private func savePreference() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            print("Error could not save  \(error)")
        }
    }
    
    private func deletePreference(at offsets: IndexSet) {
        offsets.map { preference[$0] }.forEach(viewContext.delete)
        savePreference()
    }
    
   private func addPreference() {
        let newPreference = UserPreference(context: viewContext)
        newPreference.activity = "New Activity"
        newPreference.id = UUID()
        savePreference()
    }
}



struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
