//
//  ActivityCard.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 01/02/2021.
//

import SwiftUI
import Mapbox

struct ActivityCard: View {
    var landmark: Landmark
    @ObservedObject var annotationsVM = AnnotationsVM()
    @State var annotations = [MGLPointAnnotation]()
    
    func setUp() {
        let annotation = MGLPointAnnotation()
        annotation.title = landmark.name
        annotation.coordinate = landmark.coordinate
        annotation.subtitle = landmark.type
        annotations.append(annotation)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(landmark.name).font(.system(size: 40, weight: .heavy)).padding(.leading, 20)
                Spacer()
                Image(systemName: "heart").font(.system(size: 35)).padding(.trailing, 20)
            }
            MapView(annos: $annotations).zoomLevel(11).centerCoordinate(landmark.coordinate).userLoc(false).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!).frame(width: UIScreen.main.bounds.width, height: 250)
            Text("ratings here").padding(.leading, 20)
            Text("weather").padding(.leading, 20)
            WeatherView(lat: landmark.coordinate.latitude, lon: landmark.coordinate.longitude)
            Spacer()
        }.onAppear() {
            setUp()
        }
    }
}
