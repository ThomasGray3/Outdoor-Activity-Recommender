//
//  TabBar.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//
import SwiftUI

struct TabBar: View {
    
    @State var selectedTab: Tabs = .explore
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
                    Preferences(title: "Welcome")
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
                            .tag(Tabs.explore)
                            .tabItem {
                                if (selectedTab == Tabs.explore) {
                                    Image(systemName: "map.fill")
                                } else{
                                    Image(systemName: "map")
                                }
                                Text("Explore")
                            }
                        FavouritesView()
                            .tag(Tabs.fav)
                            .tabItem {
                                if (selectedTab == Tabs.fav) {
                                    Image(systemName: "heart.fill")
                                } else{
                                    Image(systemName: "heart")
                                }
                                Text("Favourites")
                            }
                        RatingsView()
                            .tag(Tabs.ratings)
                            .tabItem {
                                if (selectedTab == Tabs.ratings) {
                                    Image(systemName: "star.fill")
                                } else{
                                    Image(systemName: "star")
                                }
                                Text("Ratings")
                            }
                        UserProfileView()
                            .tag(Tabs.profile)
                            .tabItem {
                                if (selectedTab == Tabs.profile) {
                                    Image(systemName: "person.fill")
                                } else{
                                    Image(systemName: "person")
                                }
                                Text("Profile")
                            }
                    }
                    .tabViewStyle(/*@START_MENU_TOKEN@*/DefaultTabViewStyle()/*@END_MENU_TOKEN@*/)
                
            }
        }
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }.onAppear(perform: {
            checkData()
        })
    }
    
    enum Tabs {
        case explore, fav, ratings, profile
    }
}
