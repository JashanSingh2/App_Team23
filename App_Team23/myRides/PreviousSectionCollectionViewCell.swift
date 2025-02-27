//
//  PreviousSectionCollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 20/01/25.
//

import UIKit

class PreviousSectionCollectionViewCell: UICollectionViewCell {
        @IBOutlet weak var sourceLocationLabel: UILabel!
        @IBOutlet weak var destinationLocationLabel: UILabel!
        @IBOutlet weak var sourceDateLabel: UILabel!
        @IBOutlet weak var rideFareLabel: UILabel!
        @IBOutlet weak var vehicleLogoImage: UIImageView!
    @IBOutlet weak var vehicleLogoButton: UIButton!
    @IBOutlet weak var rideDateButton: UIButton!
    
        @IBOutlet weak var reBookButton: UIButton!
    
    
    
        func updatePreviousData(with rideHistory: RideHistory){
            sourceLocationLabel.text = rideHistory.source.address
            destinationLocationLabel.text = rideHistory.destination.address
//            sourceDateLabel.text = rideHistory.date
            rideFareLabel.text = "\(rideHistory.fare)"
            if rideHistory.serviceProvider.rideType.vehicleType == .bus{
//                vehicleLogoImage.image = UIImage(systemName: "bus.fill")
                
                vehicleLogoButton.setImage(UIImage(systemName: "bus.fill"), for: .normal)
                
                vehicleLogoButton.setTitle("Bus", for: .normal)
                
            }else{
 //               vehicleLogoImage.image = UIImage(systemName: "car.fill")
                
                vehicleLogoButton.setImage(UIImage(systemName: "car.fill"), for: .normal)
                
                vehicleLogoButton.setTitle("Car", for: .normal)
            }
        }
}
