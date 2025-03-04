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
//      @IBOutlet weak var sourceDateLabel: UILabel!
    
    
        @IBOutlet weak var rideFareLabel: UILabel!
//      @IBOutlet weak var vehicleLogoImage: UIImageView!
        @IBOutlet weak var vehicleLogoButton: UIButton!
        @IBOutlet weak var rideDateButton: UIButton!
    
        @IBOutlet weak var reBookButton: UIButton!
    
    
    
            func updatePreviousData(with rideHistory: RidesHistory){
            sourceLocationLabel.text = rideHistory.source.address
            destinationLocationLabel.text = rideHistory.destination.address
            
            print(rideHistory.date)
            print(convertDateString(rideHistory.date))
            
            rideDateButton.setTitle(convertDateString(rideHistory.date), for: .normal)
            
            rideFareLabel.text = "\(rideHistory.fare)"
            if rideHistory.serviceProvider.rideType.vehicleType == .bus{

                
                vehicleLogoButton.setImage(UIImage(systemName: "bus.fill"), for: .normal)
                
                vehicleLogoButton.setTitle("Bus", for: .normal)
                
            }else{
                
                vehicleLogoButton.setImage(UIImage(systemName: "car.fill"), for: .normal)
                
                vehicleLogoButton.setTitle("Car", for: .normal)
            }
        }
    
    func convertDateString(_ dateString: String) -> String? {
        // Step 1: Create a DateFormatter to parse the input string (yyyy:mm:dd format)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        // Step 2: Convert the string to a Date object
        if let date = inputFormatter.date(from: dateString) {
            
            // Step 3: Create another DateFormatter to format the Date in dd-MMM format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM"
            
            // Step 4: Return the formatted string
            return outputFormatter.string(from: date).uppercased() // Uppercased for the month abbreviation (e.g., JAN instead of jan)
        }
        
        return nil // If the date string is invalid
    }

}
