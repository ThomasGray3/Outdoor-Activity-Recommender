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
    
    func searchNearby(userLatitude: Double, userLongitude: Double, completion: @escaping ([[Landmark]])->()) {
        
       
        var placesArray = [[Landmark]]()
        var searchArray = [String]()
        searchArray = ["Mountains", "National Parks", "Beaches"]
        for counter in 0..<searchArray.count {
            var places = [Landmark]()
            let request = MKLocalSearch.Request()
            //print("search req \(searchArray[counter])")
            request.naturalLanguageQuery = searchArray[counter]
            request.region =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            let search = MKLocalSearch(request: request)
            
            search.start { (response, error) in
                if let response = response {
                   
                    var mapItems = response.mapItems
                    
                    if mapItems.count > 5 {
                        mapItems = mapItems.dropLast(mapItems.count-5)
                    }
                    places = mapItems.map {
                        return Landmark(placemark: $0.placemark, type: searchArray[counter])
                    }
                    
                    placesArray.append(places)
                    if counter == searchArray.count - 1 {
                        completion(placesArray)
                    }
                }
            }
        }
    }
}
