//
//  MapView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI
import Combine
import Mapbox

class ViewController: UIViewController, ObservableObject {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
    }
}



struct TaskEntry: Codable  {
    let id: Int
    let title: String
}

struct iosMapView: View {
    @State private var resultsold = [TaskEntry]()
    @State  private var loaded = false
    
    @ObservedObject var variable = ViewController()
    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur
    
    var body: some View {
        
        NavigationView {
            VStack{
                ZStack{
                    MapView().zoomLevel(5).centerCoordinate(.init(latitude: 51.507222, longitude: -0.1275)).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!)
                    VStack{
                        Spacer()
                        if loaded == false {
                            Button(action: {
                                loadData()
                            }) {
                                Text("Find Acitvities")
                                    .font(.system(size: 20, weight: .heavy, design: .default))
                            }
                            .buttonStyle(GradientButtonStyle())
                            .offset(x: 0.0, y: -20.0)
                        }
                    }
                    if loaded == true {
                        SlideOverCard($position, backgroundStyle: $background) {
                            VStack {
                                HStack {
                                    Text("Activities for you, near you...")
                                        .padding()
                                    Spacer()
                                    Button(action: {
                                           loaded = false
                                    }, label: {
                                    Image(systemName: "plus")
                                        .rotationEffect(.init(degrees: 45))
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.white)
                                    })
                                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                        .cornerRadius(38.5)
                                        .padding()
                                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                                    }
                                VStack {
                                    List {
                                        ForEach(resultsold, id: \.title) { res in
                                            Text(res.title)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Explore"))
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
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
    }
}


struct iosMapView_Previews: PreviewProvider {
    static var previews: some View {
        iosMapView()
    }
}
