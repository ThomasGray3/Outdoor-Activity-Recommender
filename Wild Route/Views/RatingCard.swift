//
//  RatingCard.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 23/02/2021.
//

import SwiftUI

struct RatingCard: View {
    
    var landmark: LandmarkDB
    @State var ratings = [Rating]()
    @State var average = 0.0
    @State var totals = [0,0,0,0,0]
    @State var max = 0
    @State var counter = 0
    
    
    var body: some View {
        
        VStack {
            HStack {
                VStack (alignment: .leading, spacing: 5) {
                    Text("\(counter) reviews")
                        .foregroundColor(.gray)
                    ForEach(0..<5) { j in
                        HStack {
                            Text("\(5 - j)")
                                .foregroundColor(.gray)
                                .frame(width: 16, alignment: .leading)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            if !totals.isEmpty {
                                if (totals[4 - j] > 0) {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .foregroundColor(.yellow)
                                        .frame(width: (UIScreen.main.bounds.width/3)*(CGFloat(totals[4 - j])/CGFloat(max)), height: 10)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                if totals.isEmpty {
                    Text("There are no reviews for this location...")
                } else {
                    VStack (alignment: .trailing, spacing: 5) {
                        HStack {
                            Text(String(format: "%.1f", average)).font(.largeTitle)
                            Image(systemName: "star.fill").foregroundColor(.yellow).font(.largeTitle)
                        }
                        Text("average")
                    }
                }
            }
            Spacer(minLength: 15)
            Button(action: {
                RatingStructure().addReview()
            }) {
            
                    Text("Add Review")
                        .foregroundColor(Color(UIColor.white))
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .frame(width: UIScreen.main.bounds.width/2, height: 5)
                    }
                
            }
            .buttonStyle(GradientButtonStyle())
         
        .padding([.top, .trailing, .bottom])
        .padding(.leading, 24)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onAppear(perform: {
            RatingStructure().getAverage(location: landmark.name) { (result) in
                self.ratings = result
                if !ratings.isEmpty {
                    for n in ratings {
                        counter = counter + 1
                        totals[n.score-1] = totals[n.score-1] + 1
                        if totals[n.score-1] > max {
                            max =  totals[n.score-1]
                        }
                        average = average + Double(n.score)
                    }
                    average = average / Double(counter)
                } else {
                    totals.removeAll()
                }
            }
        })
    }
}
