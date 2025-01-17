//
//  MyRideSection1CollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class MyRideSection1CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sourceLocationLabel: UILabel!
    @IBOutlet weak var destinationLocationLabel: UILabel!
    @IBOutlet weak var sourceTimeLabel: UILabel!
    @IBOutlet weak var rideFareLabel: UILabel!
    @IBOutlet weak var vehicleLogoImage: UIImageView!
    
    func updateSection1Data(with indexPath: IndexPath){
        sourceLocationLabel.text = "Mayur Vihar"
        destinationLocationLabel.text = "Sector 52"
        sourceTimeLabel.text = "10:30 AM"
        rideFareLabel.text = "70"
        vehicleLogoImage.image = UIImage(systemName: "bus.fill")
    }
}
