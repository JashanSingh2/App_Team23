//
//  AllSuggestedRidesCollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 20/01/25.
//

import UIKit

class AllSuggestedRidesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sourceAddressLabel: UILabel!
    
    @IBOutlet weak var destinationAddressLabel: UILabel!
    
    @IBOutlet weak var pickupTimeLabel: UILabel!
    
    @IBOutlet weak var dropoffTimeLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var seatsAvailableButton: UIButton!
    
    @IBOutlet weak var serviceProviderNameLabel: UILabel!
    
    @IBOutlet weak var serviceProviderRatingLabel: UILabel!
    
    @IBOutlet weak var vehicleTypeImageView: UIImageView!
    
    
    @IBOutlet weak var acNonAcImageView: UIImageView!
    
    @IBOutlet weak var acNonAcLabel: UILabel!
    
    
    @IBOutlet weak var cellContentview: UIView!
    
    @IBOutlet weak var seatsAvailableStackView: UIStackView!
    
    func updateAllSuggestedRidesCell(with ride: RideAvailable,source: Schedule, destination: Schedule,fare: Int){
        //seatsAvailableStackView.layer.borderWidth = 1
        //seatsAvailableStackView.layer.borderColor = UIColor.black.cgColor
        //seatsAvailableStackView.layer.cornerRadius = 5
        
        cellContentview.layer.cornerRadius = 10
        
        sourceAddressLabel.text = source.address
        destinationAddressLabel.text = destination.address
        pickupTimeLabel.text = source.time
        dropoffTimeLabel.text = destination.time
        fareLabel.text = "\(fare)"
        seatsAvailableButton.setTitle("\(ride.seatsAvailable) Seats", for: .normal)
        serviceProviderNameLabel.text = "\(ride.serviceProvider.name)"
        serviceProviderRatingLabel.text = "\(ride.serviceProvider.rating)"
        if ride.serviceProvider.rideType.vehicleType == .car{
            vehicleTypeImageView.image = UIImage(systemName: "car.fill")
        }else {
            vehicleTypeImageView.image = UIImage(systemName: "bus.fill")
        }
        if ride.serviceProvider.rideType.facility == .ac{
            //acNonAcLabel.text = "AC"
            acNonAcImageView.image = UIImage(systemName: "snowflake")
        }else {
            //acNonAcLabel.text = "Non AC"
            acNonAcImageView.image = UIImage(systemName: "snowflake.slash")
        }
        
    }
    
    
    
    
}
