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
        
        init(_ control: MapView, _ mapView: MGLMapView) {
                  self.control = control
                  self.mapView = mapView
              }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }
         
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
        func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
                   if annotation.title == "Mapbox" {
                       mapView.styleURL = MGLStyle.lightStyleURL
            }
        }
        func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
            if annotation.title == "Mapbox" {
                mapView.styleURL = MGLStyle.outdoorsStyleURL(withVersion: 11)
            }
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
