import UIKit
import MapKit
import CoreLocation

protocol MapLocationDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}

class MapLocationViewController: UIViewController {
    
    // Create MapView programmatically instead of using outlet
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let locationManager = CLLocationManager()
    weak var delegate: MapLocationDelegate?
    private var selectedLocation: CLLocation?
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupMap()
        setupButtons()
        setupNavigationBar()
        
        // Add gesture recognizer to prevent accidental dismissal
        isModalInPresentation = true
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        // Setup constraints for mapView
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupMap() {
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    private func setupButtons() {
        // Stack view to hold buttons
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Current Location Button
//        let useCurrentLocationButton = UIButton(type: .system)
//        useCurrentLocationButton.setTitle("Use Current Location", for: .normal)
//        useCurrentLocationButton.backgroundColor = .systemBlue
//        useCurrentLocationButton.setTitleColor(.white, for: .normal)
//        useCurrentLocationButton.layer.cornerRadius = 20
//        useCurrentLocationButton.addTarget(self, action: #selector(useCurrentLocation), for: .touchUpInside)
//        
        // Confirm Button
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm Location", for: .normal)
        confirmButton.backgroundColor = .systemGreen
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 20
        confirmButton.addTarget(self, action: #selector(confirmLocation), for: .touchUpInside)
        
        // Add buttons to stack view
       // stackView.addArrangedSubview(useCurrentLocationButton)
        stackView.addArrangedSubview(confirmButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      //      useCurrentLocationButton.heightAnchor.constraint(equalToConstant: 40),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Get address for the location
        CLGeocoder().reverseGeocodeLocation(selectedLocation!) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                annotation.title = placemark.name ?? ""
                annotation.subtitle = placemark.thoroughfare ?? ""
                self?.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    @objc private func useCurrentLocation() {
        guard let currentLocation = currentLocation else {
            locationManager.startUpdatingLocation()
            return
        }
        
        selectedLocation = currentLocation
        let coordinate = currentLocation.coordinate
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Center map on current location
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Get address for current location
        CLGeocoder().reverseGeocodeLocation(currentLocation) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                annotation.title = "Current Location"
                annotation.subtitle = [
                    placemark.thoroughfare,
                    placemark.locality,
                    placemark.administrativeArea
                ].compactMap { $0 }.joined(separator: ", ")
                self?.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    @objc private func confirmLocation() {
        guard let location = selectedLocation else {
            showError("Please select a location first")
            return
        }
        
        print("Confirming location...")
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showError("Could not determine address")
                }
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                DispatchQueue.main.async {
                    self.showError("Could not determine address")
                }
                return
            }
            
            let components = [
                placemark.name,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea
            ].compactMap { $0 }
            
            let address = components.isEmpty ? "Selected Location" : components.joined(separator: ", ")
            print("Address found: \(address)")
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didSelectLocation(address)
            }
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // Add a close button to dismiss the map view
    private func setupNavigationBar() {
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension MapLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}

extension MapLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .red
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
} 

