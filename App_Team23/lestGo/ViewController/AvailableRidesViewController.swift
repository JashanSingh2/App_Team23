//
//  AvailableRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit
import MapKit



class AvailableRidesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    

    //@IBOutlet weak var bottomView: UIView!
    
    
    
    
    @IBOutlet weak var routeMapView: MKMapView!
    
    
    @IBOutlet weak var availableRidesCollectionView: UICollectionView!
    
    
    
    var numberOfSeats: Int?
    var ride: RideSearch?
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Source \(ride!.source)")
        print("Destination \(ride!.destination)")
        //routeMapView.layer.cornerRadius = 18
        
        availableRidesCollectionView.layer.cornerRadius = 18
        
        //bottomView.layer.cornerRadius = 15
        
        let nib = UINib(nibName: "AllSuggestedRides", bundle: nil)
        
        availableRidesCollectionView.register(nib, forCellWithReuseIdentifier: "AvailableRides")
        
        availableRidesCollectionView.setCollectionViewLayout(generatelayout(), animated: true)
        
        availableRidesCollectionView.dataSource = self
        availableRidesCollectionView.delegate = self
        
        
        
        routeMapView.delegate = self
        locationManager.delegate = self

        searchRide()
        
        // Request location permissions
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Disable search button initially
        //searchButton.isEnabled = false

        // Add target for text field changes
//        sourceTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
//        destinationTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RidesDataController.shared.numberOfRidesAvailable()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = availableRidesCollectionView.dequeueReusableCell(withReuseIdentifier: "AvailableRides", for: indexPath) as! AllSuggestedRidesCollectionViewCell
        
        let ride = RidesDataController.shared.availableRide(At: indexPath.row)
        cell.updateAllSuggestedRidesCell(with: ride)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ride = RidesDataController.shared.availableRide(At: indexPath.row)
        
        if ride.serviceProvider.rideType.vehicleType == .bus{
            let storyBoard = UIStoryboard(name: "SeatBookingViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "seatBookingVC") as! SeatBookingViewController
            viewController.selectedRide = ride
            viewController.maxSeatsAllowed = self.ride!.numberOfSeats
            navigationController?.present(viewController, animated: true)
        }else{
            let storyBoard = UIStoryboard(name: "CarBooking", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "carBookingVC") as! SeatBookingCarViewController
            viewController.selectedRide = ride
            navigationController?.present(viewController, animated: true)
        }
        
    }
    
    
    func generatelayout()-> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex, environment)-> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
            
            return section
            
        }
        
        return layout
    }
    

    @IBAction func unwindToRideSelection(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    //for mapView


    // Enable search button only when both text fields have input

    func searchRide() {
        getCoordinates(for: ride!.source) { sourcePlacemark in
            guard let sourcePlacemark = sourcePlacemark else { return }

            self.getCoordinates(for: self.ride!.destination) { destinationPlacemark in
                guard let destinationPlacemark = destinationPlacemark else { return }

                self.showRoute(source: sourcePlacemark, destination: destinationPlacemark)
            }
        }
    }

    // Function to convert address to coordinates
    func getCoordinates(for address: String, completion: @escaping (MKPlacemark?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, let firstPlacemark = response.mapItems.first?.placemark else {
                completion(nil)
                return
            }
            completion(firstPlacemark)
        }
    }

    // Function to show route on map
    func showRoute(source: MKPlacemark, destination: MKPlacemark) {
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.coordinate = source.coordinate
        sourceAnnotation.title = ride?.source

        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destination.coordinate
        destinationAnnotation.title = ride?.destination

        routeMapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: source)
        directionRequest.destination = MKMapItem(placemark: destination)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            self.routeMapView.addOverlay(route.polyline, level: .aboveRoads)
            self.routeMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    // Function to render route line
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }

    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            routeMapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation() // Stop updating to save battery
        }
    }
    
    
    
}








