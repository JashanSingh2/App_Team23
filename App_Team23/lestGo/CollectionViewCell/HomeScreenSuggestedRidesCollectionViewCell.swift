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
    
    @IBOutlet weak var seatsAvailableLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var busOrCarButton: UIButton!
    
    @IBOutlet weak var seatAvailableButton: UIButton!
    
    func updateSuggestedRideCell(with rideSuggestion: RideAvailable){
        

        sourceAddressLabel.text = rideSuggestion.serviceProvider.route.first?.address
        //print(rideSuggestion.serviceProvider.route.first?.address ?? "No Address")
        destinationAddressLabel.text = rideSuggestion.serviceProvider.route.last?.address
        
        pickUpTimeLabel.text = rideSuggestion.serviceProvider.route.first?.time
        //print(rideSuggestion.serviceProvider.route.first?.time ?? "No Time")
        dropOffTimeLabel.text = rideSuggestion.serviceProvider.route.last?.time
        
        if rideSuggestion.serviceProvider.rideType.vehicleType == .bus{
            let config = UIImage.SymbolConfiguration(scale: .medium) // Set symbol size to medium
            let image = UIImage(systemName: "bus.fill", withConfiguration: config)
            busOrCarButton.setImage(image, for: .normal)
            busOrCarButton.setTitle("Bus", for: .normal)
            //busOrCarButton.set
        }else {
            let config = UIImage.SymbolConfiguration(scale: .medium) 
            let image = UIImage(systemName: "car.fill", withConfiguration: config)
            busOrCarButton.setImage(image, for: .normal)
            busOrCarButton.setTitle("Car", for: .normal)
        }
        
        seatAvailableButton.setTitle("\(rideSuggestion.seatsAvailable) Seats", for: .normal)
        
        fareLabel.text = "\(rideSuggestion.serviceProvider.fare)"
    
    }
    
}
