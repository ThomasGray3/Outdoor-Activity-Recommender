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
import Drawer

struct iosMapView: View {
    
    @State  private var clicked = false
    @State  private var loaded = false
    @State private var position = CardPosition.middle
    @State private var background = BackgroundStyle.blur
    @ObservedObject var locationManager = LocationManager()
    @State var userLatitude = 0.0
    @State var userLongitude = 0.0
    @State var annotations = [MGLPointAnnotation]()
    @State private var places = [[Landmark]]()
    @ObservedObject var annotationsVM = AnnotationsVM()
    @State var serialQueue = DispatchQueue(label: "load")
    
    func getLocations() {
        userLatitude = locationManager.location?.coordinate.latitude ?? 0.0
        userLongitude = locationManager.location?.coordinate.longitude ?? 0.0
       // places.removeAll()
       // annotations.removeAll()
        let searchType = ["Mountains", "National Parks", "Beaches"]
        for n in 0..<searchType.count {
            LandmarkStruct().searchNearby(userLatitude: userLatitude, userLongitude: userLongitude, type: searchType[n], completion: { points in
                places.append(points)
                for location in points {
                    let annotation = MGLPointAnnotation()
                    annotation.title = location.name
                    annotation.coordinate = location.coordinate
                    annotation.subtitle = location.title
                    annotations.append(annotation)
                }
                annotationsVM.addNextAnnotation(annotation: annotations)
            })
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    MapView(annos: $annotationsVM.annos).zoomLevel(5).centerCoordinate(.init(latitude: userLatitude, longitude: userLongitude)).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!).edgesIgnoringSafeArea(.top)
                    VStack{
                        Spacer()
                        if clicked == false {
                            Button(action: {
                                clicked = true
                                getLocations()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    loaded = true
                                }
                            }) {
                                Text("Find Acitvities")
                                    .font(.system(size: 20, weight: .heavy, design: .default))
                            }
                            .buttonStyle(GradientButtonStyle())
                            .offset(x: 0.0, y: -20.0)
                        }
                    }
                    if clicked == true {
                        
                        
                        SlideOverCard($position, backgroundStyle: $background) {
                            VStack {
                                HStack {
                                    Text("Activities for you, near you...")
                                        .padding()
                                    Spacer()
                                    Button(action: {
                                        clicked = false
                                        annotationsVM.deleteAnnos()
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
                                if loaded == true {
                                    
                                    DisplaySearch(places: places)
                                } else if loaded == false {
                                    loadAnnimation().padding()
                                }
                                // SkiResorts(lat: userLatitude, lon: userLongitude)
                            }
                        }.onDisappear(perform: {
                            clicked = false
                            annotationsVM.deleteAnnos()
                            places.removeAll()
                            loaded = false
                        })
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

struct loadAnnimation: View {
    
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            
            Text("Loading...")
                .font(.system(.body, design: .rounded))
                .bold()
                .offset(x: 0, y: -25)
            
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color(.systemGray5), lineWidth: 3)
                .frame(width: 250, height: 3)
            
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.green, lineWidth: 3)
                .frame(width: 30, height: 3)
                .offset(x: isLoading ? 110 : -110, y: 0)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear() {
            self.isLoading = true
        }
    }
}
