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
    var places: [[Landmark]]
    
    func printt() {
//        print(places[0][0].name)
    }
    
    var body: some View {
        Form {
            Section {
                
              
                ForEach(0..<places.count, id: \.self) { place in
                    
                    HStack {
                        Text(places[place][0].type)
                            .fontWeight(.bold)
                            .padding()
                        
                        
                        Image("\(places[place][0].type)")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 50, height: 50)
                    }
                    .padding()
                    //.listRowBackground(changeBkColor(type: places[place][0].type))
                    
                    ExDivider(color: changeBkColor(type: places[place][0].type))
                    
                    ForEach(self.places[place], id: \.id) { landmark in
                       // VStack(alignment: .leading) {
                            NavigationLink(
                                destination: ActivityCard(),
                                label: {
                                    VStack(alignment: .leading) {
                                        Text(landmark.name)
                                            .fontWeight(.bold)
                                           
                                        Text(landmark.title)
                                            .fontWeight(.light)
                                    } .padding(.vertical)
                                }
                            )
                        //}
                        //.listRowBackground(changeBkColor(type: places[place][0].type))
                    }
                    ExDivider(color: changeBkColor(type: places[place][0].type))
                } 
            }
        }
        .background(Color.clear)
        .onAppear(perform: {
            //    searchNearby()
            UITableView.appearance().backgroundColor = .clear
            printt()
        })
    }
    
    
    func changeBkColor(type: String) -> Color {
        if(type == "Mountains")
        {
            return Color.green;
        }
        else if(type == "Beaches")
        {
            return Color.blue;
        }
        else if(type == "National Parks")
        {
            return Color.orange;
        }
        return Color.white
    }
}

struct ExDivider: View {
    let color: Color
    let width: CGFloat = 2
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
