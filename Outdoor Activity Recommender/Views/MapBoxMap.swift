import SwiftUI
import Mapbox

struct MapView: UIViewRepresentable {
    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        return mapView
    }

    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
    func zoomLevel(_ zoomLevel: Double) -> MapView {
            mapView.zoomLevel = zoomLevel
            return self
    }
    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
            mapView.centerCoordinate = centerCoordinate
            return self
    }
    
    func userLoc(_ userLocation: Bool) -> MapView {
        mapView.showsUserLocation = userLocation
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        return self
    }
    
    func styleURL(_ styleURL: URL) -> MapView {
            mapView.styleURL = styleURL
            return self
        }
}
