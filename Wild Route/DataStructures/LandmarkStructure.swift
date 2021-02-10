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
    
    var type: String
}

class LandmarkStruct: ObservableObject {
    
    func searchNearby(userLatitude: Double, userLongitude: Double, type: String, completion: @escaping ([Landmark])->()) {
        
        
        
        var places = [Landmark]()
        let request = MKLocalSearch.Request()
        //print("search req \(searchArray[counter])")
        request.naturalLanguageQuery = type
        request.region =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            search.cancel()
            var mapItems = response.mapItems
            
            if mapItems.count > 5 {
                mapItems = mapItems.dropLast(mapItems.count-5)
            }
            places = mapItems.map {
                return Landmark(placemark: $0.placemark, type: type)
            }
            completion(places)
            
        }
    }
}
