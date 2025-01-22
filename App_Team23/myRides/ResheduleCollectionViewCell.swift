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
    @IBOutlet weak var seatAvailableLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var BorderView: UIView!
    
    
    
    func updateReshedulaRideData(with indexPath: IndexPath){
        
        BorderView.layer.borderWidth = 1
        BorderView.layer.borderColor = UIColor.black.cgColor
        BorderView.layer.cornerRadius = 5.0
        BorderView.layer.masksToBounds = true
        pickUpTimeLabel.text = "9:00 AM"
        dropOffTimeLabel.text = "10:00 AM"
        seatAvailableLabel.text = "12 Seats Available"
    }
}
