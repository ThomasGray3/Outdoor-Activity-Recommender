//
//  Preferences.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 13/01/2021.
//

import SwiftUI


struct Preferences: View {
    
    var title : String
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var preference: FetchedResults<UserPreference>
    
    @State private var selectedAct = 0
    @State private var activities = ["Hiking", "Snowsports", "Surfing", "Kayaking", "Exploring", "Golf", "Tennis"]
    @State private var selectedScore = 0
    @State private var score = ["1","2","3","4","5"]
    @State private var visible = false
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section{
                        List {
                            ForEach(preference) { UserPreference in
                                HStack {
                                    Text("Activity type:  \(type().activityType(type: UserPreference.activity ?? "Untitled"))")
                                    Spacer()
                                    Text("Rank: \(Int(UserPreference.score))")
                                }
                            }  .onDelete(perform: deletePreference)
                        }
                    }
                    if preference.count < 3 {
                        Section(header: Text("Please select 3 of your preferred activies and give them a score ")) {
                            HStack {
                                Picker(selection: $selectedAct, label: Text("Select an activity")) {
                                    ForEach(0 ..< activities.count) {
                                        Text(self.activities[$0]).tag($0)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                .frame(width: UIScreen.main.bounds.width/3)
                                .clipped()
                                Spacer()
                                Picker(selection: $selectedScore, label: Text("Select a score")) {
                                    ForEach(0 ..< score.count) {
                                        Text(self.score[$0]).tag($0)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                .frame(width: UIScreen.main.bounds.width/3)
                                .clipped()
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    addPreference()
                                }) {
                                    Text("Add preference")
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text(title))
            .onAppear() {
                makeVisible()
            }
        }
    }
    func makeVisible() {
        visible = true
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
        newPreference.activity = type().reverseType(type: activities[selectedAct])
        newPreference.id = UUID()
        newPreference.score = Double(score[selectedScore]) ?? 0.0
        savePreference()
    }
}
