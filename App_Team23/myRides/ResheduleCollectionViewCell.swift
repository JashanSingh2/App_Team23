//
//  ResheduleCollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 22/01/25.
//

import UIKit

class ResheduleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pickUpTimeLabel: UILabel!
    @IBOutlet weak var dropOffTimeLabel: UILabel!
    @IBOutlet weak var seatAvailableButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!

    
    
    func updateReshedulaRideData(with indexPath: IndexPath){
        
        pickUpTimeLabel.text = "9:00 AM"
        dropOffTimeLabel.text = "10:00 AM"
        seatAvailableButton.setTitle("12 Seats", for: .normal)
        
    }
}
