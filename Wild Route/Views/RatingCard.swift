//
//  RatingCard.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 23/02/2021.
//

import SwiftUI
import Firebase

struct RatingCard: View {
    
    var landmark: LandmarkDB
    @State var ratings = [Rating]()
    @State var userRating = [Rating]()
    @State var average = 0.0
    @State var totals = [0,0,0,0,0]
    @State var max = 0
    @State var counter = 0
    @State var enterRating = false
   // @State var rating = [0,0,0,0,0]
    
    @State var rating = 0

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
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
            if !userRating.isEmpty && !enterRating {
                VStack {
                ExDivider(color: Color(UIColor.systemBackground)).padding()
                    Text("You left a rating: ").foregroundColor(.gray).padding(.bottom, 4)
                HStack {
                    ForEach(1..<maximumRating + 1) { number in
                        self.image(for: number)
                               .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                               
                       }
                }.padding(.bottom)
                }
            }
            if enterRating {
                VStack {
                    ExDivider(color: Color(UIColor.systemBackground)).padding()
                    VStack {
                        Text("Tap the number of stars, then submit your rating").foregroundColor(.gray)
                        HStack {
                            ForEach(1..<maximumRating + 1) { number in
                                   self.image(for: number).font(.title)
                                       .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                                       .onTapGesture {
                                           self.rating = number
                                       }
                               }
                        }.padding(.bottom)
                       
                        Button(action: {
                            if userRating.isEmpty {
                                RatingStructure().addReview(rating: Rating(location: landmark.name, user: Auth.auth().currentUser?.uid ?? "Guest", score: self.rating))
                            } else if !userRating.isEmpty {
                                RatingStructure().updateReview(rating: Rating(id: userRating[0].id, location: landmark.name, user: Auth.auth().currentUser?.uid ?? "Guest", score: self.rating))
                            }
                            enterRating = false
                            load()
                        }) {
                            Text("Submit Rating")
                                .foregroundColor(Color(UIColor.white))
                                .fontWeight(.heavy)
                                .font(.system(size: 20))
                                .frame(width: UIScreen.main.bounds.width/2, height: 5)
                            }
                            .buttonStyle(GradientButtonStyle())
                    
                    }.padding(.bottom)
                }
            }
            if !enterRating {
                Button(action: {
                    withAnimation {
                        enterRating = true  
                    }
                }) {
                    Text(userRating.isEmpty ? "Add Rating" : "Change Your Rating")
                        .foregroundColor(Color(UIColor.white))
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .frame(width: UIScreen.main.bounds.width/2, height: 5)
                    }
                    .padding(.bottom)
                    .buttonStyle(GradientButtonStyle())
            }
        }
        .padding([.top, .trailing, .bottom])
        .padding(.leading, 24)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onAppear(perform: {
            load()
            
        })
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    
    func load() {
        
        RatingStructure().getAverage(location: landmark.name) { (result) in
            self.ratings = result
            counter = 0
            average = 0.0
            max = 0
            totals = [0,0,0,0,0]
            if !ratings.isEmpty {
                for n in ratings {
                    counter = counter + 1
                    totals[n.score-1] = totals[n.score-1] + 1
                    if totals[n.score-1] > max {
                        max =  totals[n.score-1]
                    }
                    average = average + Double(n.score)
                    if n.user == Auth.auth().currentUser?.uid {
                        userRating.insert(n, at: 0)
                        rating = userRating[0].score
                    }
                }
                average = average / Double(counter)
            } else {
                totals.removeAll()
            }
        }
    }
}
