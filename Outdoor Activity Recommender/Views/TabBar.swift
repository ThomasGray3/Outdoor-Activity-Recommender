//
//  TabBar.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI

struct TabBar: View {
    
    @State var selectedTab = "explore"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FavouritesView()
                .tag("favourites")
                .tabItem {
                    if   selectedTab == "favourites" {
                        Image(systemName: "star.fill")
                    } else{
                        Image(systemName: "star")
                    }
                    Text("Favourites")
                }
                .onTapGesture {
                    selectedTab = "favourite"
                }
            MapView()
                .tag("explore")
                .tabItem {
                    if   selectedTab == "explore" {
                        Image(systemName: "map.fill")
                    } else{
                        Image(systemName: "map")
                    }
                    Text("Explore")
                }
                    .onTapGesture {
                        selectedTab = "favourite"
                }
            UserProfileView()
                .tag("profile")
                .tabItem {
                    if   selectedTab == "profile" {
                        Image(systemName: "person.fill")
                    } else{
                        Image(systemName: "person")
                    }
                    Text("Profile")
                }
                    .onTapGesture {
                        selectedTab = "profile"
                }
        }
        .font(.headline)
        .tabViewStyle(/*@START_MENU_TOKEN@*/DefaultTabViewStyle()/*@END_MENU_TOKEN@*/)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}