//
//  MapView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI
import Combine

struct TaskEntry: Codable  {
    let id: Int
    let title: String
}

struct MapView: View {
    @State private var resultsold = [TaskEntry]()
    @State  private var loaded = false
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    LoadMap()
                    if loaded == true {
                        List {
                            ForEach(resultsold, id: \.title) { res in
                                Text(res.title)
                            }
                        }
                    }
                }.navigationBarTitle(Text("Explore"))
            } 
            Button(action: {
                loadData()
            }) {
                Text("Find Acitvities")
                    .font(.system(size: 20, weight: .heavy, design: .default))
            }
            .buttonStyle(GradientButtonStyle())
            .offset(x: 0, y: -50.0)
        }
    }
    
    
    func loadData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([TaskEntry].self, from: data) {
                    DispatchQueue.main.async {
                        print(response)
                        loaded = true
                        self.resultsold = response
                    }
                    return
                }
            }
            print("nothing")
        }.resume()
    }
    
    func loadDataNEW() {
        // Create URL
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")
        
        guard let requestUrl = url else {
            print("Invalid URL")
            return
        }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            // Using parseJSON() function to convert data to Swift struct
            let todoItem = parseJSON(data: data)
            
            // Read todo item title
            guard let todoItemModel = todoItem else { return }
            print("Todo item title = \(todoItemModel.title)")
            
        }
        task.resume()
    }
    
    
    func parseJSON(data: Data) -> TaskEntry? {
        
        var returnValue: TaskEntry?
        do {
            returnValue = try JSONDecoder().decode(TaskEntry.self, from: data)
        } catch {
            print("Error took place\(error.localizedDescription).")
        }
        
        return returnValue
    }
}



struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
