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
    @IBOutlet weak var chevronButton: UIButton!
    
//    override class func awakeFromNib() {
//        <#code#>
//    }
    
    func updateSection1Data(with rideHistory: RideHistory){
        sourceLocationLabel.text = rideHistory.source.address
        destinationLocationLabel.text = rideHistory.destination.address
        sourceTimeLabel.text = rideHistory.source.time
        rideFareLabel.text = "\(rideHistory.fare)"
        if rideHistory.serviceProvider.rideType.vehicleType == .car{
            vehicleLogoImage.image = UIImage(systemName: "car.fill")
        }else {
            vehicleLogoImage.image = UIImage(systemName: "bus.fill")
        }
    }
    
    func updateSection2Data(with rideHistory: RideHistory){
        sourceLocationLabel.text = rideHistory.source.address
        destinationLocationLabel.text = rideHistory.destination.address
        sourceTimeLabel.text = rideHistory.source.time
        rideFareLabel.text = "\(rideHistory.fare)"
        if rideHistory.serviceProvider.rideType.vehicleType == .car{
            vehicleLogoImage.image = UIImage(systemName: "car.fill")
        }else {
            vehicleLogoImage.image = UIImage(systemName: "bus.fill")
        }
    }
    
    func updateSection3Data(with rideHistory: RideHistory){
        sourceLocationLabel.text = rideHistory.source.address
        destinationLocationLabel.text = rideHistory.destination.address
        sourceTimeLabel.text = rideHistory.source.time
        rideFareLabel.text = "\(rideHistory.fare)"
        if rideHistory.serviceProvider.rideType.vehicleType == .car{
            vehicleLogoImage.image = UIImage(systemName: "car.fill")
        }else {
            vehicleLogoImage.image = UIImage(systemName: "bus.fill")
        }
    }
}
