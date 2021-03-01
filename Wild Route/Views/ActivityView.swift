//
//  ActivityCard.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 01/02/2021.
//

import SwiftUI
import Mapbox

struct ActivityCard: View {
    @State var landmark: LandmarkDB
    @State var name : String?
    @State var annotations = [MGLPointAnnotation]()
    @State private var isFavourite = false
    @ObservedObject var favo = RatingStructure()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var fav = Favourite(location: "", user: "")
    
    func setUp() {
        let annotation = MGLPointAnnotation()
        annotation.title = landmark.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude)
        annotation.subtitle = type().activityType(type: landmark.type)
        annotations.append(annotation)
    }
    
    var body: some View {
        if name == nil {
            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing: 0) {
                    ScrollView(.vertical) {
                        Spacer(minLength: 25)
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(type().activityType(type: landmark.type)).font(.system(size: 40, weight: .bold)).foregroundColor(type().changeBkColor(type: landmark.type)).padding(.horizontal,20)
                                Text(landmark.name).font(.system(size: 30, weight: .regular)).minimumScaleFactor(0.2).lineLimit(1).padding(.horizontal,20)
                                Text(landmark.description).font(.system(size: 20, weight: .light)).foregroundColor(.gray).minimumScaleFactor(0.2).lineLimit(1).padding(.horizontal,20)
                            }
                            Spacer()
                        }
                        MapView(annos: $annotations).zoomLevel(11).centerCoordinate(CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude)).userLoc(false).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!)
                            .frame(width: UIScreen.main.bounds.width-40, height: 225)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        RatingCard(landmark: landmark)
                            .padding([.horizontal,.vertical])
                        WeatherView(lat: landmark.latitude, lon: landmark.longitude)
                            .padding(.horizontal)
                        Spacer(minLength: 25)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }.onDisappear {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } .onAppear(perform: {
                setUp()
                favo.loadOneFav(loc: landmark.name) { (favourite) in
                    if favourite.count == 1 {
                        self.fav = favourite[0]
                        self.isFavourite = true
                    }
                }
            })
            .navigationBarTitle(landmark.name,displayMode: .inline)
            
            .navigationBarItems(trailing:
                                    Image(systemName:  isFavourite ? "heart.fill" : "heart").font(.system(size: 30))
                                    .foregroundColor(.pink)
                                    .padding([.leading,.bottom,.top])
                                    .onTapGesture() {
                                        if !isFavourite {
                                            favo.addLandmark(landmark: landmark)
                                            favo.addFavourite(location: landmark.name)
                                            self.isFavourite.toggle()
                                        }
                                        if isFavourite {
                                            favo.removeFavourite(fav: fav){ (result) in
                                                self.isFavourite.toggle()
                                            }
                                        }
                                    })
        }
        if name != nil {
            Text("loading").onAppear {
                favo.loadLandmark(location: name ?? "") { (res) in
                    if !res.isEmpty {
                        landmark = res[0]
                        name = nil
                    }
                }
            }.onDisappear {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}



