//
//  RatingsView.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 06/02/2021.
//

import SwiftUI

struct RatingsView: View {
    
    @State var rating = RatingStructure()
    @State var ra = [Rating]()
    
    var body: some View {
        NavigationView {
            List(ra) { item in
                NavigationLink(destination: New()) {
                    HStack {
                        Text("\(item.score) stars at ")
                        Text("\(item.location)")
                    }
                    }
            }
            
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Your Ratings"))
        }.onAppear {
            rating.loadRatings { (ratings) in
                ra = ratings
            }
        }
    }
}


struct New : View {
    
    
    var body: some View {
        VStack{
            HStack {
                Text("test")
            }
        }.background(Color(UIColor(.accentColor)))
    }
}
