//
//  SearchNearby.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 07/02/2021.
//
import SwiftUI
import Foundation
import Mapbox
import MapKit

struct SearchNearby: View {
    var lat: Double
    var lon: Double
    //@ObservedObject var locationManager = LocationManager()
    @State private var landmarks: [Landmark] = [Landmark]()
    @State private var search: String = "Mountains"
    //@ObservedObject var locationManager = LocationManager()
    
   private func searchNearby() {
        print(lat)
        print(lon)
    
    let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        request.region =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
            
                var mapItems = response.mapItems
                
                if mapItems.count > 5 {
                    mapItems = mapItems.dropLast(20)
                }
                self.landmarks = mapItems.map {
                   
                    return Landmark(placemark: $0.placemark)
                }
                for loc in landmarks{
                    var annotation = MGLPointAnnotation()
                    annotation.title = loc.title
                    annotation.coordinate = loc.coordinate
                    annotation.subtitle = loc.name
                   // AnnotationsVM(loc: annotation)
                    
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
        }
    }
    
    
    
    var body: some View {
        Form{
            Section {
                ForEach(self.landmarks, id: \.id) { landmark in
                    VStack(alignment: .leading) {
                        Text(landmark.name)
                            .fontWeight(.bold)
                        Text(landmark.title)
                        Text("\(landmark.id)")
                        Text("\(landmark.coordinate.latitude)")
                        Text("\(landmark.coordinate.longitude)")
                    }
                }
            }
            
        }
            .background(Color.clear)
            .onAppear(perform: {
                searchNearby()
                UITableView.appearance().backgroundColor = .clear
        })
    }
}

struct Landmark {
    
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
}

class locationStruct: ObservableObject {
    @Published var places = [Landmark]()
    var lat: Double
    var lon: Double
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        searchNearby(lat: lat, lon: lon)
    }
    
    private func searchNearby(lat: Double, lon: Double) {
         print(lat)
         print(lon)
     
     let request = MKLocalSearch.Request()
         request.naturalLanguageQuery = "Mountains"
         request.region =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
             
                 var mapItems = response.mapItems
                 
                 if mapItems.count > 5 {
                     mapItems = mapItems.dropLast(20)
                 }
                 self.places = mapItems.map {
                    
                     return Landmark(placemark: $0.placemark)
                 }
                /*for loc in landmarks{
                     var annotation = MGLPointAnnotation()
                     annotation.title = loc.title
                     annotation.coordinate = loc.coordinate
                     annotation.subtitle = loc.name
                    // AnnotationsVM(loc: annotation)
                     */
                 }
         }
}
