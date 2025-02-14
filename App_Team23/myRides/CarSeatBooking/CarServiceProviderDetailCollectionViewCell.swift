//
//  CarServiceDetailCollectionViewCell.swift
//  App_Team23
//
//  Created by Firdosh Alam on 14/02/25.
//

import UIKit

class CarServiceProviderDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var serviceProviderImageView: UIImageView!
    @IBOutlet weak var serviceProviderNameLabel: UILabel!
    @IBOutlet weak var serviceProviderRatingLabel: UILabel!
    @IBOutlet weak var rideFareLabel: UILabel!
    @IBOutlet weak var vehicleDetailsLabel: UILabel!
    @IBOutlet weak var bookingTimeLabel: UILabel!
    
//    func updatePreviousRideCell(with rideHistory: RideHistory){
//        dateLabel.text = rideHistory.date
//        fareLabel.text = "\(rideHistory.fare)"
//        sourceAddress.text = rideHistory.source.address
//        destinationAddress.text = rideHistory.destination.address
//        pickUpTimeLabel.text = rideHistory.source.time
//        dropOffTimeLabel.text = rideHistory.destination.time
//        
//        
//        
//    }
    
    func updateCarServiceProviderCell(with serviceProvider: ServiceProvider){
        serviceProviderImageView.image = UIImage(named: serviceProvider.name)
        serviceProviderNameLabel.text = serviceProvider.name
        serviceProviderRatingLabel.text = "\(serviceProvider.rideType)"
        rideFareLabel.text = "\(serviceProvider.fare)"
        vehicleDetailsLabel.text = "\(serviceProvider.vehicleNumber)"
    }
    
}
