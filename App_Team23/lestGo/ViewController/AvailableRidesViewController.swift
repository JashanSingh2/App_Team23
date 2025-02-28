//
//  AvailableRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit
import MapKit



class AvailableRidesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    

    //@IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var routeMapView: MKMapView!
    
    
    @IBOutlet weak var availableRidesCollectionView: UICollectionView!
    
    var numberOfSeats: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //routeMapView.layer.cornerRadius = 18
        
        availableRidesCollectionView.layer.cornerRadius = 18
        
        //bottomView.layer.cornerRadius = 15
        
        let nib = UINib(nibName: "AllSuggestedRides", bundle: nil)
        
        availableRidesCollectionView.register(nib, forCellWithReuseIdentifier: "AvailableRides")
        
        availableRidesCollectionView.setCollectionViewLayout(generatelayout(), animated: true)
        
        availableRidesCollectionView.dataSource = self
        availableRidesCollectionView.delegate = self
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RidesDataController.shared.numberOfRidesAvailable()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = availableRidesCollectionView.dequeueReusableCell(withReuseIdentifier: "AvailableRides", for: indexPath) as! AllSuggestedRidesCollectionViewCell
        
        cell.layer.cornerRadius = 12.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.masksToBounds = false

        
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
            viewController.maxSeatsAllowed = numberOfSeats
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
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(236))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
            
            return section
            
        }
        
        return layout
    }
    

    @IBAction func unwindToRideSelection(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    

}
