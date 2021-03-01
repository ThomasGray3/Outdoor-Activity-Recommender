//
//  FavouritesView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI

struct FavouritesView: View {
    
    @State var favourite = RatingStructure()
    @State var favs = [Favourite]()
    @State var landmark = LandmarkDB(name: "", description: "", latitude: 0.0, longitude: 0.0, type: "")
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favs) { favs in
                    NavigationLink(
                        destination:
                            ActivityCard(landmark: landmark, name: favs.location)
                    ){
                            Text(favs.location)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: EditButton())
            .navigationTitle(Text("Favourites"))
        }.onAppear {
            favourite.loadFavs() { (favos) in
                favs = favos
            }
        }
    }
    func delete(offsets: IndexSet) {
        guard let index = Array(offsets).first else { return }
        let f = favs[index]
        favourite.removeFavourite(fav: f) { (Bool) in
            return
        }
    }
}
