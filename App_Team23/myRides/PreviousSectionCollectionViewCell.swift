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
        
        func updatePreviousData(with indexPath: IndexPath){
            sourceLocationLabel.text = "Sector 62"
            destinationLocationLabel.text = "Pari Chowk"
            sourceDateLabel.text = "22 Jan 2025"
            rideFareLabel.text = "80"
            vehicleLogoImage.image = UIImage(systemName: "bus.fill")
        }
}
