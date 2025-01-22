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
    @IBOutlet weak var resheduleButton: UIButton!
    
    func updateSection1Data(with indexPath: IndexPath){
        sourceLocationLabel.text = "Mayur Vihar"
        destinationLocationLabel.text = "Sector 52"
        sourceTimeLabel.text = "10:30 AM"
        rideFareLabel.text = "70"
        vehicleLogoImage.image = UIImage(systemName: "bus.fill")
    }
    
    func updateSection2Data(with IndexPath: IndexPath){
        sourceLocationLabel.text = "Pari Chowk"
        destinationLocationLabel.text = "Akshardham"
        sourceTimeLabel.text = "09:00 AM"
        rideFareLabel.text = "100"
        vehicleLogoImage.image = UIImage(systemName: "car.fill")
    }
    
    func updateSection3Data(with indexPath: IndexPath){
        sourceLocationLabel.text = "Source \(indexPath.row + 1)"
        destinationLocationLabel.text = "Destination \(indexPath.row + 1)"
        sourceTimeLabel.text = "Source Time \(indexPath.row + 1)"
        rideFareLabel.text = "Ride Fare \(indexPath.row + 1)"
        vehicleLogoImage.image = UIImage(systemName: "car.fill")
    }
}
