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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    func updatePreviousRideCell(with rideHistory: RidesHistory2) {
        dateLabel.text = dateFormatter.string(from: rideHistory.date)
        fareLabel.text = "₹\(rideHistory.fare)"
        sourceAddress.text = rideHistory.source
        destinationAddress.text = rideHistory.destination
        
        // Since we don't have separate time fields in the new model,
        // we'll just use the date for now
        pickUpTimeLabel.text = timeFormatter.string(from: rideHistory.date)
        dropOffTimeLabel.text = timeFormatter.string(from: rideHistory.date)
    }
    
    
}
