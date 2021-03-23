//
//  RatingsView.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 06/02/2021.
//

import SwiftUI

struct RatingsView: View {
    
    @State var rating = 0
    @State var ratingsS = RatingStructure()
    @State var ra = [Rating]()
    @State var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    @State var show = false
    @State var star = 0
    
    
    var body: some View {
        NavigationView {
                List { 
                    ForEach(ra) { item in
                        VStack {
                            HStack {
                                ForEach(1..<maximumRating + 1) { number in
                                    self.image(for: number)
                                        .foregroundColor(number > item.score ? self.offColor : self.onColor)
                                }
                                
                                Text(item.location)
                                
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                
                .navigationBarItems(trailing: EditButton())
                .navigationTitle(Text("Your Ratings"))
            
        }.onAppear {
            ratingsS.loadRatings(completion: { (ratings) in
                ra = ratings
            }) 
        }
    }
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    
    func delete(offsets: IndexSet) {
        guard let index = Array(offsets).first else { return }
        let r = ra[index]
        ratingsS.removeRating(rating: r) { (Bool) in
            return
        }
    }
}


struct New : View {
    
    var body: some View {
        VStack{
            HStack {
                Text("test")
                Spacer()
            }
        }
        .padding([.top, .trailing, .bottom])
        .padding(.leading, 24)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
