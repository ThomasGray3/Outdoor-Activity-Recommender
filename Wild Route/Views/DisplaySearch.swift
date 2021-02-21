//
//  SearchNearby.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 07/02/2021.
//
import SwiftUI
import Foundation

struct DisplaySearch: View {
    var places: [[Landmark]]
  //  var skiPlaces: [Result]
    var body: some View {
        Form {
            Section {
                if !places.isEmpty {
                    ForEach(0..<places.count, id: \.self) { place in
                        
                        HStack {
                            Text(places[place][0].type)
                                .fontWeight(.bold)
                                .padding()
                        }
                        .padding()
                        
                        ExDivider(color: changeBkColor(type: places[place][0].type))
                        
                        ForEach(self.places[place], id: \.id) { landmark in
                            // VStack(alignment: .leading) {
                            NavigationLink(
                                destination: ActivityCard(landmark: landmark),
                                label: {
                                    VStack(alignment: .leading) {
                                        Text(landmark.name)
                                            .fontWeight(.bold)
                                        
                                    //    Text(landmark.title)
                                      //      .fontWeight(.light)
                                    } .padding(.vertical)
                                }
                            )
                        }
                        ExDivider(color: changeBkColor(type: places[place][0].type))
                    }
                
               /* if !skiPlaces.isEmpty {
                    HStack {
                        Text("Ski Centres")
                            .fontWeight(.bold)
                            .padding()
                    }
                    .padding()
                    ExDivider(color: changeBkColor(type: "Ski Centres"))
                    ForEach(0..<skiPlaces.count, id: \.self ) { j in
                        NavigationLink(
                            destination: ActivityCard(),
                            label: {
                                VStack(alignment: .leading) {
                                    Text(skiPlaces[j].areaName[0].value)
                                        .fontWeight(.bold)
                                    
                                   // Text(skiPlaces[j].country[0].value)
                                   //     .fontWeight(.light)
                                } .padding(.vertical)
                            }
                        )
                    }
                    ExDivider(color: changeBkColor(type: "Ski Centres"))*/
                } else {
                    Text("There is nothing in your area :(")
                }
            }
        }
        .background(Color.clear)
        .onAppear(perform: {
            //    searchNearby()
            UITableView.appearance().backgroundColor = .clear
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
        else if(type == "Ski Centres")
        {
            return Color.white;
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
