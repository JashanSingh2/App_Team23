//
//  myRideSection2CollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class MyRideSection2CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sourceLocationLabel2: UILabel!
    @IBOutlet weak var destinationLocationLabel2: UILabel!
    @IBOutlet weak var sourceTimeLabel2: UILabel!
    @IBOutlet weak var rideFareLabel2: UILabel!
    @IBOutlet weak var vehicleLogoImage2: UIImageView!
    
    
    func updateSection2Data(with IndexPath: IndexPath){
        sourceLocationLabel2.text = "Source: \(IndexPath.row + 1)"
        destinationLocationLabel2.text = "Destination: \(IndexPath.row + 1)"
        sourceTimeLabel2.text = "10:00 AM"
        rideFareLabel2.text = "100"
        vehicleLogoImage2.image = UIImage(systemName: "car.fill")
    }
}
