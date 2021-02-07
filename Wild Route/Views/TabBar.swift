//
//  TabBar.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI
//import FirebaseAuth

struct TabBar: View {
    
    @State var selectedTab = "explore"
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var preference: FetchedResults<UserPreference>
    @State var emptyCoreData = true
    
    
    func checkData() {
        if (preference.isEmpty) {
            emptyCoreData = true
        } else {
            emptyCoreData = false
        }
    }
    
   
    
    var body: some View {
        VStack {
            if (emptyCoreData) {
                    VStack {
                        Preferences()
                        Button(action: {
                            checkData()
                        }) {
                            Text("Next")
                                .font(.system(size: 20, weight: .heavy, design: .default))
                        }
                        .buttonStyle(GradientButtonStyle())
                    }
            } else {
                TabView(selection: $selectedTab) {
                    iosMapView()
                        .tag("explore")
                        .tabItem {
                            if (selectedTab == "explore") {
                                Image(systemName: "map.fill")
                            } else{
                                Image(systemName: "map")
                            }
                            Text("Explore")
                        }
                    
                    FavouritesView()
                        .tag("favourites")
                        .tabItem {
                            if (selectedTab == "favourites") {
                                Image(systemName: "heart.fill")
                            } else{
                                Image(systemName: "heart")
                            }
                            Text("Favourites")
                        }
                       
                    RatingsView()
                        .tag("ratings")
                        .tabItem {
                            if (selectedTab == "ratings") {
                                Image(systemName: "star.fill")
                            } else{
                                Image(systemName: "star")
                            }
                            Text("Ratings")
                        }
                        
                    UserProfileView()
                        .tag("profile")
                        .tabItem {
                            if (selectedTab == "profile") {
                                Image(systemName: "person.fill")
                            } else{
                                Image(systemName: "person")
                            }
                            Text("Profile")
                        }
                }
                .font(.headline)
                .tabViewStyle(/*@START_MENU_TOKEN@*/DefaultTabViewStyle()/*@END_MENU_TOKEN@*/)
            }
        }.onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        .onAppear(perform: {
            checkData()
        })
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
