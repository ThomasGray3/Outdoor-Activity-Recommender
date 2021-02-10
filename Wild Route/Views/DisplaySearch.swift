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

struct DisplaySearch: View {
    var places: [Landmark]
    
    var body: some View {
        Form{
            Section {
                ForEach(self.places, id: \.id) { landmark in
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
        //    searchNearby()
            UITableView.appearance().backgroundColor = .clear
        })
    }
}

