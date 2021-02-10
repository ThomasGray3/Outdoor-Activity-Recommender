//
//  MapView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//
import SwiftUI
import Combine
import Mapbox
import MapKit

struct iosMapView: View {
    
    @State  private var loaded = false
    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur
    @ObservedObject var locationManager = LocationManager()
    @State var userLatitude = 0.0
    @State var userLongitude = 0.0
    @State var annotations = [MGLPointAnnotation]()
    @State var places = [Landmark]()
    @ObservedObject var annotationsVM = AnnotationsVM()
    
    func getLocations() {
        userLatitude = locationManager.location?.coordinate.latitude ?? 0.0
        userLongitude = locationManager.location?.coordinate.longitude ?? 0.0
        LandmarkStruct().searchNearby(userLatitude: userLatitude, userLongitude: userLongitude, completion: { points in
            for loc in points {
                let annotation = MGLPointAnnotation()
                annotation.title = loc.name
                annotation.coordinate = loc.coordinate
                annotation.subtitle = loc.title
                annotations.append(annotation)
            }
            places = points
            annotationsVM.addNextAnnotation(annotation: annotations)
        })
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    MapView(annos: $annotationsVM.annos).zoomLevel(5).centerCoordinate(.init(latitude: userLatitude, longitude: userLongitude)).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!).edgesIgnoringSafeArea(.top)
                    VStack{
                        Spacer()
                        if loaded == false {
                            Button(action: {
                                getLocations()
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
                                        annotationsVM.deleteAnnos()
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
                                DisplaySearch(places: places)
                                //SkiResorts(lat: userLatitude, lon: userLongitude)
                            
                            }
                        }
                    }
                }
            }
            //.navigationBarTitleDisplayMode(.large)
            //.navigationTitle(Text("Explore"))
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
