//
//  SearchNearby.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 07/02/2021.
//
import SwiftUI
import Foundation

struct DisplaySearch: View {
    var places: [[LandmarkDB]]
    
    var body: some View {
        Form {
            Section {
                if !places.isEmpty {
                    ForEach(0..<places.count, id: \.self) { place in
                        VStack {
                            ExDivider(color: changeBkColor(type: places[place][0].type))
                            Text(type().activityType(type: places[place][0].type))
                                .fontWeight(.bold)
                                .padding()
                            ExDivider(color: changeBkColor(type: places[place][0].type))
                        }
                        .padding(.vertical)
                        ForEach(self.places[place], id: \.name) { landmark in
                            NavigationLink(
                                destination: ActivityCard(landmark: landmark),
                                label: {
                                    VStack(alignment: .leading) {
                                        Text(landmark.name)
                                            .fontWeight(.bold)
                                    } .padding(.vertical)
                                }
                            )
                        }
                    }
                } else {
                    Text("There is nothing in your area :(")
                }
            }
        }
        .background(Color.clear)
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
        })
    }
    
    func changeBkColor(type: String) -> Color {
        if(type == "Mountain")
        {
            return Color.green;
        }
        else if(type == "Beaches")
        {
            return Color(UIColor(red: 99/255, green: 225/255, blue: 242/255, alpha: 1.0).cgColor);
        }
        else if(type == "National Parks")
        {
            return Color.orange;
        }
        else if(type == "Ski Resort")
        {
            return Color(UIColor.lightGray);
        }
        else if(type == "Kayaking")
        {
            return Color(UIColor(red: 16/255, green: 0/255, blue: 249/255, alpha: 1.0))
        } else {
            return Color.white
        }
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


class type: ObservableObject {
    
    func activityType(type: String) -> String {
        if(type == "Mountain")
        {
            return "Hiking";
        }
        else if(type == "Beaches")
        {
            return "Surfing";
        }
        else if(type == "National Parks")
        {
            return "Outdoor Exploring";
        }
        else if(type == "Ski Resort")
        {
            return "Snowsports";
        }
        else if(type == "Kayaking")
        {
            return "Kayaking";
        }
        return "Miscellaneous"
    }
    
    func changeBkColor(type: String) -> Color {
        if(type == "Mountain")
        {
            return Color.green;
        }
        else if(type == "Beaches")
        {
            return Color(UIColor(red: 99/255, green: 225/255, blue: 242/255, alpha: 1.0).cgColor);
        }
        else if(type == "National Parks")
        {
            return Color.orange;
        }
        else if(type == "Ski Resort")
        {
            return Color(UIColor.lightGray);
        }
        else if(type == "Kayaking")
        {
            return Color(UIColor(red: 16/255, green: 0/255, blue: 249/255, alpha: 1.0))
        } else {
            return Color.white
        }
    }
}
