//
//  LandmarkStructure.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 10/02/2021.
//

import Foundation
import MapKit

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

class LandmarkStruct: ObservableObject {
    
    func searchNearby(userLatitude: Double, userLongitude: Double, completion: @escaping ([Landmark])->()) {
       
        var places = [Landmark]()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Cafe"
        request.region =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if let response = response {
                
                var mapItems = response.mapItems
                
                if mapItems.count > 5 {
                    mapItems = mapItems.dropLast(20)
                }
                
                places = mapItems.map {
                    return Landmark(placemark: $0.placemark)
                }
               
                completion(places)
            }
        }
    }
}
