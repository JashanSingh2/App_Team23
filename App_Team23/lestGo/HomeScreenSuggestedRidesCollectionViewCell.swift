//
//  HomeScreenSuggestedRidesCollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 17/01/25.
//

import UIKit

class HomeScreenSuggestedRidesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sourceAddressLabel: UILabel!
    
    @IBOutlet weak var destinationAddressLabel: UILabel!
    
    @IBOutlet weak var pickUpTimeLabel: UILabel!
    
    @IBOutlet weak var dropOffTimeLabel: UILabel!
    
    @IBOutlet weak var busORcarImageView: UIImageView!
    
    @IBOutlet weak var seatsAvailableLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    
    @IBOutlet weak var borderStack: UIStackView!
    
    
    func updateSuggestedRideCell(with rideSuggestion: RidesAvailable){
        borderStack.layer.borderColor = UIColor.black.cgColor
        borderStack.layer.borderWidth = 1.0
        borderStack.layer.cornerRadius = 5.0
        
        sourceAddressLabel.text = rideSuggestion.source.address
        destinationAddressLabel.text = rideSuggestion.destination.address
        
        pickUpTimeLabel.text = rideSuggestion.source.time
        dropOffTimeLabel.text = rideSuggestion.destination.time
        
        if rideSuggestion.serviceProvider.rideType.vehicleType == .bus{
            busORcarImageView.image = UIImage(systemName: "bus.fill")
        }else {
            busORcarImageView.image = UIImage(systemName: "car.fill")
        }
        
        seatsAvailableLabel.text = "\(rideSuggestion.seatsAvailable) Seats Available"
        fareLabel.text = "\(rideSuggestion.fare)"
        
        
    }
    
}
