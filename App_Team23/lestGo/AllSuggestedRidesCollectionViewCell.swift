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
    
//    @IBOutlet weak var availableSeatsLabel: UIView!
    
    @IBOutlet weak var seatsAvailableLabel: UILabel!
    
    @IBOutlet weak var serviceProviderNameLabel: UILabel!
    
    @IBOutlet weak var serviceProviderRatingLabel: UILabel!
    
    @IBOutlet weak var vehicleTypeImageView: UIImageView!
    
    
    @IBOutlet weak var acNonAcImageView: UIImageView!
    
    @IBOutlet weak var acNonAcLabel: UILabel!
    
    
    @IBOutlet weak var cellContentview: UIView!
    
    @IBOutlet weak var seatsAvailableStackView: UIStackView!
    
    func updateAllSuggestedRidesCell(with indexPath: IndexPath){
        seatsAvailableStackView.layer.borderWidth = 1
        seatsAvailableStackView.layer.borderColor = UIColor.black.cgColor
        seatsAvailableStackView.layer.cornerRadius = 5
        
        cellContentview.layer.cornerRadius = 10
        
    }
    
    
    
    
}
