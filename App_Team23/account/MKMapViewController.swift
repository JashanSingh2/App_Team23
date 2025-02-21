
import UIKit
import MapKit
import CoreLocation

class MKMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var selectedPin: MKPointAnnotation?
    var completionHandler: ((String) -> Void)?
    
    // Variables to store the original navigation bar appearance
    var originalNavBarBackgroundImage: UIImage?
    var originalNavBarShadowImage: UIImage?
    var originalNavBarIsTranslucent: Bool = false
    var originalNavBarBackgroundColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.frame = view.bounds
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        mapView.addGestureRecognizer(tapGesture)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(confirmLocation))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Save the original navigation bar appearance
        originalNavBarBackgroundImage = navigationController?.navigationBar.backgroundImage(for: .default)
        originalNavBarShadowImage = navigationController?.navigationBar.shadowImage
        originalNavBarIsTranslucent = navigationController?.navigationBar.isTranslucent ?? false
        originalNavBarBackgroundColor = navigationController?.navigationBar.backgroundColor

        // Make the navigation bar background transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Restore the original navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(originalNavBarBackgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = originalNavBarShadowImage
        navigationController?.navigationBar.isTranslucent = originalNavBarIsTranslucent
        navigationController?.navigationBar.backgroundColor = originalNavBarBackgroundColor
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        if selectedPin == nil {
            selectedPin = MKPointAnnotation()
            mapView.addAnnotation(selectedPin!)
        }
        selectedPin?.coordinate = coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let placemark = placemarks?.first {
                let address = "\(placemark.thoroughfare ?? "") \(placemark.locality ?? "")"
                self?.completionHandler?(address)
            }
        }
    }
    
    @objc func confirmLocation() {
        navigationController?.popViewController(animated: true)
    }
}
