import SwiftUI
import Mapbox

extension MGLPointAnnotation {
    convenience init(title: String, coordinate: CLLocationCoordinate2D) {
        self.init()
        self.title = title
        self.coordinate = coordinate
    }
}

struct MapView: UIViewRepresentable {
    @Binding var annos: [MGLPointAnnotation]
   
    
    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.outdoorsStyleURL(withVersion: 11))
    
    // MARK: - Configuring UIViewRepresentable protocol
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: Context) {
        updateAnnotations(uiView)
        
    }
    
    private func updateAnnotations(_ view: MGLMapView) {
        if let currentAnnotations = view.annotations {
            view.removeAnnotations(currentAnnotations)
        }
        view.addAnnotations(annos)
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self, mapView)
    }
    
    // MARK: - Configuring MGLMapView
    
    func zoomLevel(_ zoomLevel: Double) -> MapView {
        mapView.zoomLevel = zoomLevel
        return self
    }
    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }
    
    func userLoc(_ userLocation: Bool) -> MapView {
        if userLocation == true {
            mapView.showsUserLocation = userLocation
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
            
        }
        return self
    }
    
    func styleURL(_ styleURL: URL) -> MapView {
        mapView.styleURL = styleURL
        return self
    }
    
    
    
    // MARK: - Implementing MGLMapViewDelegate
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        var mapView: MGLMapView!
        var annos = [MGLPointAnnotation]()
        @State var box = false

        
        init(_ control: MapView, _ mapView: MGLMapView) {
            self.control = control
            self.mapView = mapView
        }
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
           
            return
        }
        
        
        func showAllAnnotations() {
            guard let annotations = mapView.annotations else { return }
            mapView.showAnnotations(annotations, animated: true)
            box = true
        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            // This example is only concerned with point annotations.
            if box == false {
                showAllAnnotations()
            }
            guard annotation is MGLPointAnnotation else {
                return nil
            }
            
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView!.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                
                // Set the annotation view’s background color to a value determined by its longitude.
               
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            
            return true
        }
        
        func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
           
           
        }
        func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
            
        }
    }
}

class AnnotationsVM: ObservableObject {
    @Published var annos = [MGLPointAnnotation]()
    
    func addNextAnnotation(annotation: [MGLPointAnnotation]) {
        for anno in annotation {
            annos.append(anno)
        }
    }
    
    func deleteAnnos() {
        annos.removeAll()
    }
}


class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
       // print(type().activityType(type: "Mountain"))
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        if annotation?.subtitle == type().activityType(type: "Mountain") {
            layer.backgroundColor = UIColor(red: 107/255, green: 239/255, blue: 98/255, alpha: 1.0).cgColor
        } else if annotation?.subtitle == type().activityType(type: "Beaches") {
            layer.backgroundColor = UIColor(red: 99/255, green: 225/255, blue: 242/255, alpha: 1.0).cgColor
        } else if annotation?.subtitle == type().activityType(type: "National Parks") {
            layer.backgroundColor = UIColor(red: 255/255, green: 194/255, blue: 104/255, alpha: 1.0).cgColor
        } else if annotation?.subtitle == type().activityType(type:"Ski Resort") {
            layer.backgroundColor = UIColor.lightGray.cgColor
        } else if annotation?.subtitle == type().activityType(type:"Kayaking") {
            layer.backgroundColor = UIColor(red: 16/255, green: 0/255, blue: 249/255, alpha: 1.0).cgColor
        } else if annotation?.subtitle == type().activityType(type:"Golf Course") {
            layer.backgroundColor = UIColor(red: 255/255, green: 216/255, blue: 0/255, alpha: 1.0).cgColor
        } else if annotation?.subtitle == type().activityType(type:"Tennis Court") {
            layer.backgroundColor = UIColor(red: 6/255, green: 122/255, blue: 0/255, alpha: 1.0).cgColor
        } else {
            layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}
