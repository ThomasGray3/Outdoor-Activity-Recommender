//
//  MapView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//
import SwiftUI
import Mapbox

struct iosMapView: View {
    
    @State  private var clicked = false
    @State  private var loaded = false
    @ObservedObject var locationManager = LocationManager()
    @State var userLatitude = 0.0
    @State var userLongitude = 0.0
    @State var annotations = [MGLPointAnnotation]()
    @State private var places = [[Landmark]]()
   // @State private var skiPlaces = [Result]()
    @ObservedObject var annotationsVM = AnnotationsVM()
    let group = DispatchGroup()
    
    func getLocations() {
        userLatitude = locationManager.location?.coordinate.latitude ?? 0.0
        userLongitude = locationManager.location?.coordinate.longitude ?? 0.0
        locationManager.stop()
        let searchType = ["Mountains", "National Parks", "Beaches", "Ski Centre", "Kayaking"]
       /* group.enter()
        SkiResorts().skiSearch(lat: userLatitude, lon: userLongitude, completion: { skiResult in
            for location in skiResult {
                let annotation = MGLPointAnnotation()
                annotation.title = location.areaName[0].value
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.latitude) ?? 0.0, longitude: Double(location.longitude) ?? 0.0)
                annotation.subtitle = "Ski Centres"
                print(annotation)
                annotations.append(annotation)
            }
            skiPlaces = skiResult
            group.leave()
        })
        */
        for n in 0..<searchType.count {
            group.enter()

            LandmarkStruct().searchNearby(userLatitude: userLatitude, userLongitude: userLongitude, type: searchType[n], completion: { points in
                places.append(points)
                for location in points {
                    let annotation = MGLPointAnnotation()
                    annotation.title = location.name
                    annotation.coordinate = location.coordinate
                    annotation.subtitle = location.type
                    annotations.append(annotation)
                }
                group.leave()
            })
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack{
                ZStack{
                    MapView(annos: $annotationsVM.annos).centerCoordinate(.init(latitude: userLatitude, longitude: userLongitude)).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!)
                    if clicked == true && loaded == false {
                        Blur()
                            .frame(width:  UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                            .edgesIgnoringSafeArea(.top)
                        }
                    VStack{
                        Spacer()
                        if clicked == false {
                            Button(action: {
                                clicked = true
                                getLocations()
                                group.notify(queue: .main) {
                                    annotationsVM.addNextAnnotation(annotation: annotations)
                                    loaded = true
                                }
                            }) {
                                Text("Find Acitvities")
                                    .font(.system(size: 28, weight: .heavy, design: .default))
                            }
                            .buttonStyle(GradientButtonStyle())
                            .offset(x: 0.0, y: -30.0)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 30)
                        }
                    }
                    if clicked == true {
                        if loaded == true {
                                SlideOverCard() {
                                    VStack {
                                        HStack {
                                            Text("Activities for you, near you...")
                                                .padding(.all)
                                            Spacer()
                                            Button(action: {
                                                reset()
                                            }, label: {
                                                Image(systemName: "plus")
                                                    .rotationEffect(.init(degrees: 45))
                                                    .frame(width: 35, height: 35)
                                                    .foregroundColor(Color.white)
                                            })
                                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                            .cornerRadius(38.5)
                                            .padding()
                                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                                        }
                                        DisplaySearch(places: places /*skiPlaces: skiPlaces*/)
                                    }
                                }
                        } else if loaded == false {
                                    loadAnnimation().padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            //.navigationBarTitleDisplayMode(.large)
            //.navigationTitle(Text("Explore"))
        }.onDisappear(perform: {
            reset()
        })
    }

    func reset() {
        clicked = false
        annotationsVM.deleteAnnos()
        places.removeAll()
        loaded = false
        locationManager.start()
        //skiPlaces.removeAll()
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
    }
}

struct iosMapView_Previews: PreviewProvider {
    static var previews: some View {
        iosMapView()
    }
}

struct loadAnnimation: View {
    
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Text("Loading...")
                .font(.system(size: 30, design: .rounded))
                .bold()
                .offset(x: 0, y: -35)
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(.systemGray6), lineWidth: 5)
                .frame(width: 250, height: 5)
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.green, lineWidth: 5)
                .frame(width: 30, height: 5)
                .offset(x: isLoading ? 110 : -110, y: 0)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear() {
            self.isLoading = true
        }
    }
}

struct Blur: UIViewRepresentable {
    let style: UIBlurEffect.Style = .regular

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
