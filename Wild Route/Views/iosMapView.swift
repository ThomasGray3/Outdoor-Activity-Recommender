//
//  MapView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//
import SwiftUI
import Combine
import Mapbox

struct iosMapView: View {
    
    @State  private var loaded = false
    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur
    @ObservedObject var locationManager = LocationManager()
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    var body: some View {
        
        NavigationView {
            VStack{
                ZStack{
                    MapView().zoomLevel(5).centerCoordinate(.init(latitude: userLatitude, longitude: userLongitude)).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!)
                    VStack{
                        Spacer()
                        if loaded == false {
                            Button(action: {
                                loaded = true
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
                                SkiResorts(lat: userLatitude, lon: userLongitude)
                            
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Explore"))
        }
    }
}

/*func loadData() {
 guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
 print("Invalid URL")
 return
 }
 let request = URLRequest(url: url)
 
 URLSession.shared.dataTask(with: request) { data, response, error in
 if let data = data {
 if let response = try? JSONDecoder().decode([SearchAPI].self, from: data) {
 DispatchQueue.main.async {
 print(response)
 loaded = true
 self.resultsold = response
 }
 return
 } else {
 print("broken \(response)")
 }
 } else {
 print("nothing")
 }
 }.resume()
 } */

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
