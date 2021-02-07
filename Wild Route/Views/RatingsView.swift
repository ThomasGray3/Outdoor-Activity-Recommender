//
//  RatingsView.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 06/02/2021.
//

import SwiftUI

struct RatingsView: View {
    
    @ObservedObject var rating = RatingStructure()
    
    var body: some View {
        NavigationView {
            List(rating.ratings) { item in
                HStack {
                    Text("\(item.score) stars at ")
                    Text("\(item.location)")
                }
            }
            
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Your Ratings"))
        }
    }
}

struct RatingsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsView()
    }
}
