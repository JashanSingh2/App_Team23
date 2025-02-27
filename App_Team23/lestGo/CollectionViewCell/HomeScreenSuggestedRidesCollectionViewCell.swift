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
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var borderStack: UIStackView!
    
    
    func updateSuggestedRideCell(with rideSuggestion: RidesAvailable){
        borderStack.layer.borderColor = UIColor.black.cgColor
        borderStack.layer.borderWidth = 1.0
        borderStack.layer.cornerRadius = 5.0
        
        sourceAddressLabel.text = rideSuggestion.serviceProvider.route.first?.address
        destinationAddressLabel.text = rideSuggestion.serviceProvider.route.last?.address
        
        pickUpTimeLabel.text = rideSuggestion.serviceProvider.route.first?.time
        dropOffTimeLabel.text = rideSuggestion.serviceProvider.route.last?.time
        
        if rideSuggestion.serviceProvider.rideType.vehicleType == .bus{
            busORcarImageView.image = UIImage(systemName: "bus.fill")
        }else {
            busORcarImageView.image = UIImage(systemName: "car.fill")
        }
        
        seatsAvailableLabel.text = "\(rideSuggestion.seatsAvailable) Seats Available"
        fareLabel.text = "\(rideSuggestion.serviceProvider.fare)"
        
        
    }
    
}
