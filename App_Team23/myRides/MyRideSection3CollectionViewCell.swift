//
//  myRideSection3CollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class MyRideSection3CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sourceLocationLabel3: UILabel!
    @IBOutlet weak var destinationLocationLabel3: UILabel!
    @IBOutlet weak var sourceTimeLabel3: UILabel!
    @IBOutlet weak var rideFareLabel3: UILabel!
    @IBOutlet weak var vehicleLogoImage3: UIImageView!
    
    func updateSection3Data(with indexPath: IndexPath){
        sourceLocationLabel3.text = "Source \(indexPath.row + 1)"
        destinationLocationLabel3.text = "Destination \(indexPath.row + 1)"
        sourceTimeLabel3.text = "Source Time \(indexPath.row + 1)"
        rideFareLabel3.text = "Ride Fare \(indexPath.row + 1)"
        vehicleLogoImage3.image = UIImage(systemName: "car.fill")
    }
}
