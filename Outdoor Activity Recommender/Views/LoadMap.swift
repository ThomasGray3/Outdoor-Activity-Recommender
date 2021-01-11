//
//  LoadMap.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 07/01/2021.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

struct LoadMap: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var cancellable: AnyCancellable?
    @State private var userRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var baseRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))

    private func setCurrentLocation() {
        cancellable = locationManager.$lastLocation.sink { lastLocation in
            userRegion = MKCoordinateRegion(center: lastLocation?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
            
        }
    }
    
    var body: some View {
        
        if locationManager.lastLocation != nil {
            Map(coordinateRegion: $userRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil).onAppear {
                setCurrentLocation()
            }
        } else {
           Map(coordinateRegion: $baseRegion)
            
        }
    }
}

struct LoadMap_Previews: PreviewProvider {
    static var previews: some View {
        LoadMap()
    }
}
