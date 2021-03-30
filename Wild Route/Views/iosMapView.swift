//
//  MapView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//
import SwiftUI
import Mapbox

struct iosMapView: View {
    @State var userLatitude = 0.0
    @State var userLongitude = 0.0
    @State  private var clicked = false
    @State  private var loaded = false
    @ObservedObject var locationManager = LocationManager()
    @State var annotations = [MGLPointAnnotation]()
    @State private var places = [[LandmarkDB]]()
    @ObservedObject var annotationsVM = AnnotationsVM()
    let group = DispatchGroup()
    @ObservedObject var monitor = NetworkMonitor()
    @State var showAlert = false
    @State var showLocAlert = false
    @State var style = 0
    
    func getLocations() {
        userLatitude = locationManager.location?.coordinate.latitude ?? 0.0
        userLongitude = locationManager.location?.coordinate.longitude ?? 0.0
        locationManager.stop()
        let searchType = ["Mountain", "National Parks", "Beaches", "Ski Resort", "Kayaking", "Golf Course", "Tennis Court"]
        
        for n in 0..<searchType.count {
            group.enter()
            LandmarkStruct().searchNearby(userLatitude: userLatitude, userLongitude: userLongitude, type: searchType[n], completion: { points in
                places.append(points)
                for location in points {
                    let annotation = MGLPointAnnotation()
                    annotation.title = location.name
                    annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    annotation.subtitle = type().activityType(type: location.type)
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
                    Blur().ignoresSafeArea(.all).opacity(0.3)
                    if style == 0 {
                        MapView(annos: $annotations).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/outdoors-v11")!)
                    }
                    if style == 1 {
                        MapView(annos: $annotations).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/satellite-v9")!)
                    }
                    if style == 2 {
                        MapView(annos: $annotations).userLoc(true).styleURL(URL(string: "mapbox://styles/mapbox/streets-v11")!)
                    }
                    if style == 3 {
                        MapView(annos: $annotations).userLoc(true).styleURL(URL(string: "mapbox://styles/thomasaxgray/cklfbi5ke3yre17lcbv8gifm0")!)
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Menu {
                                Text("Map Styles")
                                Button(action: {
                                    styleSwap(input: 1)
                                }, label: {
                                    Text("Satellite")
                                })
                                Button(action: {
                                    styleSwap(input: 2)
                                }, label: {
                                    Text("Streets")
                                })
                                Button(action: {
                                    styleSwap(input: 3)
                                    
                                }, label: {
                                    Text("Topographic")
                                })
                                Button(action: {
                                    styleSwap(input: 0)
                                    
                                }, label: {
                                    Text("Outdoor hybrid")
                                })

                            } label: {
                                Image(systemName: "paintbrush.fill")
                                    .padding(.all)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color.white)
                            }
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(38.5)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                            Spacer()
                        }
                        Spacer()
                    }
                    if clicked == true && loaded == false {
                        Blur()
                            .frame(width:  UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                            .edgesIgnoringSafeArea(.top)
                    }
                    VStack{
                        Spacer()
                        if clicked == false {
                            Button(action: {
                                if (monitor.connected) && ((locationManager.status() != .denied) &&  (locationManager.status() != .notDetermined) &&  (locationManager.status() != .restricted)) {
                                    clicked = true
                                    getLocations()
                                    group.notify(queue: .main) {
                                        // annotationsVM.addNextAnnotation(annotation: annotations)
                                        loaded = true
                                    }
                                } else if !(monitor.connected) {
                                    showAlert = true
                                } else if ((locationManager.status() == .denied) ||  (locationManager.status() == .notDetermined) ||  (locationManager.status() == .restricted)) {
                                    showLocAlert = true
                                }
                            }) {
                                Text("Find Me Acitvities")
                                    .font(.system(size: 28, weight: .heavy, design: .default))
                            }
                            .buttonStyle(GradientButtonStyle())
                            .offset(x: 0.0, y: -30.0)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 30)
                            .alert(isPresented: $showAlert, content: {
                                return Alert(title: Text("No Internet Connection"), message: Text("Please enable WiFi or Cellular data"), dismissButton: .default(Text("Try again")))
                            })
                            .alert(isPresented: $showLocAlert, content: {
                                return Alert(title: Text("No Location Determined"), message: Text("Please enable location services by going to Settings -> Privacy -> Location Services -> Wild Route"), dismissButton: .default(Text("Try again")))
                            })
                        }
                    }
                    if clicked == true {
                        if loaded == true {
                            SlideOverCard() {
                                VStack {
                                    HStack {
                                        Text("Places for activities near you...")
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
        }
    }
    
    func reset() {
        clicked = false
        annotations.removeAll()
        places.removeAll()
        loaded = false
    }
    
    func styleSwap(input: Int) {
        style = input
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
