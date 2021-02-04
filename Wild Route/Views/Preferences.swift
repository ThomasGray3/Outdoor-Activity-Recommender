//
//  Preferences.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 13/01/2021.
//

import SwiftUI


struct Preferences: View {
    var generes = ["Action","Adventure","Comedy","Drama","Horror","SciFi"]
    @State private var selectedGenere = 0
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var preference: FetchedResults<UserPreference>
    
    @State private var selectedAct = 0
    @State private var activities = ["Cycling", "Hiking", "Snowsports", "Surfing", "Kyaking"]
    @State private var visible = false
    
    
    var body: some View {
        NavigationView{
        VStack {
            Form {
                Section{
                    ForEach(preference) { UserPreference in
                        Text(UserPreference.activity ?? "Untitled")
                    }
                }
                Section(header: Text("Please select an activity")) {
                    Picker(selection: $selectedAct, label: Text("Select an activity")) {
                        ForEach(0 ..< activities.count) {
                            Text(self.activities[$0]).tag($0)
                        }
                    }.pickerStyle(WheelPickerStyle())
                    Button(action: {
                        addPreference()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .padding(6)
                            .frame(width: 40, height: 40)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                }
            }
        }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Welcome"))
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
        newPreference.activity = "\(activities[selectedAct])"
        newPreference.id = UUID()
        savePreference()
    }
}

struct Preferences_Previews: PreviewProvider {
    static var previews: some View {
        Preferences()
    }
}
