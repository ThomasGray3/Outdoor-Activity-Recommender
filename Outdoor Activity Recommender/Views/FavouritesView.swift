//
//  FavouritesView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI

struct FavouritesView: View {
    
    @State private var favs = ["item 1", "item 2", "item 3"]
    
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favs, id: \.self) { favs in
                    Text(favs)
                }
                .onDelete(perform: delete)
            }
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitle(Text("Favourites"))
        }
    }
    func delete(at offsets: IndexSet) {
           favs.remove(atOffsets: offsets)
       }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
