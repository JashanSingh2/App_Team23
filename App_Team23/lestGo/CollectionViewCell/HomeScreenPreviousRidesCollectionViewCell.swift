//
//  HomeScreenPreviousRidesCollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 16/01/25.
//

import UIKit




class HomeScreenPreviousRidesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reBookButton: UIButton!
    
    @IBOutlet weak var vehicleTypeButton: UIButton!
    //    @IBOutlet weak var vehicleTypeImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var sourceAddress: UILabel!
    
    @IBOutlet weak var destinationAddress: UILabel!
    
    @IBOutlet weak var pickUpTimeLabel: UILabel!
    
    @IBOutlet weak var dropOffTimeLabel: UILabel!
    
    func updatePreviousRideCell(with rideHistory: RidesHistory){
        dateLabel.text = rideHistory.date
        fareLabel.text = "\(rideHistory.fare)"
        sourceAddress.text = rideHistory.source.address
        destinationAddress.text = rideHistory.destination.address
        pickUpTimeLabel.text = rideHistory.source.time
        dropOffTimeLabel.text = rideHistory.destination.time
    }
    
    
}
